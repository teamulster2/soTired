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

	"github.com/pkg/errors"
	"github.com/spf13/cobra"
)

// The data flow on the server can be described in 4 steps:
// - the server reads the json file, parses the data from json format to go structs (jsonConfig and jsonQuestionWithAnswers)
// - db table instances (study, question, answer, notificationTime) are created with the information contained in the structs (validation of the config file)
// - the db entries are taken from the db tables and the information is put together in one go struct (studyData)
// - the struct data is transformed into a string and send to the client

type jsonConfig struct {
	ServerVersion                     string                    `json:"serverVersion"`
	NotificationText                  string                    `json:"notificationText"`
	IsMentalArithmeticEnabled         bool                      `json:"isMentalArithmeticEnabled"`
	IsSpatialSpanTaskEnabled          bool                      `json:"isSpatialSpanTaskEnabled"`
	IsPsychomotorVigilanceTaskEnabled bool                      `json:"isPsychomotorVigilanceTaskEnabled"`
	IsQuestionnaireEnabled            bool                      `json:"isQuestionnaireEnabled"`
	IsCurrentActivityEnabled          bool                      `json:"isCurrentActivityEnabled"`
	StudyName                         string                    `json:"studyName"`
	UTCNotificationTimes              []string                  `json:"utcNotificationTimes"`
	Questionnaire                     []jsonQuestionWithAnswers `json:"questions"`
}

type jsonQuestionWithAnswers struct {
	Question string   `json:"question"`
	Answers  []string `json:"answers"`
}

type studyData struct {
	ServerVersion       string
	Study               Study
	IsStudy             bool                  `json:"isStudy"`
	UTCNotificationTime []string              `json:"utcNotificationTimes"`
	Questions           []questionWithAnswers `json:"questions"`
}

type questionWithAnswers struct {
	Question Question
	Answers  []Answer
}

func serveRun(cmd *cobra.Command, args []string) {
	// Get cobra arguments
	dbPath, err := cmd.Flags().GetString(dbPathFlag)
	if err != nil {
		fmt.Println(errors.Wrap(err, "missing db path argument"))
	}
	configPath, err := cmd.Flags().GetString(configPathFlag)
	if err != nil {
		fmt.Println(errors.Wrap(err, "missing config path argument"))
	}

	// Set routing rules
	http.HandleFunc("/", root)
	http.HandleFunc("/config", config(configPath, dbPath))
	http.HandleFunc("/identity", identity)
	http.HandleFunc("/data", data)
	addr := fmt.Sprintf(":%s", cmd.Flag("port").Value.String())
	fmt.Println("Start to listen on:", addr)

	// Use default DefaultServeMux
	if err := http.ListenAndServe(addr, nil); err != nil {
		log.Fatal(err)
	}
}

func root(w http.ResponseWriter, r *http.Request) {
	io.WriteString(w, "empty reply")
}

func config(configPath string, dbPath string) func(w http.ResponseWriter, r *http.Request) {
	return func(w http.ResponseWriter, r *http.Request) {
		io.ReadAll(r.Body)

		content, err := ioutil.ReadFile(configPath)
		if err != nil {
			log.Fatal("Error when opening config file: ", err)
		}
		var jsonConfig jsonConfig
		err = json.Unmarshal(content, &jsonConfig)
		if err != nil {
			log.Fatal("Error during unmarshaling config data: ", err)
		}

		db, err := gorm.Open(sqlite.Open(dbPath), &gorm.Config{})
		if err != nil {
			panic("Failed to connect database")
		}
		db.AutoMigrate(&Study{}, &Question{}, &Answer{}, &UTCNotificationTime{})
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
		utcNotificationTimes := make([]string, 0, len(jsonConfig.UTCNotificationTimes))
		for _, notificationTime := range jsonConfig.UTCNotificationTimes {
			db.Create(&UTCNotificationTime{
				Time:    notificationTime,
				StudyID: study.ID,
			})
			utcNotificationTimes = append(utcNotificationTimes, notificationTime)
		}
		questions := make([]questionWithAnswers, 0, len(jsonConfig.Questionnaire))
		for _, jsonQuestionWithAnswers := range jsonConfig.Questionnaire {
			question := Question{
				StudyID:      study.ID,
				QuestionText: jsonQuestionWithAnswers.Question,
			}
			db.Create(&question)
			var answers []Answer
			for _, answer := range jsonQuestionWithAnswers.Answers {
				answer := Answer{
					QuestionID: question.ID,
					AnswerText: answer,
				}
				db.Create(&answer)
				answers = append(answers, answer)
			}
			questions = append(questions, questionWithAnswers{Answers: answers, Question: question})
		}

		studyData := &studyData{
			ServerVersion:       jsonConfig.ServerVersion,
			Study:               study,
			IsStudy:             true,
			UTCNotificationTime: utcNotificationTimes,
			Questions:           questions,
		}

		studyDataAsBytes, err := json.MarshalIndent(&studyData, "", "    ")
		if err != nil {
			log.Fatal("Error during marsheling study data: ", err)
			return
		}
		io.WriteString(w, string(studyDataAsBytes))
		fmt.Println("Replied config")
	}
}

func identity(w http.ResponseWriter, r *http.Request) {
	io.WriteString(w, "sotiserver")
	fmt.Println("Replied identity")
}

func data(w http.ResponseWriter, r *http.Request) {
	io.WriteString(w, "thanks for the data")
	fmt.Println("Recieved data")
}
