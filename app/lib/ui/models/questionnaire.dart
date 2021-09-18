/// This class holds the QuestionnaireObject that is used to set the questionnaire.
class QuestionnaireObject {
  String question;
  List<String> answers;

  QuestionnaireObject(this.question, this.answers);

  QuestionnaireObject.fromJson(Map<String, dynamic> json)
      : question = json['question'],
        answers = json['answers'];

  Map<String, dynamic> toJson() =>
      <String, dynamic>{'question': question, 'answers': answers};
}
