import 'dart:io';
void main() async {
  final server = await HttpServer.bind('localhost', 8080);
  print('Server running on http://${server.address.host}:${server.port}/');

  await for (HttpRequest request in server) {
    final file = File('./build/web${request.uri == '/' ? '/index.html' : request.uri}');
    if (await file.exists()) {
      request.response.headers.add('Access-Control-Allow-Origin', '*');
      request.response.headers.add('Access-Control-Allow-Methods', 'GET');
      await request.response.addStream(file.openRead());
    } else {
      request.response.statusCode = HttpStatus.notFound;
      request.response.write('Not Found');
    }
    await request.response.close();
  }
}