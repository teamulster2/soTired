package cmd

type clientJSON struct {
	StudyName               string                      `json:"studyName"`
	ClientVersion           string                      `json:"clientVersion"`
	UserLogList             []clientUserLog             `json:"UserLogs"`
	UserStateList           []clientUserStates          `json:"UserStates"`
	QuestionnaireResultList []clientQuestionnaireResult `json:"QuestionnaireResults"`
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
	Question string `json:"question"`
	Answer   string `json:"answer"`
}
