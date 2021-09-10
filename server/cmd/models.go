package cmd

import (
	"gorm.io/gorm"
	"time"
)

// Study holds the configuration data and is refered by multiple users.
type Study struct {
	gorm.Model
	ID                                int
	ServerURL                         string
	StudyName                         string
	NotificationInterval              int
	NotificationText                  string
	IsSpartalTaskEnabled              bool
	IsPsychomotorVigilanceTaskEnabled bool
	IsQuestionnaireEnabled            bool
	IsCurrentActivityEnabled          bool
}

// User binds the data from one user
type User struct {
	gorm.Model
	ID      int
	StudyID int
	Study   Study
}

// UserLog binds the data from an execution flow to an user and a timestamp.
type UserLog struct {
	gorm.Model
	UserID         int
	User           User
	MoodID         int
	Mood           Mood
	ActivityID     int
	Activity       Activity
	AccessMethodID int
	AccessMethod   AccessMethod
	SSTID          int
	SSTResult      SSTResult
	PVTID          int
	PVTResult      PVTResult
	TimeStamp      time.Time
}

// Mood holds the provided mood of an user.
type Mood struct {
	gorm.Model
	ID   int
	Mood string
}

// Activity holds the provided activity of an user.
type Activity struct {
	gorm.Model
	Activity string
}

// AccessMethod holds the provided accessMethod an user.
type AccessMethod struct {
	gorm.Model
	ID           int
	AccessMethod string
}

// SSTResult holds the sstResult value.
type SSTResult struct {
	gorm.Model
	ID        int
	SSTResult int
}

// PVTResult holds the pvtResult value.
type PVTResult struct {
	gorm.Model
	ID        int
	PVTResult int
}

// QuestionnaireLog binds the questionnaire results to an user and a timestamp.
type QuestionnaireLog struct {
	gorm.Model
	ID        int
	timestamp time.Time
}

// QuestionnaireResult holds the results from a questionnaire execution.
type QuestionnaireResult struct {
	gorm.Model
	ID                 int
	AnswerID           int
	Answer             Answer
	QuestionID         int
	Question           Question
	QuestionnaireLogID int
	QuestionnaireLog   QuestionnaireLog
}

// Question holds the question text and a reference to the corresponding study.
type Question struct {
	gorm.Model
	ID       int
	StudyID  int
	Study    Study
	Question string
}

// Answer holds the answer text and a reference to the question.
type Answer struct {
	gorm.Model
	QuestionID int
	Question   Question
	Answer     string
}
