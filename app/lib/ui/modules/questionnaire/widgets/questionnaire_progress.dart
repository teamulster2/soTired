import 'package:flutter/material.dart';

/// This widget holds the progress of a questionnaire with the length of the questionnaire and the current question number.
class QuestionnaireProgress extends StatefulWidget {
  const QuestionnaireProgress(
      {required this.length,
      required this.currentQuestion,
      required this.onBack,
      required this.onForward,
      required this.answeredQuestion,
      Key? key})
      : super(key: key);

  final int length;
  final int currentQuestion;
  final VoidCallback onBack;
  final VoidCallback onForward;
  final int answeredQuestion;

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
          getButton()
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

  Widget getButton() {
    if (widget.currentQuestion <= widget.answeredQuestion) {
      if (widget.currentQuestion < widget.length - 1) {
        return GestureDetector(
            child: Container(
              color: Theme.of(context).primaryColor,
              width: 40,
              height: 40,
              child: const Icon(IconData(62841, fontFamily: 'MaterialIcons'),
                  color: Colors.white),
            ),
            onTap: () => widget.onForward());
      } else {
        return GestureDetector(
            child: Container(
              color: Colors.grey,
              width: 40,
              height: 40,
              child: const Icon(IconData(62841, fontFamily: 'MaterialIcons'),
                  color: Colors.white),
            ),
            onTap: () => widget.onForward());
      }
    } else {
      return GestureDetector(
          child: Container(
            color: Colors.grey,
            width: 40,
            height: 40,
            child: const Icon(IconData(62841, fontFamily: 'MaterialIcons'),
                color: Colors.white),
          ),
          onTap: () => widget.onForward());
    }
  }
}
