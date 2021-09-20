import 'dart:convert';

import 'package:http/http.dart';
import 'package:so_tired/database/database_manager.dart';
import 'package:so_tired/exceptions/exceptions.dart';

/// Sends a request to the server and checks the availability.
Future<void> validateServerConnection(Function onServerReachable,
    Function onServerNotReachable, String url) async {
  try {
    final Response response = await post(Uri.parse('$url/identity'));
    if (response.statusCode == 200 && response.body.contains('sotiserver')) {
      onServerReachable();
    } else {
      onServerNotReachable();
    }
  } on Exception {
    onServerNotReachable();
  }
}

/// Sends a request to the server and gets a config file back.
Future<String> loadConfig(String url) async {
  try {
    final Response response = await post(
      Uri.parse('$url/config'),
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
  } catch (e) {
    rethrow;
  }
}

/// Sends the full database to the server.
Future<void> sendData(String url) async {
  try {
    final String jsonDatabase =
        jsonEncode(DatabaseManager().exportDatabaseForTransfer());
    final Response response = await post(
      Uri.parse('$url/data'),
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
  } catch (e) {
    rethrow;
  }
}
