package cmd

import (
	"encoding/json"
	"fmt"
	"io"
	"io/ioutil"
	"log"
	"net/http"

	"gorm.io/driver/sqlite"
	"gorm.io/gorm"

	"github.com/spf13/cobra"
)

// The data flow on the server can be described in 4 steps:
// - the server reads the json file, parses the data from json format to go structs (jsonConfig and jsonQuestionWithAnswers)
// - db table instances (study, question, answer, notificationTime) are created with the information contained in the structs (validation of the config file)
// - the db entries are taken from the db tables and the information is put together in one go struct (studyData)
// - the struct data is transformed into a string and send to the client

type jsonConfig struct {
	NotificationText                  string   `json:"notificationText"`
	IsMentalArithmeticEnabled         bool     `json:"isMentalArithmeticEnabled"`
	IsSpatialSpanTaskEnabled          bool     `json:"isSpatialSpanTaskEnabled"`
	IsPsychomotorVigilanceTaskEnabled bool     `json:"isPsychomotorVigilanceTaskEnabled"`
	IsQuestionnaireEnabled            bool     `json:"isQuestionnaireEnabled"`
	IsCurrentActivityEnabled          bool     `json:"isCurrentActivityEnabled"`
	StudyName                         string   `json:"studyName"`
	NotificationTimes                 []string `json:"notificationTimes"`
	Questionnaire                     []jsonQuestionWithAnswers
}

type jsonQuestionWithAnswers struct {
	Question string   `json:"question"`
	Answers  []string `json:"answers"`
}

type studyData struct {
	Study             Study
	IsStudy           bool
	NotificationTimes []string
	Questionnaire     []questionWithAnswers
}

type questionWithAnswers struct {
	Question Question
	Answers  []Answer
}

func serveRun(cmd *cobra.Command, args []string) {
	// Set routing rules
	http.HandleFunc("/", root)
	http.HandleFunc("/config", config)
	addr := fmt.Sprintf(":%s", cmd.Flag("port").Value.String())
	fmt.Println("Start to listen on:", addr)
	// Use the default DefaultServeMux
	err := http.ListenAndServe(addr, nil)
	if err != nil {
		log.Fatal(err)
	}
}

func root(w http.ResponseWriter, r *http.Request) {
	io.WriteString(w, "empty reply")
}

func config(w http.ResponseWriter, r *http.Request) {
	io.ReadAll(r.Body)

	// Create study entry in db from  config data
	content, err := ioutil.ReadFile("./config.json")
	if err != nil {
		log.Fatal("Error when opening config file: ", err)
		fmt.Println("Error when opening config file: ", err)
	}
	var jsonConfig jsonConfig
	err = json.Unmarshal(content, &jsonConfig)
	if err != nil {
		log.Fatal("Error during unmarshaling config data: ", err)
		fmt.Println("Error during unmarshaling config data: ", err)
	}

	db, err := gorm.Open(sqlite.Open("test.db"), &gorm.Config{})
	if err != nil {
		panic("Failed to connect database")
	}
	db.AutoMigrate(&Study{}, &Question{}, &Answer{}, &NotificationTime{})
	study := Study{
		StudyName:                         jsonConfig.StudyName,
		NotificationText:                  jsonConfig.NotificationText,
		IsSpatialSpanTaskEnabled:          jsonConfig.IsSpatialSpanTaskEnabled,
		IsPsychomotorVigilanceTaskEnabled: jsonConfig.IsPsychomotorVigilanceTaskEnabled,
		IsMentalArithmeticEnabled:         jsonConfig.IsMentalArithmeticEnabled,
		IsQuestionnaireEnabled:            jsonConfig.IsQuestionnaireEnabled,
		IsCurrentActivityEnabled:          jsonConfig.IsCurrentActivityEnabled,
	}
	db.Create(&study)
	notificationTimes := make([]string, 0, len(jsonConfig.NotificationTimes))
	for _, notificationTime := range jsonConfig.NotificationTimes {
		db.Create(&notificationTime)
		notificationTimes = append(notificationTimes, notificationTime)
	}
	questionnaire := make([]questionWithAnswers, 0, len(jsonConfig.Questionnaire))
	for _, jsonQuestionWithAnswers := range jsonConfig.Questionnaire {
		question := Question{
			StudyID:      study.ID,
			QuestionText: jsonQuestionWithAnswers.Question,
		}
		db.Create(&question)
		for _, answer := range jsonQuestionWithAnswers.Answers {
			answer := Answer{
				QuestionID: question.ID,
				AnswerText: answer,
			}
			db.Create(&answer)
		}
		var answers []Answer
		db.Where("question_id = ?", question.ID).Find(&answers)
		questionnaire = append(questionnaire, questionWithAnswers{Answers: answers, Question: question})
	}

<<<<<<< HEAD
	studyData := &studyData{
		Study:             study,
		IsStudy:           true,
		NotificationTimes: notificationTimes,
		Questionnaire:     questionnaire,
=======
	// Read study entry from db, create json and send to client
	var studyFromDB Study
	db.First(&studyFromDB, studyFromFile.ID)
	if &studyFromDB == nil {
		log.Fatal("Failed to retrieve study data from db")
		fmt.Println("Failed to retrieve study data from db")
		return
>>>>>>> bb354e1... [issue/64] - Add debug print to server, Fix HandlerFunc server
	}

	studyDataAsBytes, err := json.MarshalIndent(&studyData, "", "    ")
	if err != nil {
		log.Fatal("Error during marsheling study data: ", err)
		fmt.Println("Error during marsheling study data: ", err)
		return
	}
	io.WriteString(w, string(studyDataAsBytes))
	fmt.Println("replied config: ", string(studyDataAsBytes))
}

func data(w http.ResponseWriter, r *http.Request) {
	io.WriteString(w, "thanks for the data")
	fmt.Println("recieved data")
}

// func config(w http.ResponseWriter, r *http.Request) {
// 	_, _ := io.ReadAll(r.Body)
// 	io.WriteString(w, "it's a config for you")
// 	fmt.Println("replyed config")
// }
//
// func data(w http.ResponseWriter, r *http.Request) {
// 	io.WriteString(w, "thanks for the data")
//
// 	fmt.Println("recieved data")
// }
