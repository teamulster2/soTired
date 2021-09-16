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

type jSONConfig struct {
	ServerURL                         string `json:"serverUrl"`
	NotificationInterval              int    `json:"notificationInterval"`
	NotificationText                  string `json:"notificationText"`
	IsReactionGameEnabled             bool   `json:"isReactionGameEnabled"`
	IsSpartalTaskEnabled              bool   `json:"isSpartalTaskEnabled"`
	IsPsychomotorVigilanceTaskEnabled bool   `json:"isPsychomotorVigilanceTaskEnabled"`
	IsQuestionnaireEnabled            bool   `json:"isQuestionnaireEnabled"`
	IsCurrentActivityEnabled          bool   `json:"isCurrentActivityEnabled"`
	StudyName                         string `json:"studyName"`
	Questionnaire                     []questionWithAnswer
}

type questionWithAnswer struct {
	Question string   `json:"question"`
	Answers  []string `json:"answers"`
}

type studyData struct {
	Study   Study
	IsStudy bool
}

func serveRun(cmd *cobra.Command, args []string) {
	// Set routing rules
	http.HandleFunc("/", config)
	http.HandleFunc("/config", config)
	http.HandleFunc("/data", data)
	addr := fmt.Sprintf(":%s", cmd.Flag("port").Value.String())
	fmt.Println("Start to listen on:", addr)
	// Use the default DefaultServeMux
	err := http.ListenAndServe(addr, nil)
	if err != nil {
		log.Fatal(err)
	}
}

func root(w http.ResponseWriter, r *http.Request) {
	buff, _ := io.ReadAll(r.Body)
	io.WriteString(w, string(buff))
	fmt.Println("Recieved and replied: ", string(buff))
}

func config(w http.ResponseWriter, r *http.Request) {
	io.ReadAll(r.Body)

	// Create study entry in db from  config data
	content, err := ioutil.ReadFile("server/config.json")
	if err != nil {
		log.Fatal("Error when opening config file: ", err)
	}
	db, err := gorm.Open(sqlite.Open("test.db"), &gorm.Config{})
	if err != nil {
		panic("Failed to connect database")
	}
	db.AutoMigrate(&Study{}, &Question{}, &Answer{})
	var jsonConfig jSONConfig
	err = json.Unmarshal(content, &jsonConfig)
	if err != nil {
		log.Fatal("Error during unmarshaling config data: ", err)
	}
	jsonConfigBytes, _ := json.MarshalIndent(jsonConfig, "", "    ")
	fmt.Printf("Unmarshaled successfully: %s\n", jsonConfigBytes)
	db.Create(&Study{
		ServerURL:                         jsonConfig.ServerURL,
		StudyName:                         jsonConfig.StudyName,
		NotificationInterval:              jsonConfig.NotificationInterval,
		NotificationText:                  jsonConfig.NotificationText,
		IsSpartalTaskEnabled:              jsonConfig.IsSpartalTaskEnabled,
		IsPsychomotorVigilanceTaskEnabled: jsonConfig.IsPsychomotorVigilanceTaskEnabled,
		IsReactionGameEnabled:             jsonConfig.IsReactionGameEnabled,
		IsQuestionnaireEnabled:            jsonConfig.IsQuestionnaireEnabled,
		IsCurrentActivityEnabled:          jsonConfig.IsCurrentActivityEnabled,
	})

	// var questionnaireData []byte = configData["questionaire"]

	// Read study entry from db, create json and send to client
	var studyFromDB Study
	db.First(&studyFromDB, "study_name = ?", jsonConfig.StudyName)
	if &studyFromDB == nil {
		log.Fatal("Failed to retrieve study data from db")
		return
	}
	studyData := &studyData{
		Study:   studyFromDB,
		IsStudy: true,
	}
	studyDataAsBytes, err := json.MarshalIndent(&studyData, "", "    ")
	if err != nil {
		log.Fatal("Error during marsheling study data: ", err)
		return
	}
	io.WriteString(w, string(studyDataAsBytes))
	fmt.Println("replied config: ", string(studyDataAsBytes))
}

func data(w http.ResponseWriter, r *http.Request) {
	io.WriteString(w, "thanks for the data")
	fmt.Println("recieved data")
}
