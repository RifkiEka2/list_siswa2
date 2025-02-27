import 'dart:convert';
import 'package:siswa_app/utils/constants.dart';
import 'package:http/http.dart' as http;

class Services {
  final url = Uri.parse("${Constants.url}student");

  Future<Map<String, dynamic>> deleteData(String id) async {
    final response =
        await http.delete(Uri.parse("${Constants.url}student/$id"));
    var jsonData = await jsonDecode(response.body);
    return jsonData;
  }

  Future<Map<String, dynamic>> getData() async {
    final response = await http.get(url);
    var jsonData = await jsonDecode(response.body);
    return jsonData;
  }

  Future<Map<String, dynamic>> postData(
    String firstName,
    String lastName,
    String classes,
    String major,
  ) async {
    final response = await http.post(url, headers: {
      "Accept": "application/json",
    }, body: {
      "classes": classes,
      "major": major,
      "fname": firstName,
      "lname": lastName,
    });
    var jsonData = await jsonDecode(response.body);
    return {
      "data": jsonData,
      "status": response.statusCode,
    };
  }
}
