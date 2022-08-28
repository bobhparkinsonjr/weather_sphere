import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../devtools/logger.dart';

class NetworkTools {
  static Future<dynamic> httpGetJson(String url, {int timeoutSeconds = 30}) async {
    try {
      http.Response response;
      if (timeoutSeconds > 0) {
        response = await http.get(Uri.parse(url)).timeout(Duration(seconds: timeoutSeconds));
      } else {
        response = await http.get(Uri.parse(url));
      }

      if (response.statusCode == 200) {
        String data = response.body;

        return convert.jsonDecode(data);
      } else {
        Logger.print('http get error | status code: ${response.statusCode}');
      }
    } catch (e) {
      Logger.print(e.toString());
    }

    return null;
  }
}
