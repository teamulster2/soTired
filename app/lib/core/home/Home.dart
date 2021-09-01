import 'package:flutter/material.dart';
import 'package:so_tired/core/home/widgets/HomeImage.dart';
import 'package:so_tired/core/navigation/Navigation.dart';

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
      child: Column(
        children: [
          NavigationBar(),
          HomeImage(),
        ]
      )
    );
  }
}
