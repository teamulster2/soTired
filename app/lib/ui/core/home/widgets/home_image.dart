import 'package:flutter/material.dart';

class HomeImage extends StatefulWidget {
  const HomeImage({Key? key}) : super(key: key);

  @override
  _HomeImageState createState() => _HomeImageState();
}

/// This class defines the home image that occurs on the home screen when you start the application.
class _HomeImageState extends State<HomeImage> {
  @override
  Widget build(BuildContext context) => SizedBox(
    width: MediaQuery.of(context).size.width,
    height: 320,
    child: const Image(
          fit: BoxFit.cover,
          image: AssetImage('assets/images/background_06.png'),
        ),
  );
}
