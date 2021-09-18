import 'dart:convert';

import 'package:http/http.dart';
import 'package:so_tired/database/database_manager.dart';
import 'package:so_tired/exceptions/exceptions.dart';

/// Sends a request to the server and checks the availability.
Future<bool> isServerReachable(String url) async {
  final Response response = await post(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

/// Sends a request to the server and gets a config file back.
Future<String> loadConfig(String url) async {
  final Response response = await post(
    Uri.parse(url + 'config'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
    return response.body;
  } else {
    final int statusCode = response.statusCode;
    throw HttpErrorCodeException('Failed to load config. \n'
        'Response status code: $statusCode');
  }
}

/// Sends the full database to the Server.
Future<void> sendData(String url) async {
  final String jsonDatabase =
      jsonEncode(DatabaseManager().exportDatabaseForTransfer());
  final Response response = await post(
    Uri.parse(url + 'data'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonDatabase,
  );
  if (response.statusCode != 200) {
    final int statusCode = response.statusCode;
    throw HttpErrorCodeException('Failed to send data.\n'
        'Response status code: $statusCode');
  }
// TODO: test the function with real data.
//ignore: avoid_print
  print('Response statusCode: ' + response.statusCode.toString());
}
