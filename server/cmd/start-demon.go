package cmd

import (
	"fmt"
	"github.com/spf13/cobra"
	"net"
	"os"
)

func serve(cmd *cobra.Command, args []string) {
	var port = defaultPort
	if len(args) == 1 {
		port = args[0]
	}
	// Listen for incoming connections.
	listen, err := net.Listen(connType, fmt.Sprintf("%s:%s", host, port))
	if err != nil {
		fmt.Println("Error listening:", err.Error())
		os.Exit(1)
	}
	// Close the listener when the application closes.
	defer listen.Close()
	fmt.Println("Listening on", host, ":", port)
	for {
		// Listen for an incoming connection.
		conn, err := listen.Accept()
		if err != nil {
			fmt.Println("Error accepting:", err.Error())
			os.Exit(1)
		}
		// Handle connections in a new goroutine.
		go handleRequest(conn)
	}
}

// Handles incoming requests.
func handleRequest(conn net.Conn) {
	// Close the connection when you're done with it.
	defer conn.Close()

	// Make a buffer to hold incoming data.
	buf := make([]byte, 1024)

	// Read the incoming connection into the buffer.
	if _, err := conn.Read(buf); err != nil {
		fmt.Println("Error reading:", err.Error())
	}
	fmt.Printf("recieved message: %s\n", buf)

	// Send echo back to person contacting us.
	if _, err := conn.Write(buf); err != nil {
		fmt.Println("Error writing:", err.Error())
	}
	fmt.Printf("send echo: %s\n", buf)
}
