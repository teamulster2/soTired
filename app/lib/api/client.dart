import 'package:http/http.dart' as http;

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
    throw Exception('Failed to load config.');
  }
}

Future<void> sendData(String url, String jsonDatabase) async {
  final http.Response response = await http.post(
    Uri.parse(url + '/data'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonDatabase,
  );
//ignore: avoid_print
  print('Response: ' + response.body);
}
