package cmd

import (
	"bytes"
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

	"gorm.io/driver/sqlite"
	"gorm.io/gorm"
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

func TestData(t *testing.T) {
	var srv http.Server
	path, err := ioutil.TempDir("", "soti")
	if err != nil {
		panic(err)
	}
	defer os.RemoveAll(path)
	db, err := gorm.Open(sqlite.Open(filepath.Join(path, "test.db")), &gorm.Config{})
	if err != nil {
		panic("Failed to connect to database") // TODO add error
	}
	migrate(db)

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) { w.WriteHeader(http.StatusOK) })
	http.HandleFunc("/data", dataGenerator(db))
	wg := &sync.WaitGroup{}
	wg.Add(1)
	go func() {
		wg.Wait()
		srv.Shutdown(context.Background())
	}()
	addr := "127.0.0.1:50000"
	srv.Addr = addr

	// do client stuff
	go func() {
		// Wait till the server is online
		timeout := time.After(time.Second * 5)
	out:
		for true {
			select {
			case <-timeout:
				panic("server has not started")
			default:
				resp, err := http.Get(fmt.Sprintf("http://%s/", addr))
				if err == nil && resp.StatusCode == 200 {
					break out
				} else {
					time.Sleep(time.Millisecond * 100)
				}
			}
		}
		err := clientPost(fmt.Sprintf("http://%s/data", addr))
		if err != nil {
			t.Error(err)
		}

		// cancel server
		wg.Done()

	}()

	// start server
	srv.ListenAndServe()
}

func clientPost(addr string) error {
	resp, err := http.Post(addr, "encoding/json", clientData)
	if err != nil {
		log.Fatalln("Error getting response: ", err)
	}
	defer resp.Body.Close()
	if resp.StatusCode != 200 {
		return fmt.Errorf("expected StatusCode 200 but got: %d", resp.StatusCode)
	}
	return nil
}

var (
	clientData = bytes.NewBufferString(`{
    "studyName": "Default Study",
    "clientVersion": "0.0.1+1",
    "clientUuid": "c59e2eeb-f6c1-4745-9b7f-9de1a8f6bef0",
    "runList": [
        {
            "selfTestUuid": "02c626cb-7c64-4879-92c8-068f31dfe45a",
            "userLog": {
                "uuid": "ff620d2d-4139-4552-8344-20550069de3f",
                "accessMethod": "UserAccessMethod.regularAppStart",
                "UserGameType.psychomotorVigilanceTask": [
                    53,
                    39,
                    31
                ],
                "timestamp": "2021-09-28T17:33:17.972691"
            },
            "userState": {
                "uuid": "8f7f509a-8cdc-4f0d-9f6d-848b17b93d42",
                "currentActivity": "other",
                "currentMood": "happy",
                "timestamp": "2021-09-28T17:33:06.313840"
            }
        },
        {
            "selfTestUuid": "02c626cb-7c64-4879-92c8-068f31dfe45a",
            "userLog": {
                "uuid": "42ed27c1-c431-4aeb-92df-c9cebd807ad9",
                "accessMethod": "UserAccessMethod.regularAppStart",
                "UserGameType.spatialSpanTask": 1,
                "timestamp": "2021-09-28T17:33:29.561914"
            },
            "userState": {}
        }
    ],
    "questionnaireResults": [
        {
            "uuid": "8a2b8c31-1076-46e5-966b-31c63e7680f6",
            "question": "Do you find it difficult to start things? Do you experience resistance or a lack of initiative when you have to start something, no matter whether it is a new task or part of your everyday activities?",
            "answer": "I have no difficulty starting things.",
            "timestamp": "2021-09-28T17:31:59.180562"
        },
        {
            "uuid": "8a2b8c31-1076-46e5-966b-31c63e7680f6",
            "question": "Does your brain become fatigued quickly when you have to think hard? Do you become mentally fatigued from things such as reading, watching TV or taking part in a conversation with several people? Do you have to take breaks or change to another activity?",
            "answer": "I become fatigued quickly but am still able to make the same mental effort as before",
            "timestamp": "2021-09-28T17:31:59.180562"
        },
        {
            "uuid": "8a2b8c31-1076-46e5-966b-31c63e7680f6",
            "question": "How long do you need to recover after you have worked “until you drop” or are no longer able to concentrate on what you are doing?",
            "answer": "I need to rest for more than an hour but do not require a night’s sleep.",
            "timestamp": "2021-09-28T17:31:59.180562"
        },
        {
            "uuid": "8a2b8c31-1076-46e5-966b-31c63e7680f6",
            "question": "Do you find it difficult to gather your thoughts and concentrate? ",
            "answer": "I find it so difficult to concentrate that I have problems, for example reading a newspaper or taking part in a conversation with a group of people.",
            "timestamp": "2021-09-28T17:31:59.180562"
        }
    ]
}`)
)
