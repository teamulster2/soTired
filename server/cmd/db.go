package cmd

import (
	"github.com/pkg/errors"
	"gorm.io/gorm"
)

func toJSONStudyList(db *gorm.DB) ([]jsonStudy, error) {
	var allStudies []Study
	if err := db.Find(&allStudies).Error; err != nil {
		return nil, err
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
