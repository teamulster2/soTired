package cmd

import "gorm.io/gorm"

func toJSON(db *gorm.DB) {

}

type jsonStudy struct {
	study        Study
	userList     []jsonUser
	questionList []jsonQuestion
}
type jsonQuestion struct {
	question   Question
	AnswerList []jsonAnswer
}
type jsonAnswer struct {
	anwer Answer
}

type jsonUser struct {
	user                 User
	questionnaireLogList []jsonQuestionnaireLog
	userLogList          []jsonUserLog
}
type jsonQuestionnaireLog struct {
	questionnaireLog QuestionnaireLog
	question         Question
	answer           Answer
}
type jsonUserLog struct {
	mood         int
	activity     int
	accessMethod int
	sstResult    SSTResult
	pvtResult    PVTResult
}

type jsonSSTResult struct{}
type jsonPVTResult struct{}

// type jsonQuestionnaireResult struct{} //TODO explain in a comment why this is not necesary

// type jsonMood int
// type jsonActivity int
// type jsonAccessMethod int
