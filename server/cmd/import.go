package cmd

import (
	"encoding/json"
	"time"

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
		return err
	}
	var study Study
	if err := studyDB.Find(&study).Error; err != nil {
		return err
	}
	// create new user for each send database since we dont want to track them
	var newUser User
	db.Create(&newUser)

	for _, pair := range createPairs(c.UserLogList, c.UserStateList) {
		newMood := pair.userState.toMood()
		newActivity := pair.userState.toActivity()
		newAccessMethod := pair.userLog.toAccessMethod()
		newSSTResult := SSTResult{SSTResultValue: pair.userLog.SpatialSpanTask}
		newPVTResult := PVTResult{PVTResultValue: pair.userLog.PsychomotorVigilanceTask}

		// FIXME error checks
		db.Create(&newMood)
		db.Create(&newActivity)
		db.Create(&newAccessMethod)

		// NOTE use the earlier timestamp
		timestamp := pair.userLog.getTime()
		if pair.userState.getTime().Before(timestamp) {
			timestamp = pair.userState.getTime()
		}

		ul := UserLog{
			UserID:       newUser.ID,
			Mood:         newMood,
			Activity:     newActivity,
			AccessMethod: newAccessMethod,
			SSTResultID:  newSSTResult.ID,
			PVTResultID:  newPVTResult.ID,
			TimeStamp:    timestamp,
		}
		db.Create(&ul)
	}

	studyDB.Find(&c.UserLogList)
	studyDB.Find(&c.UserStateList)
	studyDB.Find(&c.QuestionnaireResultList)

	return nil
}
