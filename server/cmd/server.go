package cmd

import (
	"fmt"
	"gorm.io/driver/sqlite"
	"gorm.io/gorm"
	"io"
	"log"
	"net/http"

	"github.com/spf13/cobra"
)

func serveRun(cmd *cobra.Command, args []string) {
	// Connect to db
	_, err := gorm.Open(sqlite.Open("test.db"), &gorm.Config{})
	if err != nil {
		panic("failed to connect database")
	}

	// Set routing rules
	http.HandleFunc("/", root)

	addr := fmt.Sprintf(":%s", cmd.Flag("port").Value.String())
	fmt.Println("Start to listen on:", addr)
	// Use the default DefaultServeMux
	err = http.ListenAndServe(addr, nil)
	if err != nil {
		log.Fatal(err)
	}
}

func root(w http.ResponseWriter, r *http.Request) {
	buf, _ := io.ReadAll(r.Body)
	io.WriteString(w, string(buf))
	fmt.Println("recieved and replyed:", string(buf))
}
