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

func serveRun(cmd *cobra.Command, args []string) {
	// Set routing rules
	http.HandleFunc("/", root)
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
	content, err := ioutil.ReadFile("./config.json")
	if err != nil {
		log.Fatal("Error when opening config file: ", err)
	}
	var studyFromFile Study
	err = json.Unmarshal(content, &studyFromFile)
	if err != nil {
		log.Fatal("Error during unmarshaling config data: ", err)
	}
	db, err := gorm.Open(sqlite.Open("test.db"), &gorm.Config{})
	if err != nil {
		panic("Failed to connect database")
	}
	db.AutoMigrate(&Study{})
	db.Create(&studyFromFile)

	// Read study entry from db, create json and send to client
	var studyFromDB Study
	db.First(&studyFromDB, studyFromFile.ID)
	if &studyFromDB == nil {
		log.Fatal("Failed to retrieve study data from db")
		return
	}
	buff, err := json.Marshal(&studyFromDB)
	if err != nil {
		log.Fatal("Error during marsheling study data: ", err)
		return
	}
	io.WriteString(w, string(buff))
	fmt.Println("replyied config: ", string(buff))
}

func data(w http.ResponseWriter, r *http.Request) {
	io.WriteString(w, "thanks for the data")
	fmt.Println("recieved data")
}
