import 'package:flutter/material.dart';

class QuestionnaireAnswer extends StatefulWidget {
  const QuestionnaireAnswer({Key? key, required this.number, required this.text, required this.value, required this.onPressed}) : super(key: key);

  final int number;
  final String text;
  final int value;
  final VoidCallback onPressed;

  @override
  _QuestionnaireAnswerState createState() => _QuestionnaireAnswerState();
}

class _QuestionnaireAnswerState extends State<QuestionnaireAnswer> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width - 50,
        child: GestureDetector(
          // onTap: () => widget.onTapPressed(int.parse(widget.number)),
            onTap: () {
              widget.onPressed();
            },
            child: Row(children: [
              Stack(alignment: Alignment.center, children: [
                Container(
                  color: Color(0xff97E8D9),
                  width: 50,
                  height: 50,
                ),
                Text(widget.number.toString(),
                    style: Theme.of(context).textTheme.headline3)
              ]),
              SizedBox(width: 20),
              Container(
                width: MediaQuery.of(context).size.width - 120,
                child: Text(widget.text,
                    style: Theme.of(context).textTheme.bodyText2),
              )
            ])));
  }
}
