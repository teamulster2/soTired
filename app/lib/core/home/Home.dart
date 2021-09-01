import 'package:flutter/material.dart';
import 'package:so_tired/core/home/widgets/HomeButton.dart';
import 'package:so_tired/core/home/widgets/HomeImage.dart';
import 'package:so_tired/core/navigation/Navigation.dart';
import 'package:so_tired/modules/questionnaire/Questionnaire.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Theme.of(context).backgroundColor,
        child: Column(children: [
          NavigationBar(),
          HomeImage(),
          Expanded(
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: 1.4,
                    children: [
                      // NOTE: Icons from: https://api.flutter.dev/flutter/material/Icons-class.html
                      HomeButton(
                        icon: 57403,
                        text: 'reaction tests',
                        onTap: () {
                          // TODO: navigation to new page: reaction tests
                        },
                      ),
                      HomeButton(
                        icon: 983247,
                        text: 'questionnaire',
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Questionnaire()));
                        },
                      ),
                      HomeButton(
                        icon: 57485,
                        text: 'settings',
                        onTap: () {
                          // TODO: navigation to new page: settings
                        },
                      ),
                      HomeButton(
                        icon: 58083,
                        text: 'audio recognition',
                        onTap: () {
                          // TODO: navigation to new page: audio recognition
                        },
                      ),
                    ])),
          ),
        ]));
  }
}
