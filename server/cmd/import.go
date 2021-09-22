package cmd

import "encoding/json"

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

type clientUserStates struct {
	UUID            string `json:"uuid"`
	CurrentActivity string `json:"currentActivity"`
	CurrentMood     string `json:"currentMood"`
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
