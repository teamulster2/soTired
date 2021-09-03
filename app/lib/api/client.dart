import 'package:grpc/grpc.dart';
import 'generated/api.pbgrpc.dart';

class Client {
  Future<void> main(List<String> args) async {
    final channel = ClientChannel(
      'localhost',
      port: 50051,
      options: ChannelOptions(
        credentials: ChannelCredentials.insecure(),
        codecRegistry:
        CodecRegistry(codecs: const [GzipCodec(), IdentityCodec()]),
      ),
    );
    final stub = GreeterClient(channel);

    final name = args.isNotEmpty ? args[0] : 'world';

    try {
      final response = await stub.sayHello(
        HelloRequest()
          ..name = name,
        options: CallOptions(compression: const GzipCodec()),
      );
      print('Greeter client received: ${response.message}');
    } catch (e) {
      print('Caught error: $e');
    }
    await channel.shutdown();
  }
}