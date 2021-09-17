import 'package:flutter/material.dart';

/// This widget contains the question of a QuestionnaireObject.
class QuestionnaireQuestion extends StatefulWidget {
  const QuestionnaireQuestion({required this.question, Key? key})
      : super(key: key);
  final String question;

  @override
  _QuestionnaireQuestionState createState() => _QuestionnaireQuestionState();
}

class _QuestionnaireQuestionState extends State<QuestionnaireQuestion> {
  @override
  Widget build(BuildContext context) => SizedBox(
      child:
          Text(widget.question, style: Theme.of(context).textTheme.bodyText1));
}
