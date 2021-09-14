package cmd

import (
	"encoding/json"
	"os"
	"testing"

	"gorm.io/gorm"
)

func TestWriteRead(t *testing.T) {
	db, path := setUpTmpDB()
	defer os.RemoveAll(path)
	db = migrate(db)

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
	db, err := fillDatabase()
	if err != nil {
		t.Error(err)
	}
	studyList, err := toJSONStudyList(db)
	if err != nil {
		t.Error(err)
	}
	_, _ = json.MarshalIndent(studyList, "", "    ")
	// FIXME implement json validation
}

func fillDatabase() (*gorm.DB, error) {
	db, path := setUpTmpDB()
	defer os.RemoveAll(path)
	db = migrate(db)

	db.Create(&Study{
		StudyName: "study1",
	})
	var study1 Study
	db.Take(&study1)

	db.Create(&Question{
		StudyID:      study1.ID,
		QuestionText: "quest1",
	})
	var quest1 Question
	db.Take(&quest1)

	db.Create(&Answer{
		QuestionID: quest1.ID,
		AnswerText: "answer1",
	})
	var answer1 Answer
	db.Take(&answer1)

	db.Create(&User{
		StudyID: study1.ID,
	})
	var user1 User
	db.Take(&user1)

	db.Create(&QuestionnaireLog{
		UserID: user1.ID,
	})
	var log1 QuestionnaireLog
	db.Take(&log1)

	db.Create(&QuestionnaireResult{
		QuestionnaireLogID: log1.ID,
		QuestionID:         quest1.ID,
		AnswerID:           answer1.ID,
	})

	db.Create(&SSTResult{})
	var sst1 SSTResult
	db.Take(&sst1)

	db.Create(&PVTResult{})
	var pvt1 PVTResult
	db.Take(&pvt1)

	db.Create(&MentalArithmeticResult{})
	var mar1 MentalArithmeticResult
	db.Take(&mar1)

	db.Create(&UserLog{
		UserID:                   user1.ID,
		SSTResultID:              sst1.ID,
		PVTResultID:              pvt1.ID,
		MentalArithmeticResultID: mar1.ID,
	})

	return db, nil
}

// returns database with relevant models migrated
func migrate(db *gorm.DB) *gorm.DB {
	// Migrate all structs relevant in the database
	db.AutoMigrate(&Study{})
	db.AutoMigrate(&UserLog{})
	db.AutoMigrate(&PVTResult{})
	db.AutoMigrate(&SSTResult{})
	db.AutoMigrate(&QuestionnaireResult{})
	db.AutoMigrate(&QuestionnaireLog{})
	db.AutoMigrate(&User{})
	db.AutoMigrate(&Answer{})
	db.AutoMigrate(&Question{})
	db.AutoMigrate(&MentalArithmeticResult{})
	return db
}
