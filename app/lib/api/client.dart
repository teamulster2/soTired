import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:so_tired/exceptions/exceptions.dart';

Future<String> loadConfig(String url) async {
  final http.Response response = await http.post(
    Uri.parse(url + '/config'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  // TODO: Add better exception handling for response.
  if (response.statusCode == 200) {
    return response.body;
  } else {
    final int statusCode = response.statusCode;
    throw LoadConfigException('Failed to load config. \n'
        'Response status code: $statusCode');
  }
}

Future<void> sendData(String url, Map<String, dynamic> database) async {
  final String jsonDatabase = jsonEncode(database);
  final http.Response response = await http.post(
    Uri.parse(url + '/data'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonDatabase,
  );
  if (response.statusCode != 200) {
    final int statusCode = response.statusCode;
    throw SendDataException('Failed to send data.\n'
        'Response status code: $statusCode');
  }

//ignore: avoid_print
  print('Response statusCode: ' + response.statusCode.toString());
}
