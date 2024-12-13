import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://official-joke-api.appspot.com";

  Future<List<String>> fetchJokeTypes() async {
    final response = await http.get(Uri.parse("$baseUrl/types"));

    if (response.statusCode == 200) {
      return List<String>.from(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load joke types");
    }
  }

  Future<Map<String, dynamic>> fetchRandomJokeByType(String type) async {
    final response = await http.get(Uri.parse("$baseUrl/jokes/$type/random"));

    if (response.statusCode == 200) {
      return jsonDecode(response.body)[0];
    } else {
      throw Exception("Failed to load random joke");
    }
  }
}