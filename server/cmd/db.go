package cmd

import (
	"fmt"

	"gorm.io/gorm"
)

func toJSONStudyList(db *gorm.DB) []jsonStudy {
	var allStudies []Study
	db.Find(&allStudies)
	allJSONStudies := make([]jsonStudy, 0, len(allStudies))
	for _, study := range allStudies {
		studyDB := db.Where(&study)
		jStudy := jsonStudy{study: study}

		jStudy.fill(studyDB)
		for _, jUser := range jStudy.userList {
			userDB := studyDB.Where(&jUser.user)
			jUser.fill(userDB)
			for _, jQLog := range jUser.questionnaireLogList {
				jQLogDB := userDB.Where(&jQLog.question)
				jQLog.fill(jQLogDB)
			}
			for _, jULog := range jUser.userLogList {
				jULogDB := userDB.Where(&jULog.userLog)
				jULog.fill(jULogDB)
			}
		}
		for _, jQuestion := range jStudy.questionList {
			questionDB := studyDB.Where(&jQuestion.question)
			jQuestion.fill(questionDB)
		}

		allJSONStudies = append(allJSONStudies, jStudy)
	}

	return allJSONStudies
}

type jsonStudy struct {
	study        Study
	userList     []jsonUser
	questionList []jsonQuestion
}

func (j *jsonStudy) fill(db *gorm.DB) error {
	if j.study.CreatedAt.IsZero() {
		return fmt.Errorf("Not intialised")
	}
	// filter for this study
	db = db.Where(&j.study)
	if db.Error != nil {
		return db.Error
	}
	// Join all users with this study
	var userList []User
	if err := db.Find(&userList).Error; err != nil {
		return err
	}
	// add all joined users to this jsonStudy
	j.userList = make([]jsonUser, 0, len(userList))
	for _, user := range userList {
		j.userList = append(j.userList, jsonUser{user: user})
	}

	// Join all questions with this study
	var questionList []Question
	if err := db.Find(&questionList).Error; err != nil {
		return err
	}
	// and add all joined questions to this jsonStudy
	j.questionList = make([]jsonQuestion, 0, len(userList))
	for _, question := range questionList {
		j.questionList = append(j.questionList, jsonQuestion{question: question})
	}
	return nil
}

type jsonQuestion struct {
	question   Question
	answerList []Answer
}

func (j *jsonQuestion) fill(db *gorm.DB) error {
	if j.question.CreatedAt.IsZero() {
		return fmt.Errorf("Not intialised")
	}
	// filter for this question
	db = db.Where(&j.question)
	if db.Error != nil {
		return db.Error
	}
	// Join all answers with this question
	if err := db.Find(&j.answerList).Error; err != nil {
		return err
	}

	return nil
}

type jsonUser struct {
	user                 User
	questionnaireLogList []jsonQuestionnaireLog
	userLogList          []jsonUserLog
}

func (j *jsonUser) fill(db *gorm.DB) error {
	if j.user.CreatedAt.IsZero() {
		return fmt.Errorf("Not intialised")
	}
	// filter for this user
	db = db.Where(&j.user)
	if db.Error != nil {
		return db.Error
	}
	// Join all qLogs with this user
	var qLogList []QuestionnaireLog
	if err := db.Find(&qLogList).Error; err != nil {
		return err
	}
	// add all joined qLogs to this jUser
	j.questionnaireLogList = make([]jsonQuestionnaireLog, 0, len(qLogList))
	for _, qLog := range qLogList {
		j.questionnaireLogList = append(j.questionnaireLogList, jsonQuestionnaireLog{questionnaireLog: qLog})
	}

	// Join all UserLogs with this user
	var ULogList []UserLog
	if err := db.Find(&ULogList).Error; err != nil {
		return err
	}
	// and add all joined userLogs to this user
	j.userLogList = make([]jsonUserLog, 0, len(ULogList))
	for _, uLog := range ULogList {
		j.userLogList = append(j.userLogList, jsonUserLog{userLog: uLog})
	}
	return nil
}

type jsonQuestionnaireLog struct {
	questionnaireLog QuestionnaireLog
	question         Question
	answer           Answer
}

func (j *jsonQuestionnaireLog) fill(db *gorm.DB) error {
	if j.questionnaireLog.CreatedAt.IsZero() {
		return fmt.Errorf("Not intialised")
	}
	// filter for this qLog
	qLogDB := db.Where(&j.questionnaireLog)
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
	qResultDB := db.Where(&qResult)
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

	j.question = question
	j.answer = answer
	return nil
}

type jsonUserLog struct {
	userLog   UserLog
	sstResult SSTResult
	pvtResult PVTResult
}

func (j *jsonUserLog) fill(db *gorm.DB) error {
	if j.userLog.CreatedAt.IsZero() {
		return fmt.Errorf("Not intialised")
	}
	// filter for this study
	uLogDB := db.Where(&j.userLog)
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
	j.sstResult = sstResult
	j.pvtResult = pvtResult
	return nil
}
