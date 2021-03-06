import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:so_tired/database/models/questionnaire/questionnaire_result.dart';
import 'package:so_tired/service_provider/service_provider.dart';
import 'package:so_tired/ui/core/home/home.dart';
import 'package:so_tired/ui/core/navigation/navigation.dart';
import 'package:so_tired/ui/models/questionnaire.dart';
import 'package:so_tired/ui/modules/questionnaire/widgets/questionnaire_answer.dart';
import 'package:so_tired/ui/modules/questionnaire/widgets/questionnaire_progress.dart';
import 'package:so_tired/ui/modules/questionnaire/widgets/questionnaire_question.dart';
import 'package:so_tired/utils/utils.dart';

/// This widget holds everything that has to do with the Questionnaire part of
/// the app.
/// It holds the [QuestionnaireProgress], the [QuestionnaireQuestion] and all
/// four [QuestionnaireAnswer] widgets.
/// This widget also contains the engine of the questionnaire part with the
/// whole frontend logic.
class Questionnaire extends StatefulWidget {
  const Questionnaire({Key? key}) : super(key: key);

  @override
  _QuestionnaireState createState() => _QuestionnaireState();
}

class _QuestionnaireState extends State<Questionnaire> {
  ValueNotifier<int> currentQuestion = ValueNotifier<int>(0);
  int score = 0;
  int answeredQuestion = 0;

  Map<String, String> questionnaireResult = <String, String>{};

  @override
  Widget build(BuildContext context) {
    final List<QuestionnaireObject> questions =
        Provider.of<ServiceProvider>(context, listen: false)
            .configManager
            .clientConfig!
            .questions;

    return Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(55),
          child: NavigationBar(title: 'Questionnaire'),
        ),
        // NOTE: drawer not needed now
        // drawer: const NavigationDrawer(),
        body: Container(
          color: Theme.of(context).backgroundColor,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Container(
                color: Theme.of(context).backgroundColor,
                child: Column(
                  children: <Widget>[
                    Container(
                        padding: const EdgeInsets.all(20.0),
                        child: ValueListenableBuilder<int>(
                            valueListenable: currentQuestion,
                            builder: (BuildContext context, Object? value,
                                    Widget? child) =>
                                Column(children: <Widget>[
                                  addQuestionnaireProgress(questions.length),
                                  const SizedBox(height: 20),
                                  QuestionnaireQuestion(
                                      question: questions[currentQuestion.value]
                                          .question),
                                  const SizedBox(height: 50),
                                  for (int i = 0; i < 4; i++)
                                    Column(children: <Widget>[
                                      addQuestionnaireAnswer(i, questions),
                                      const SizedBox(height: 20)
                                    ])
                                ])))
                  ],
                )),
          ),
        ));
  }

  /// This methods returns the [QuestionnaireProgress] widget with the number
  /// of questions and the current question number.
  Widget addQuestionnaireProgress(int length) => QuestionnaireProgress(
      length: length,
      currentQuestion: currentQuestion.value + 1,
      onBack: () {
        if (currentQuestion.value > 0) {
          currentQuestion.value -= 1;
        }
      },
      answeredQuestion: answeredQuestion,
      onForward: () {
        if (currentQuestion.value < answeredQuestion) {
          if (currentQuestion.value < length - 1) {
            currentQuestion.value += 1;
          }
        } else {
          showDialogQuestionNotAnswered();
        }
      });

  /// This method returns the [QuestionnaireAnswer] widget with the current
  /// list of answers and the functionality when you select an answer.
  Widget addQuestionnaireAnswer(int i, List<QuestionnaireObject> questions) =>
      QuestionnaireAnswer(
        text: questions[currentQuestion.value].answers[i],
        number: i,
        value: i,
        onPressed: () {
          Future<dynamic>.delayed(const Duration(milliseconds: 200), () {
            if (currentQuestion.value < questions.length - 1) {
              currentQuestion.value += 1;
              answeredQuestion += 1;
              score += i;

              late final String answer;
              if (i == 1) {
                answer = questions[currentQuestion.value].answers[0];
              } else if (i == 2) {
                answer = questions[currentQuestion.value].answers[1];
              } else if (i == 3) {
                answer = questions[currentQuestion.value].answers[2];
              } else if (i == 4) {
                answer = questions[currentQuestion.value].answers[3];
              } else {
                answer = '';
              }
              questionnaireResult.addAll(<String, String>{
                questions[currentQuestion.value].question: answer
              });
            } else {
              showDialogQuestionnaireFinished();
            }
          });
        },
      );

  /// This method shows a dialog with the information about finishing the
  /// questionnaire. It creates a questionnaire result and saves the data into
  /// the database.
  void showDialogQuestionnaireFinished() {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
                title: const Text('Questionnaire saved successfully.'),
                content: const Text(
                    'Thank you for filling in. You can now continue with the '
                    'other components'),
                actions: <Widget>[
                  TextButton(
                      child: const Text('Ok'),
                      onPressed: () {
                        Provider.of<ServiceProvider>(context, listen: false)
                            .databaseManager
                            .writeQuestionnaireResults(<QuestionnaireResult>[
                          QuestionnaireResult(Utils.generateUuid(),
                              questionnaireResult, DateTime.now())
                        ]);
                        Navigator.push(
                            context,
                            MaterialPageRoute<BuildContext>(
                                builder: (BuildContext context) =>
                                    const Home()));
                      })
                ]));
  }

  /// This method shows a dialog with the information that you can not skip a
  /// question.
  void showDialogQuestionNotAnswered() {
    showDialog(
        context: context,
        builder: (BuildContext context) => const AlertDialog(
              title: Text('Question not answered'),
              content: Text('You have to answer each question to go forward'),
            ));
  }
}
