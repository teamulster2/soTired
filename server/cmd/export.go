package cmd

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"os"

	"github.com/pkg/errors"
	"github.com/spf13/cobra"
	"gorm.io/driver/sqlite"
	"gorm.io/gorm"
	"gorm.io/gorm/logger"
)

func exportDatabase(cmd *cobra.Command, args []string) {
	path, err := cmd.Flags().GetString(dbPathFlag)
	if err != nil {
		fmt.Println(errors.Wrap(err, "missing argument for database path"))
		os.Exit(1)
	}
	if _, err := os.Stat(path); os.IsNotExist(err) {
		fmt.Println(errors.Wrap(err, "Failed to open file"))
		os.Exit(1)
	}

	verbose, err := cmd.Flags().GetBool(verboseFlag)
	conf := &gorm.Config{Logger: logger.Default.LogMode(logger.Silent)}
	if verbose {
		conf = &gorm.Config{Logger: logger.Default.LogMode(logger.Info)}
	}

	db, err := gorm.Open(sqlite.Open(path), conf)
	if err != nil {
		fmt.Println(errors.Wrap(err, "Failed to open database"))
		os.Exit(1)
	}
	studys, err := toJSONStudyList(db)
	if err != nil {
		fmt.Println(errors.Wrap(err, "Failed to export the studies from the database"))
		os.Exit(1)
	}
	all := fullDB{
		AllStudies:    studys,
		ServerVersion: "v0.0.0", // FIXME dont hardcode version
	}
	jsonString, err := json.MarshalIndent(all, "", "    ")
	if err != nil {
		fmt.Println(errors.Wrap(err, "Failed to write JSON"))
		os.Exit(1)
	}
	outPath, err := cmd.Flags().GetString(outPathFlag)
	if err != nil {
		fmt.Println(jsonString)
	}
	err = ioutil.WriteFile(outPath, []byte(jsonString), 0644)
	if err != nil {
		fmt.Println(errors.Wrap(err, "Failed to write to file"))
		os.Exit(1)
	}
}

func toJSONStudyList(db *gorm.DB) ([]jsonStudy, error) {
	var allStudies []Study
	if err := db.Find(&allStudies).Error; err != nil {
		return nil, errors.Wrap(err, "can't read data from the database, is it empty?")
	}
	if len(allStudies) == 0 {
		return nil, errors.Errorf("no studies to export")
	}
	allJSONStudies := make([]jsonStudy, 0, len(allStudies))
	for _, study := range allStudies {
		jStudy := jsonStudy{Study: study}

		jStudy.fill(db)
		for i, jUser := range jStudy.UserList {
			err := jUser.fill(db)
			if err != nil {
				return allJSONStudies, err
			}
			for i, jQLog := range jUser.QuestionnaireLogList {
				err := jQLog.fill(db)
				if err != nil {
					return allJSONStudies, err
				}
				jUser.QuestionnaireLogList[i] = jQLog
			}
			for i, jULog := range jUser.UserLogList {
				err := jULog.fill(db)
				if err != nil {
					return allJSONStudies, err
				}
				jUser.UserLogList[i] = jULog
			}
			jStudy.UserList[i] = jUser
		}
		for i, jQuestion := range jStudy.QuestionList {
			err := jQuestion.fill(db)
			if err != nil {
				return allJSONStudies, err
			}
			jStudy.QuestionList[i] = jQuestion
		}

		allJSONStudies = append(allJSONStudies, jStudy)
	}

	return allJSONStudies, nil
}

type fullDB struct {
	ServerVersion string
	AllStudies    []jsonStudy
}

type jsonStudy struct {
	Study        Study
	UserList     []jsonUser
	QuestionList []jsonQuestion
}

func (j *jsonStudy) fill(db *gorm.DB) error {
	if j.Study.CreatedAt.IsZero() {
		return errors.Errorf("Not intialised")
	}
	// filter for this study
	db = db.Where("id = ?", j.Study.ID)
	if db.Error != nil {
		return db.Error
	}
	// Join all users with this study
	var userList []User
	if err := db.Find(&userList).Error; err != nil {
		return err
	}
	// add all joined users to this jsonStudy
	j.UserList = make([]jsonUser, 0, len(userList))
	for _, user := range userList {
		j.UserList = append(j.UserList, jsonUser{User: user})
	}

	// Join all questions with this study
	var questionList []Question
	if err := db.Find(&questionList).Error; err != nil {
		return err
	}
	// and add all joined questions to this jsonStudy
	j.QuestionList = make([]jsonQuestion, 0, len(userList))
	for _, question := range questionList {
		j.QuestionList = append(j.QuestionList, jsonQuestion{Question: question})
	}
	return nil
}

type jsonQuestion struct {
	Question   Question
	AnswerList []Answer
}

func (j *jsonQuestion) fill(db *gorm.DB) error {
	if j.Question.CreatedAt.IsZero() {
		return errors.Errorf("Not intialised")
	}
	// filter for this question
	db = db.Where("id = ?", j.Question.ID)
	if db.Error != nil {
		return db.Error
	}
	// Join all answers with this question
	if err := db.Find(&j.AnswerList).Error; err != nil {
		return err
	}

	return nil
}

type jsonUser struct {
	User                 User
	QuestionnaireLogList []jsonQuestionnaireLog
	UserLogList          []jsonUserLog
}

func (j *jsonUser) fill(db *gorm.DB) error {
	if j.User.CreatedAt.IsZero() {
		return errors.Errorf("Not intialised")
	}
	// filter for this user
	db = db.Where("id = ?", j.User.ID)
	if db.Error != nil {
		return db.Error
	}
	// Join all qLogs with this user
	var qLogList []QuestionnaireLog
	if err := db.Find(&qLogList).Error; err != nil {
		return err
	}
	// add all joined qLogs to this jUser
	j.QuestionnaireLogList = make([]jsonQuestionnaireLog, 0, len(qLogList))
	for _, QLog := range qLogList {
		j.QuestionnaireLogList = append(j.QuestionnaireLogList, jsonQuestionnaireLog{QuestionnaireLog: QLog})
	}

	// Join all UserLogs with this user
	var ULogList []UserLog
	if err := db.Find(&ULogList).Error; err != nil {
		return err
	}
	// and add all joined userLogs to this user
	j.UserLogList = make([]jsonUserLog, 0, len(ULogList))
	for _, uLog := range ULogList {
		j.UserLogList = append(j.UserLogList, jsonUserLog{UserLog: uLog})
	}
	return nil
}

type jsonQuestionnaireLog struct {
	QuestionnaireLog QuestionnaireLog
	Question         Question
	Answer           Answer
}

func (j *jsonQuestionnaireLog) fill(db *gorm.DB) error {
	if j.QuestionnaireLog.CreatedAt.IsZero() {
		return errors.Errorf("Not intialised")
	}
	// filter for this qLog
	qLogDB := db.Where("id = ?", j.QuestionnaireLog.ID)
	if db.Error != nil {
		return db.Error
	}
	// Join all QuestionnaireResult with this qLog
	var qResult QuestionnaireResult
	// NOTE: Since QuestionaireResult is just a means to an end to connect questions and answers it is not part of of the json output.
	if err := qLogDB.Take(&qResult).Error; err != nil {
		return err
	}
	// Filter for this qLog
	qResultDB := db.Where("id = ?", qResult.ID)
	if err := qResultDB.Error; err != nil {
		return err
	}

	// Join all questions with this qResult
	var question Question
	if err := qResultDB.Take(&question).Error; err != nil {
		return err
	}
	// Join all answer with this qResult
	var answer Answer
	if err := qResultDB.Take(&answer).Error; err != nil {
		return err
	}

	j.Question = question
	j.Answer = answer
	return nil
}

type jsonUserLog struct {
	UserLog                UserLog
	SstResult              SSTResult
	PvtResult              PVTResult
	MentalArithmeticResult MentalArithmeticResult
}

func (j *jsonUserLog) fill(db *gorm.DB) error {
	if j.UserLog.CreatedAt.IsZero() {
		return errors.Errorf("Not intialised")
	}
	// filter for this study
	uLogDB := db.Where("id = ?", j.UserLog.ID)
	if uLogDB.Error != nil {
		return db.Error
	}
	var sstResult SSTResult
	if err := uLogDB.Take(&sstResult).Error; err != nil {
		return err
	}
	var pvtResult PVTResult
	if err := uLogDB.Take(&pvtResult).Error; err != nil {
		return err
	}
	j.SstResult = sstResult
	j.PvtResult = pvtResult
	return nil
}
