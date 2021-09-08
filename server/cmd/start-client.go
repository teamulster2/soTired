package cmd

import (
	"fmt"
	"github.com/spf13/cobra"
	"net"
	"os"
)

const (
	text string = "Hello"
)

func send(cmd *cobra.Command, args []string) {
	var port = defaultPort
	if len(args) == 1 {
		port = args[0]
	}
	// Connect to defined port and connection type.
	connect, err := net.Dial(connType, fmt.Sprintf("%s:%s", host, port))
	if err != nil {
		fmt.Println("Error connecting:", err.Error())
		os.Exit(1)
	}
	// Close connection when leaving the function.
	defer connect.Close()

	// Sending text to Server.
	if _, err := connect.Write([]byte(text)); err != nil {
		fmt.Println("Error writing:", err.Error())
		os.Exit(1)
	}
	fmt.Println("Send text:", text)

	// Waiting for response.
	buf := make([]byte, 1024)
	connect.Read(buf)
	fmt.Printf("Recieved echo: %s\n", buf)
	return
}
