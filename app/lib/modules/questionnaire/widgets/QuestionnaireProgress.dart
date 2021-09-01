import 'package:flutter/material.dart';

class QuestionnaireProgress extends StatefulWidget {
  const QuestionnaireProgress(
      {Key? key,
      required this.length,
      required this.currentQuestion,
      required this.onBack,
      required this.onForward})
      : super(key: key);

  final int length;
  final int currentQuestion;
  final VoidCallback onBack;
  final VoidCallback onForward;

  @override
  _QuestionnaireProgressState createState() => _QuestionnaireProgressState();
}

class _QuestionnaireProgressState extends State<QuestionnaireProgress> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        GestureDetector(
            child: Container(
              color: Theme.of(context).primaryColor,
              width: 40,
              height: 40,
              child: Icon(IconData(62832, fontFamily: 'MaterialIcons'),
                  color: Colors.white),
            ),
            onTap: () => widget.onBack()),
        SizedBox(width: 20),
        Text(
            'Frage ' +
                widget.currentQuestion.toString() +
                ' von ' +
                widget.length.toString(),
            style: Theme.of(context).textTheme.bodyText2),
        SizedBox(width: 20),
        GestureDetector(
            child: Container(
              color: Theme.of(context).primaryColor,
              width: 40,
              height: 40,
              child: Icon(IconData(62841, fontFamily: 'MaterialIcons'),
                  color: Colors.white),
            ),
            onTap: () => widget.onForward())
      ]),
    );
  }
}
