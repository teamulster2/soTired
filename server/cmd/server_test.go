package cmd

import (
	"context"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"path/filepath"
	"sync"
	"testing"
	"time"
)

func TestConfig(t *testing.T) {
	var srv http.Server
	path, err := ioutil.TempDir("", "soti")
	if err != nil {
		panic(err)
	}
	defer os.RemoveAll(path)

	http.HandleFunc("/config", config("../config.json", filepath.Join(path, "default.db")))
	done := make(chan struct{})
	wg := &sync.WaitGroup{}
	wg.Add(1)
	go func(done <-chan struct{}) {
		<-done
		srv.Shutdown(context.Background())
		wg.Done()
	}(done)
	addr := "127.0.0.1:50000"
	srv.Addr = addr

	// do testing stuff
	go func() {
		clientGet(fmt.Sprintf("http://%s/config", addr))
		// cancel server
		var empty struct{}
		done <- empty
		wg.Wait()

	}()

	// start server
	srv.ListenAndServe()
}
func clientGet(addr string) {
	// Wait till the server is online
	done := time.After(time.Second * 5)
out:
	for true {
		select {
		case <-done:
			log.Fatalln("server has not started")
		default:
			resp, err := http.Get(addr)
			if err == nil && resp.StatusCode == 200 {
				break out
			} else {
				time.Sleep(time.Millisecond * 100)
			}
		}
	}
	// Basic HTTP GET request
	resp, err := http.Get(addr)
	if err != nil {
		log.Fatalln("Error getting response: ", err)
	}
	defer resp.Body.Close()

	// Read body from response
	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		log.Fatalln("Error reading response: ", err)
	}

	//FIXME: Add test
	if string(body) == "" {
		panic("empty body")
	}
}
