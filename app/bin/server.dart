import 'dart:io';
import 'dart:typed_data';


void main() async {
  // bind the socket server to an address and port
  final server = await ServerSocket.bind('192.168.42.20', 50000);

  // listen for client connections to the server
  server.listen((client) {
    handleConnection(client);
  });
}

void handleConnection(Socket client) {
  print('Connection from'
      ' ${client.remoteAddress.address}:${client.remotePort}');

  // listen for events from the client
  client.listen(

    // handle data from the client
        (Uint8List data) async {
      await Future.delayed(Duration(seconds: 1));
      final message = String.fromCharCodes(data);
      print('Client:' + message);
        client.write('Prima');
        client.close();
    },

    // handle errors
    onError: (error) {
      print(error);
      client.close();
    },

    // handle the client closing the connection
    onDone: () {
      print('Client left');
      client.close();
    },
  );
}