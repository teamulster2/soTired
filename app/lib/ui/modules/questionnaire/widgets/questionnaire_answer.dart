import 'package:flutter/material.dart';
import 'package:so_tired/ui/models/questionnaire.dart';

/// This widget contains one of the answers of a [QuestionnaireObject] with a specific number, text and value
/// The [VoidCallback] onPressed occurs each time an answer is tapped.
class QuestionnaireAnswer extends StatefulWidget {
  const QuestionnaireAnswer(
      {required this.number,
      required this.text,
      required this.value,
      required this.onPressed,
      Key? key})
      : super(key: key);

  final int number;
  final String text;
  final int value;
  final VoidCallback onPressed;

  @override
  _QuestionnaireAnswerState createState() => _QuestionnaireAnswerState();
}

class _QuestionnaireAnswerState extends State<QuestionnaireAnswer> {
  @override
  Widget build(BuildContext context) => SizedBox(
      width: MediaQuery.of(context).size.width - 50,
      child: GestureDetector(
          // onTap: () => widget.onTapPressed(int.parse(widget.number)),
          onTap: () {
            widget.onPressed();
          },
          child: Row(children: <Widget>[
            Stack(alignment: Alignment.center, children: <Widget>[
              Container(
                color: const Color(0xff97E8D9),
                width: 50,
                height: 50,
              ),
              Text(widget.number.toString(),
                  style: Theme.of(context).textTheme.headline3)
            ]),
            const SizedBox(width: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width - 120,
              child: Text(widget.text,
                  style: Theme.of(context).textTheme.bodyText2),
            )
          ])));
}
