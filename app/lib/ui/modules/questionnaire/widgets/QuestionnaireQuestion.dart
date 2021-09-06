import 'package:flutter/material.dart';

class QuestionnaireQuestion extends StatefulWidget {
  const QuestionnaireQuestion({Key? key, required this.question})
      : super(key: key);
  final String question;

  @override
  _QuestionnaireQuestionState createState() => _QuestionnaireQuestionState();
}

class _QuestionnaireQuestionState extends State<QuestionnaireQuestion> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Text(widget.question,
            style: Theme.of(context).textTheme.bodyText1));
  }
}
