package cmd

import (
	"bytes"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"

	"github.com/spf13/cobra"
)

func echoTest(cmd *cobra.Command, args []string) {

	msg := bytes.Buffer{}
	msg.WriteString("echo?")

	addr := fmt.Sprintf("http://%s:%s", cmd.Flag("address").Value.String(), cmd.Flag("port").Value.String())
	// Basic HTTP GET request
	resp, err := http.Post(addr, "text/plain", &msg)
	if err != nil {
		log.Fatal("Error getting response. ", err)
	}
	defer resp.Body.Close()

	// Read body from response
	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		log.Fatal("Error reading response. ", err)
	}

	fmt.Printf("%s\n", body)
}
