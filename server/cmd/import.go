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
	ClientUUID              string                      `json:"clientUUID"`
	ClientRunList           []clientRun                 `json:"runList"`
	QuestionnaireResultList []clientQuestionnaireResult `json:"questionnaireResults"`
}

type clientRun struct {
	UserLog   clientUserLog   `json:"userLog"`
	UserState clientUserState `json:"userState"`
}

type clientUserLog struct {
	UUID                     string `json:"uuid"`
	AccessMethod             string `json:"accessMethod"`
	SpatialSpanTask          int    `json:"UserGameType.spatialSpanTask"`
	PsychomotorVigilanceTask []int  `json:"UserGameType.psychomotorVigilanceTask"`
	TimeStamp                string `json:"timestamp"`
}

func (ul clientUserLog) toAccessMethod() AccessMethod { return 0 }           // FIXME implement me
func (ul clientUserLog) getTime() time.Time           { return time.Time{} } // FIXME implement me

type clientUserState struct {
	UUID            string `json:"uuid"`
	CurrentActivity string `json:"currentActivity"`
	CurrentMood     string `json:"currentMood"`
	TimeStamp       string `json:"timestamp"`
}

func (us clientUserState) toMood() Mood         { return 0 }           // FIXME implement me
func (us clientUserState) toActivity() Activity { return 0 }           // FIXME implement me
func (us clientUserState) getTime() time.Time   { return time.Time{} } // FIXME implement me

type clientQuestionnaireResult struct {
	UUID      string `json:"uuid"`
	Question  string `json:"question"`
	Answer    string `json:"answer"`
	TimeStamp string `json:"timestamp"`
}

func (qr clientQuestionnaireResult) getTime() time.Time { return time.Time{} } // FIXME implement me

func fromClientJSON(in []byte) (clientJSON, error) {
	var parsedJSON clientJSON
	err := json.Unmarshal(in, &parsedJSON)

	return parsedJSON, err
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

	newUser := User{StudyID: study.ID}
	if db.Model(&newUser).Where("client_uuid = ?", c.ClientUUID).Updates(&newUser).RowsAffected == 0 {
		db.Create(&newUser)
	}

	for _, pair := range c.ClientRunList {
		newSSTResult := SSTResult{SSTResultValue: pair.UserLog.SpatialSpanTask}
		newPVTResult := PVTResult{PVTResultValue: pair.UserLog.PsychomotorVigilanceTask}

		if err := db.Create(&newSSTResult).Error; err != nil {
			return errors.Wrap(err, "failed to create database entry")
		}
		if err := db.Create(&newPVTResult).Error; err != nil {
			return errors.Wrap(err, "failed to create database entry")
		}

		// NOTE use the earlier timestamp
		timestamp := pair.UserLog.getTime()
		if pair.UserState.getTime().Before(timestamp) {
			timestamp = pair.UserState.getTime()
		}

		ul := UserLog{
			UserID:       newUser.ID,
			Mood:         pair.UserState.toMood(),
			Activity:     pair.UserState.toActivity(),
			AccessMethod: pair.UserLog.toAccessMethod(),
			SSTResultID:  newSSTResult.ID,
			PVTResultID:  newPVTResult.ID,
			TimeStamp:    timestamp,
		}
		if err := db.Create(&ul).Error; err != nil {
			return err
		}
	}

	for _, jQR := range c.QuestionnaireResultList {
		// search or create answer and question matching the text
		ql := QuestionnaireLog{UserID: newUser.ID, Timestamp: jQR.getTime()}
		db.Create(&ql)

		q := Question{
			StudyID:      study.ID,
			QuestionText: jQR.Question,
		}
		// Update or create
		if db.Model(&q).Where("question_text = ?", q.QuestionText).Updates(&q).RowsAffected == 0 {
			db.Create(&q)
		}

		a := Answer{
			QuestionID: q.ID,
			AnswerText: jQR.Answer,
		}
		// Update or create
		if db.Model(&a).Where("answer_text = ?", a.AnswerText).Updates(&a).RowsAffected == 0 {
			db.Create(&a)
		}

		qr := QuestionnaireResult{
			QuestionnaireLogID: ql.ID,
			QuestionID:         q.ID,
			AnswerID:           a.ID,
		}
		db.Create(&qr)
	}
	return nil
}
