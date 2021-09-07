import "package:grpc/grpc.dart" show CallOptions, ChannelCredentials, ChannelOptions, ClientChannel, CodecRegistry, GzipCodec, IdentityCodec;
import 'package:so_tired/api/generated/api.pb.dart';
import 'package:so_tired/api/generated/api.pbgrpc.dart' show GreeterClient, HelloRequest;

class Client {
  Future<void> main(List<String> args) async {
    final ClientChannel channel = ClientChannel(
      'localhost',
      port: 50051,
      options: ChannelOptions(
        credentials: const ChannelCredentials.insecure(),
        codecRegistry:
        // ignore: always_specify_types
            CodecRegistry(codecs: const [GzipCodec(), IdentityCodec()]),
      ),
    );
    final GreeterClient stub = GreeterClient(channel);

    final String name = args.isNotEmpty ? args[0] : 'world';

    try {
      final HelloReply response = await stub.sayHello(
        HelloRequest()..name = name,
        options: CallOptions(compression: const GzipCodec()),
      );
      // ignore: avoid_print
      print('Greeter client received: ${response.message}');
    } catch (e) {
      // ignore: avoid_print
      print('Caught error: $e');
    }
    await channel.shutdown();
  }
}
