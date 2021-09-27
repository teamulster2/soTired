package cmd

import (
	"bufio"
	"bytes"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"testing"
)

const (
	importTestJSON = "./test/client.json"
)

func TestJSONImport(t *testing.T) {
	in, err := ioutil.ReadFile(importTestJSON)
	if err != nil {
		t.Fatal(err)
	}

	jsonClientData, err := fromClientJSON(in)
	if err != nil {
		t.Fatal(err)
	}
	out, err := json.MarshalIndent(jsonClientData, "", "    ")
	if err != nil {
		t.Fatal(err)
	}
	inScanner := *bufio.NewScanner(bytes.NewReader(in))
	outScanner := *bufio.NewScanner(bytes.NewReader(out))
	for inScanner.Scan() && outScanner.Scan() {
		inText := inScanner.Text()
		outText := outScanner.Text()
		if inText != outText {
			fmt.Printf("the following lines should not differ:\n%s\n%s\n", inText, outText)
			t.Fail()
		}
	}
}
