import 'package:flutter/material.dart';
import 'package:so_tired/ui/core/home/widgets/home_button.dart';
import 'package:so_tired/ui/core/home/widgets/home_image.dart';
import 'package:so_tired/ui/core/navigation/navigation.dart';
import 'package:so_tired/ui/core/navigation/navigation_drawer.dart';
import 'package:so_tired/ui/modules/questionnaire/questionnaire.dart';
import 'package:so_tired/ui/modules/twoSidesTest/two_sides_test.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(55),
        child: NavigationBar(),
      ),
      drawer: const NavigationDrawer(),
      body: Container(
          color: Theme.of(context).backgroundColor,
          child: Column(children: <Widget>[
            const HomeImage(),
            const SizedBox(height: 40),
            Expanded(
              child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: 1.4,
                      children: <Widget>[
                        // NOTE: Icons from: https://api.flutter.dev/flutter/material/Icons-class.html
                        HomeButton(
                          icon: Icons.access_time_filled,
                          text: 'reaction game',
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute<BuildContext>(
                                    builder: (BuildContext context) =>
                                        const TwoSidesTest()));
                          },
                        ),
                        HomeButton(
                          icon: Icons.question_answer_rounded,
                          text: 'questionnaire',
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute<BuildContext>(
                                    builder: (BuildContext context) =>
                                        const Questionnaire()));
                          },
                        ),
                        HomeButton(
                          icon: Icons.app_settings_alt,
                          text: 'settings',
                          onTap: () {
                            // TODO: navigation to new page: settings
                          },
                        ),
                        HomeButton(
                          icon: Icons.graphic_eq,
                          text: 'audio recognition',
                          onTap: () {
                            // TODO: navigation to new page: audio recognition
                          },
                        ),
                      ])),
            ),
          ])));
}
