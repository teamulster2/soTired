import 'dart:convert';

import 'package:http/http.dart' as http;

Future<Config> loadConfig() async {
  final http.Response response = await http.post(
    Uri.parse('http://192.168.178.29:50000'),
    headers: <String, String>{
      'Content-Type': 'config/json; charset=UTF-8',
    },
    body: 'please give me a json file',
  );

//ignore: avoid_print
  print('Response: ' + response.body);

  if (response.statusCode == 200) {
    return Config.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load config.');
  }
}

Future<Config> sendData() async {
  final http.Response response = await http.post(
    Uri.parse('http://192.168.178.29:50000'),
    headers: <String, String>{
      'Content-Type': 'data/json; charset=UTF-8',
    },
    body: 'for you, a data json file',
  );

//ignore: avoid_print
  print('Response: ' + response.body);

  if (response.statusCode == 200) {
    return Config.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to send data.');
  }
}

class Config {
  final int id;
  final String title;

  Config({required this.id, required this.title});

  factory Config.fromJson(Map<String, dynamic> json) => Config(
        id: json['id'],
        title: json['title'],
      );
}
