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
  ValueNotifier<Color> flashColor = ValueNotifier<Color>(Colors.white);

  @override
  Widget build(BuildContext context) {
    flashColor.value = Theme.of(context).backgroundColor;
    return SizedBox(
        width: MediaQuery.of(context).size.width - 50,
        child: GestureDetector(
            // onTap: () => widget.onTapPressed(int.parse(widget.number)),
            onTap: () {
              flashColor.value =
                  Theme.of(context).primaryColor.withOpacity(0.3);
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
              ValueListenableBuilder<Color>(
                valueListenable: flashColor,
                builder: (BuildContext context, Object? value, Widget? w) =>
                    SizedBox(
                  width: MediaQuery.of(context).size.width - 120,
                  child: Container(
                    color: flashColor.value,
                    child: Text(widget.text,
                        style: Theme.of(context).textTheme.bodyText2),
                  ),
                ),
              )
            ])));
  }
}
