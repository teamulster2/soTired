package cmd

import (
	"errors"
	"gorm.io/gorm"
	"strconv"
	"strings"
	"time"
)

// Study holds the configuration data and is refered by multiple users.
type Study struct {
	gorm.Model
	ID                                int
	ServerURL                         string
	StudyName                         string
	NotificationText                  string
	IsSpartalTaskEnabled              bool
	IsPsychomotorVigilanceTaskEnabled bool
	IsReactionGameEnabled             bool
	IsQuestionnaireEnabled            bool
	IsCurrentActivityEnabled          bool
}

// NotificationTime holds the times when the user gets a app notification
type NotificationTime struct {
	ID      int
	StudyID int
	Time    string
}

// BeforeCreate is a hook to validate the Time field entry
func (n *NotificationTime) BeforeCreate(tx *gorm.DB) (err error) {
	if !n.isValid() {
		err = errors.New("can't save invalid data")
	}
	return
}

func (n *NotificationTime) isValid() bool {
	parts := strings.Split(n.Time, ":")
	if len(parts) != 2 {
		return false
	}
	if len(parts[0]) < 2 || len(parts[1]) < 2 {
		return false
	}
	var h, m int64
	var err error
	if h, err = strconv.ParseInt(parts[0], 10, 64); err != nil {
		return false
	}
	if m, err = strconv.ParseInt(parts[1], 10, 64); err != nil {
		return false
	}
	if h >= 24 || h < 0 || m >= 60 || m < 0 {
		return false
	}
	return true

}

// User binds the data from one user
type User struct {
	gorm.Model
	ID      int
	StudyID int
}

// UserLog binds the data from an execution flow to an user and a timestamp.
type UserLog struct {
	gorm.Model
	UserID              int
	MoodID              int
	ActivityID          int
	AccessMethodID      int
	SSTResultID         int
	PVTResultID         int
	ReationGameResultID int
	TimeStamp           time.Time
}

// Mood holds the provided mood of an user.
type Mood int

const (
	// Happy is the highest mood
	Happy Mood = iota
	// Exited is the second highest mood
	Exited
	// Bored is the second lowest mood
	Bored
	// Sad is the lowest Mood
	Sad
)

// Activity holds the provided activity of an user.
type Activity int

const (
	// Home location
	Home Activity = iota
	// Work location
	Work
	// University location
	University
	// Shops location
	Shops
	// FriendsOrFamily location
	FriendsOrFamily
	// Other location
	Other
)

// AccessMethod holds the provided accessMethod an user.
type AccessMethod int

const (
	// Notification over the app
	Notification AccessMethod = iota
	// RegulareAppStart by user
	RegulareAppStart
	// InviteLink lead to start of app
	InviteLink
)

// SSTResult holds the sstResult value.
type SSTResult struct {
	gorm.Model
	ID             int
	SSTResultValue int
}

// PVTResult holds the pvtResult value.
type PVTResult struct {
	gorm.Model
	ID             int
	PVTResultValue int
}

// ReationGameResult holds the Result of Reaction time measuring game
type ReationGameResult struct {
	gorm.Model
	ID                     int
	ReationGameResultValue int
}

// QuestionnaireLog binds the questionnaire results to an user and a timestamp.
type QuestionnaireLog struct {
	gorm.Model
	ID        int
	UserID    int
	timestamp time.Time
}

// QuestionnaireResult holds the results from a questionnaire execution.
type QuestionnaireResult struct {
	gorm.Model
	ID                 int
	AnswerID           int
	QuestionID         int
	QuestionnaireLogID int
}

// Question holds the question text and a reference to the corresponding tudy.
type Question struct {
	gorm.Model
	ID           int
	StudyID      int
	QuestionText string
}

// Answer holds the answer text and a reference to the question.
type Answer struct {
	gorm.Model
	ID         int
	QuestionID int
	AnswerText string
}
