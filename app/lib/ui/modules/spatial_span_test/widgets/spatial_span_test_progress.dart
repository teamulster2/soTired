import 'package:flutter/material.dart';

class SpatialSpanTestProgress extends StatelessWidget {
  const SpatialSpanTestProgress(
      {required this.level, required this.currentValue, Key? key})
      : super(key: key);

  final ValueNotifier<int> level;
  final ValueNotifier<int> currentValue;

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<int>(
      valueListenable: currentValue,
      builder: (BuildContext buildContext, Object? value, Widget? widget) =>
          SizedBox(
            height: 150,
            child: Row(children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width / 2 - 20,
                alignment: Alignment.center,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Level',
                          style: Theme.of(context).textTheme.bodyText1),
                      const SizedBox(height: 10),
                      Text(level.value.toString(),
                          style: Theme.of(context).textTheme.headline3)
                    ]),
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorDark.withOpacity(0.2),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 2 - 20,
                alignment: Alignment.center,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Status',
                          style: Theme.of(context).textTheme.bodyText1),
                      const SizedBox(height: 10),
                      Text(
                          currentValue.value.toString() +
                              ' out of ' +
                              level.value.toString(),
                          style: Theme.of(context).textTheme.headline3)
                    ]),
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorDark.withOpacity(0.2),
                ),
              ),
            ]),
          ));
}
