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

	studyList := []Study{{}, {}}
	db.Create(&studyList)

	questionList := []Question{{StudyID: studyList[0].ID}, {StudyID: studyList[1].ID}}
	db.Create(&questionList)

	answerList := []Answer{{QuestionID: questionList[0].ID}, {QuestionID: questionList[1].ID}}
	db.Create(&answerList)

	userList := []User{{StudyID: studyList[0].ID}, {StudyID: studyList[1].ID}}
	db.Create(&userList)

	questionnaireLogList := []QuestionnaireLog{{UserID: userList[0].ID}, {UserID: userList[1].ID}}
	db.Create(&questionnaireLogList)

	questionnaireResultList := []QuestionnaireResult{
		{
			QuestionnaireLogID: questionnaireLogList[0].ID,
			AnswerID:           answerList[0].ID,
			QuestionID:         questionList[0].ID,
		},
		{
			QuestionnaireLogID: questionnaireLogList[1].ID,
			AnswerID:           answerList[1].ID,
			QuestionID:         questionList[1].ID,
		},
	}
	db.Create(&questionnaireResultList)

	sstResultList := []SSTResult{{}, {}}
	db.Create(&sstResultList)

	pvtResultList := []PVTResult{{}, {}}
	db.Create(&pvtResultList)

	userLogList := []UserLog{
		{
			UserID:      userList[0].ID,
			SSTResultID: sstResultList[0].ID,
			PVTResultID: pvtResultList[0].ID,
		},
		{
			UserID:      userList[1].ID,
			SSTResultID: sstResultList[1].ID,
			PVTResultID: pvtResultList[1].ID,
		},
	}
	db.Create(&userLogList)

	return db, nil
}
