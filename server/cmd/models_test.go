package cmd

import (
	"fmt"
	"io/ioutil"
	"os"
	"path/filepath"
	"testing"

	"gorm.io/driver/sqlite"
	"gorm.io/gorm"
)

func TestTimeValidation(t *testing.T) {
	db, path := setUpTmpDB()
	defer os.RemoveAll(path)

	db.AutoMigrate(&NotificationTime{})

	var notificationTime = &NotificationTime{Time: "12:00"}
	db.Create(&notificationTime)
	if notificationTime == nil {
		t.Fail()
	}
	db.Delete(&notificationTime, 1)

	notificationTime = &NotificationTime{Time: "wrong_format"}
	if notificationTime.isValid() {
		t.Fail()
	}
	notificationTime = &NotificationTime{Time: "wrong:format"}
	if notificationTime.isValid() {
		t.Fail()
	}
	notificationTime = &NotificationTime{Time: "1:00"}
	if notificationTime.isValid() {
		t.Fail()
	}
	notificationTime = &NotificationTime{Time: "31:76"}
	if notificationTime.isValid() {
		t.Fail()
	}

}

// returns database connection and path to tmp dir which has to be closed by caller side.
func setUpTmpDB() (*gorm.DB, string) {
	path, err := ioutil.TempDir("", "soti")
	if err != nil {
		panic(err)
	}

	db, err := gorm.Open(sqlite.Open(filepath.Join(path, "test.db")), &gorm.Config{})
	if err != nil {
		panic(fmt.Sprintf("failed to open db: %s", err.Error()))
	}

	return db, path
}
