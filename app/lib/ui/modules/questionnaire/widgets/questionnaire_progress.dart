import 'package:flutter/material.dart';

class QuestionnaireProgress extends StatefulWidget {
  const QuestionnaireProgress(
      {required this.length,
      required this.currentQuestion,
      required this.onBack,
      required this.onForward,
      Key? key})
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
  Widget build(BuildContext context) => WillPopScope(
      child: SizedBox(
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
          GestureDetector(
              child: Container(
                color: Theme.of(context).primaryColor,
                width: 40,
                height: 40,
                child: const Icon(IconData(62832, fontFamily: 'MaterialIcons'),
                    color: Colors.white),
              ),
              onTap: () => widget.onBack()),
          const SizedBox(width: 20),
          Text(
              'question ' +
                  widget.currentQuestion.toString() +
                  ' of ' +
                  widget.length.toString(),
              style: Theme.of(context).textTheme.bodyText2),
          const SizedBox(width: 20),
          GestureDetector(
              child: Container(
                color: Theme.of(context).primaryColor,
                width: 40,
                height: 40,
                child: const Icon(IconData(62841, fontFamily: 'MaterialIcons'),
                    color: Colors.white),
              ),
              onTap: () => widget.onForward())
        ]),
      ),
      onWillPop: () => onWillPop(context));

  Future<bool> onWillPop(BuildContext context) async => await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
              title: const Text('Are you sure to leave the questionnaire?'),
              content: const Text("Your results won't be saved."),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.pop(context, false),
                ),
                TextButton(
                  child: const Text('Ok'),
                  onPressed: () => Navigator.pop(context, true),
                )
              ]));
}
