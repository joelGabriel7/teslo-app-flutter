import 'package:flutter_dotenv/flutter_dotenv.dart';

class Enviroments {

  static initEnviroments() async => await dotenv.load(fileName: ".env");
  static String apiUrl = dotenv.env['API_URL'] ?? 'NO ESTA CONFIGURADO EL APIURL';
}
