package cmd

import (
	"fmt"
	"io"
	"log"
	"net/http"

	"github.com/spf13/cobra"
)

func serveRun(cmd *cobra.Command, args []string) {
	// Set routing rules
	http.HandleFunc("/", root)

	addr := fmt.Sprintf(":%s", cmd.Flag("port").Value.String())
	fmt.Println("Start to listen on:", addr)
	//Use the default DefaultServeMux.
	err := http.ListenAndServe(addr, nil)
	if err != nil {
		log.Fatal(err)
	}
}

func root(w http.ResponseWriter, r *http.Request) {
	buf, _ := io.ReadAll(r.Body)
	io.WriteString(w, string(buf))
	fmt.Println("recieved and replyed:", string(buf))
}
