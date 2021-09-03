import 'package:flutter/material.dart';
import 'package:so_tired/core/home/Home.dart';
import 'package:so_tired/core/navigation/Navigation.dart';
import 'package:so_tired/constants/Constants.dart' as Constants;
import 'package:so_tired/core/navigation/NavigationDrawer.dart';
import 'package:so_tired/modules/questionnaire/widgets/QuestionnaireAnswer.dart';
import 'package:so_tired/modules/questionnaire/widgets/QuestionnaireProgress.dart';
import 'package:so_tired/modules/questionnaire/widgets/QuestionnaireQuestion.dart';

class Questionnaire extends StatefulWidget {
  const Questionnaire({Key? key}) : super(key: key);

  @override
  _QuestionnaireState createState() => _QuestionnaireState();
}

class _QuestionnaireState extends State<Questionnaire> {
  final questions = Constants.questions;

  ValueNotifier currentQuestion = new ValueNotifier<int>(0);
  int score = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(55),
          child: NavigationBar(),
        ),
        drawer: NavigationDrawer(),
        body: Container(
            color: Theme.of(context).backgroundColor,
            child: Column(
              children: [
                Container(
                    padding: EdgeInsets.all(20.0),
                    child: ValueListenableBuilder(
                        valueListenable: currentQuestion,
                        builder: (context, value, child) {
                          return Column(children: [
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
                            SizedBox(height: 20),
                            QuestionnaireQuestion(
                                question:
                                    questions[currentQuestion.value].question),
                            SizedBox(height: 50),
                            for (var i = 0; i < 4; i++)
                              Column(children: [
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
                                      print('final score: ' + score.toString());
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                                title: Text(
                                                    'Questionnaire saved successfully.'),
                                                content: Text(
                                                    'Thank you for filling in. You can now continue with the other components'),
                                                actions: [
                                                  TextButton(
                                                    child: Text('Ok'),
                                                    onPressed: () =>
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        Home())),
                                                  )
                                                ]);
                                          });
                                    }
                                  },
                                ),
                                SizedBox(height: 20)
                              ])
                          ]);
                        }))
              ],
            )));
  }
}
