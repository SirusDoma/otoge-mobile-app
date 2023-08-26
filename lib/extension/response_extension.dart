import 'package:http/http.dart' as http;

extension ResponseExtension on http.Response {
  bool get success {
    return (statusCode ~/ 100) == 2;
  }
}