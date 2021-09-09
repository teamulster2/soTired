import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';

import 'package:flutter/services.dart';

void main() async {

  // connect to the socket server
  final Socket socket = await Socket.connect('192.168.42.20', 50000);
  print('Connected to: ${socket.remoteAddress.address}:${socket.remotePort}');

  // listen for responses from the server
  socket.listen(

    // handle data from the server
        (Uint8List data) {
      final String serverResponse = String.fromCharCodes(data);
      print('Server: $serverResponse');
    },

    // handle errors
    onError: (error) {
      print(error);
      socket.destroy();
    },

    // handle server ending connection
    onDone: () {
      print('Server left.');
      socket.destroy();
    },
  );

  // send some messages to the server
  await sendMessage(socket, 'Ich bin eine Config und ich bin wunderschoen.');
  //await sendJson(socket, 'app/bin/test.json');
}



// Future<void> sendMessage(Socket socket, String jsonUrl) async {
//   final String response = await rootBundle.loadString(jsonUrl);
//
//   var jsonString = json.encode(response);
//   var bytes = jsonString.codeUnits;
//
//   socket.add(bytes);
// }

Future<void> sendJson(Socket socket, String jsonUrl) async {

  final String response = await rootBundle.loadString(jsonUrl);

  socket.add(response.codeUnits);
}


Future<void> sendMessage(Socket socket, String message) async {
  socket.write(message);
  await Future.delayed(const Duration(seconds: 2));
}
