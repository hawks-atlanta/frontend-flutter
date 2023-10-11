import 'package:flutter_dotenv/flutter_dotenv.dart';
//patron adaptador, si quiero modificar algo de .env todo va a estar igual
class Enviroment {
  static initEnviroment() async {
    await dotenv.load(fileName: "env");
  }
  static String apiURL = dotenv.env['API_URL'] ?? 'NoFoundENV';

}