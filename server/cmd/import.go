package cmd

import (
	"encoding/json"
	"fmt"
	"time"

	"github.com/pkg/errors"
	"gorm.io/gorm"
)

type clientJSON struct {
	StudyName               string                      `json:"studyName"`
	ClientVersion           string                      `json:"clientVersion"`
	UserLogList             []clientUserLog             `json:"userLogs"`
	UserStateList           []clientUserStates          `json:"userStates"`
	QuestionnaireResultList []clientQuestionnaireResult `json:"questionnaireResults"`
}

type clientUserLog struct {
	UUID                     string `json:"uuid"`
	AccessMethod             string `json:"accessMethod"`
	SpatialSpanTask          int    `json:"spatialSpanTask"`
	PsychomotorVigilanceTask int    `json:"psychomotorVigilanceTask"`
	TimeStamp                string `json:"timestamp"`
}

func (ul clientUserLog) toAccessMethod() AccessMethod {
	// FIXME implement me
	return 0
}

func (ul clientUserLog) getTime() time.Time {
	// FIXME implement
	return time.Time{}

}

type clientUserStates struct {
	UUID            string `json:"uuid"`
	CurrentActivity string `json:"currentActivity"`
	CurrentMood     string `json:"currentMood"`
	TimeStamp       string `json:"timestamp"`
}

func (us clientUserStates) toMood() Mood {
	// FIXME implement me
	return 0
}

func (us clientUserStates) toActivity() Activity {
	// FIXME implement me
	return 0
}

func (us clientUserStates) getTime() time.Time {
	// FIXME implement
	return time.Time{}

}

type clientQuestionnaireResult struct {
	UUID     string `json:"uuid"`
	Question int    `json:"question"`
	Answer   int    `json:"answer"`
}

func fromClientJSON(in []byte) (clientJSON, error) {
	var parsedJSON clientJSON
	err := json.Unmarshal(in, &parsedJSON)

	return parsedJSON, err
}

type logStatPair struct {
	userLog   clientUserLog
	userState clientUserStates
}

func createPairs(logList []clientUserLog, stateList []clientUserStates) []logStatPair {
	return []logStatPair{}
}

func (c clientJSON) clientJSONToDB(db *gorm.DB) error {
	// search for existing study
	studyDB := db.Where("study_name = ?", c.StudyName)
	if err := studyDB.Error; err != nil {
		return errors.Wrap(err, fmt.Sprintf("failed to find a study with this name: %s:", c.StudyName))
	}
	var study Study
	if err := studyDB.Find(&study).Error; err != nil {
		return errors.Wrap(err, fmt.Sprintf("failed to find a study with this name: %s:", c.StudyName))
	}
	// create new user for each send database since we dont want to track them
	newUser := User{StudyID: study.ID}
	db.Create(&newUser)

	for _, pair := range createPairs(c.UserLogList, c.UserStateList) {
		newSSTResult := SSTResult{SSTResultValue: pair.userLog.SpatialSpanTask}
		newPVTResult := PVTResult{PVTResultValue: pair.userLog.PsychomotorVigilanceTask}

		if err := db.Create(&newSSTResult).Error; err != nil {
			return errors.Wrap(err, "failed to crete database entry")
		}
		if err := db.Create(&newPVTResult).Error; err != nil {
			return errors.Wrap(err, "failed to crete database entry")
		}

		// NOTE use the earlier timestamp
		timestamp := pair.userLog.getTime()
		if pair.userState.getTime().Before(timestamp) {
			timestamp = pair.userState.getTime()
		}

		ul := UserLog{
			UserID:       newUser.ID,
			Mood:         pair.userState.toMood(),
			Activity:     pair.userState.toActivity(),
			AccessMethod: pair.userLog.toAccessMethod(),
			SSTResultID:  newSSTResult.ID,
			PVTResultID:  newPVTResult.ID,
			TimeStamp:    timestamp,
		}
		if err := db.Create(&ul).Error; err != nil {
			return err
		}
	}
	// return early because of Notes below
	return nil

	// FIXME wait for the client to fix the question and answer fields to string for the later block to be usefull
	for _, jQR := range c.QuestionnaireResultList {
		ql := QuestionnaireLog{UserID: newUser.ID}
		db.Create(&ql)
		// NOTE question and anserIDs are left out hear since the client send yet the wrong type: int
		// which is a internal representation/reference of the client database from which we can not infer the correct corresponing questions and answers.
		_ = jQR
		// FIXME after the json field has the correct type of a string
		// search for the correct question and answer and add them here
		qr := QuestionnaireResult{QuestionnaireLogID: ql.ID}
		db.Create(&qr)

	}
	panic("should not be yet reachable")
}
