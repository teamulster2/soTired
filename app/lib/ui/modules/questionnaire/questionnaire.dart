import 'package:flutter/material.dart';
import 'package:so_tired/ui/core/home/home.dart';
import 'package:so_tired/ui/core/navigation/navigation.dart';
import 'package:so_tired/ui/constants/constants.dart' as constants;
import 'package:so_tired/ui/core/navigation/navigation_drawer.dart';
import 'package:so_tired/ui/models/questionnaire.dart';
import 'package:so_tired/ui/modules/questionnaire/widgets/questionnaire_answer.dart';
import 'package:so_tired/ui/modules/questionnaire/widgets/questionnaire_progress.dart';
import 'package:so_tired/ui/modules/questionnaire/widgets/questionnaire_question.dart';

class Questionnaire extends StatefulWidget {
  const Questionnaire({Key? key}) : super(key: key);

  @override
  _QuestionnaireState createState() => _QuestionnaireState();
}

class _QuestionnaireState extends State<Questionnaire> {
  final List<QuestionnaireObject> questions = constants.questions;

  ValueNotifier<int> currentQuestion = ValueNotifier<int>(0);
  int score = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(55),
          child: NavigationBar(),
        ),
        drawer: const NavigationDrawer(),
        body: Container(
            color: Theme.of(context).backgroundColor,
            child: Column(
              children: <Widget>[
                Container(
                    padding: const EdgeInsets.all(20.0),
                    child: ValueListenableBuilder<int>(
                        valueListenable: currentQuestion,
                        builder: (BuildContext context, Object? value, Widget? child) => Column(children: <Widget>[
                            QuestionnaireProgress(
                              length: questions.length,
                              currentQuestion: currentQuestion.value + 1,
                              onBack: () {
                                if (currentQuestion.value > 0) {
                                  currentQuestion.value -= 1;
                                }
                              },
                              onForward: () {
                                if (currentQuestion.value <
                                    questions.length - 1) {
                                  currentQuestion.value += 1;
                                }
                              },
                            ),
                            const SizedBox(height: 20),
                            QuestionnaireQuestion(
                                question:
                                    questions[currentQuestion.value].question),
                            const SizedBox(height: 50),
                            for (int i = 0; i < 4; i++)
                              Column(children: <Widget>[
                                QuestionnaireAnswer(
                                  text: questions[currentQuestion.value]
                                      .answers[i],
                                  number: i,
                                  value: i,
                                  onPressed: () {
                                    if (currentQuestion.value <
                                        questions.length - 1) {
                                      currentQuestion.value += 1;
                                      score += i;
                                    } else {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) => AlertDialog(
                                                title: const Text(
                                                    'Questionnaire saved successfully.'),
                                                content: const Text(
                                                    'Thank you for filling in. You can now continue with the other components'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: const Text('Ok'),
                                                    onPressed: () =>
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute<BuildContext>(
                                                                builder:
                                                                    (BuildContext context) =>
                                                                        const Home())),
                                                  )
                                                ]));
                                    }
                                  },
                                ),
                                const SizedBox(height: 20)
                              ])
                          ])))
              ],
            )));
}
