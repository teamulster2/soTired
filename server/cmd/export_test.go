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

func TestWriteRead(t *testing.T) {
	db, path := setUpTmpDB()
	defer os.RemoveAll(path)

	db.AutoMigrate(&Study{})

	studyAmount := 10
	inStudyList := make([]Study, studyAmount)

	db.Create(inStudyList)
	var outStudyList []Study
	db.Find(&outStudyList)
	if len(inStudyList) != len(outStudyList) {
		t.Errorf("writing and reading the same stuff should result in the same lenght")
	}
}

func TestJsonExport(t *testing.T) {
	_, err := fillDatabase()
	if err != nil {
		t.Error(err)
	}
	// FIXME implement json validation
}

func fillDatabase() (*gorm.DB, error) {
	db, path := setUpTmpDB()
	defer os.RemoveAll(path)

	db.AutoMigrate(&Study{})
	db.Create(&Study{StudyName: "study1"})
	var study1 Study
	db.Take(&study1)

	db.AutoMigrate(&Question{})
	db.Create(&Question{StudyID: study1.ID, QuestionText: "quest1"})
	var quest1 Study
	db.Take(&quest1)

	db.AutoMigrate(&Answer{})
	db.Create(&Answer{QuestionID: quest1.ID, AnswerText: "answer1"})
	var answer1 Study
	db.Take(&answer1)

	db.AutoMigrate(&User{})
	db.Create(&User{StudyID: study1.ID})
	var user1 User
	db.Take(&user1)

	db.AutoMigrate(&QuestionnaireLog{})
	db.Create(&QuestionnaireLog{UserID: user1.ID})
	var log1 QuestionnaireLog
	db.Take(&log1)

	db.AutoMigrate(&QuestionnaireResult{})
	db.Create(&QuestionnaireResult{QuestionnaireLogID: log1.ID, QuestionID: quest1.ID, AnswerID: answer1.ID})

	db.AutoMigrate(&AccessMethod{})
	db.Create(&AccessMethod{})
	var ac1 AccessMethod
	db.Take(&ac1)

	db.AutoMigrate(&SSTResult{})
	db.Create(&SSTResult{})
	var sst1 SSTResult
	db.Take(&sst1)

	db.AutoMigrate(&PVTResult{})
	db.Create(&PVTResult{})
	var pvt1 PVTResult
	db.Take(&pvt1)

	db.AutoMigrate(&UserLog{})
	db.Create(&UserLog{UserID: user1.ID, AccessMethodID: ac1.ID, SSTResultID: sst1.ID, PVTResultID: pvt1.ID})

	return db, nil
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
