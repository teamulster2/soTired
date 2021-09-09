import 'dart:convert';

import 'package:http/http.dart' as http;

main(){
  Future<Config> loadConfig(String title) async {
    final http.Response response = await http.post(
      Uri.parse('localhost'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'title': title,
      }),
    );

    print(response.body);

    if (response.statusCode == 201) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return Config.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');
    }
  }
  Future<void> writeConfig() async{
    loadConfig("title");
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
