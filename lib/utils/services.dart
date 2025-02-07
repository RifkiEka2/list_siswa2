import 'dart:convert';
import 'package:siswa_app/utils/constants.dart';
import 'package:http/http.dart' as http;

class Services {
  final url = Uri.parse("${Constants.url}student");

  Future<Map<String, dynamic>> getData() async {
    final response = await http.get(url);
    var jsonData = jsonDecode(response.body);
    return jsonData['data'];
  }

  Future<Map<String, dynamic>> postData(
    String firstName,
    String lastName,
    String classess,
    String major,
  ) async {
    final response = await http.post(url, headers: {
      "Accept": "application/json",
    }, body: {
      "classess": classess,
      "major": major,
      "firstName": firstName,
      "lastName": lastName,
    });
    var jsonData = await jsonDecode(response.body);
    return {
      "data": jsonData,
      "status": response.statusCode,
    };
  }
}
