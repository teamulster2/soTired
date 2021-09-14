import 'package:flutter/material.dart';

class CurrentActivity extends StatelessWidget {
  const CurrentActivity({required this.onTap, Key? key}) : super(key: key);
  final Function(String) onTap;

  @override
  Widget build(BuildContext context) => Container(
      height: (MediaQuery.of(context).size.height - 81) / 2,
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Select your current activity: ',
            style: Theme.of(context).textTheme.headline3,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Activity(
                onTap: () => onTap('home'), icon: Icons.home_rounded, text: 'home'),
            const SizedBox(width: 40),
            Activity(
                onTap: () => onTap('work'), icon: Icons.work_rounded, text: 'work'),
            const SizedBox(width: 40),
            Activity(
                onTap: () => onTap('university'),
                icon: Icons.maps_home_work_rounded,
                text: 'university'),
          ]),
          const SizedBox(height: 40),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Activity(
                onTap: () => onTap('shops'),
                icon: Icons.shopping_bag_rounded,
                text: 'shops'),
            const SizedBox(width: 40),
            Activity(
                onTap: () => onTap('friends / family'),
                icon: Icons.people_rounded,
                text: 'friends / family'),
            const SizedBox(width: 40),
            Activity(
                onTap: () => onTap('other'),
                icon: Icons.my_location_rounded,
                text: 'other'),
          ]),
        ],
      ));
}

class Activity extends StatelessWidget {
  const Activity(
      {required this.icon, required this.text, required this.onTap, Key? key})
      : super(key: key);
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: onTap,
      child: Column(children: <Widget>[
        Icon(icon, color: Theme.of(context).primaryColor, size: 50),
        const SizedBox(height: 10),
        Text(text, style: Theme.of(context).textTheme.bodyText2)
      ]));
}
