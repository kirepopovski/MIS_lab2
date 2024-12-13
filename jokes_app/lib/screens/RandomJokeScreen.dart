import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RandomJokeScreen extends StatefulWidget {
  @override
  _RandomJokeScreenState createState() => _RandomJokeScreenState();
}

class _RandomJokeScreenState extends State<RandomJokeScreen> {
  late Future<Map<String, String>> randomJoke;

  @override
  void initState() {
    super.initState();
    randomJoke = fetchRandomJoke();
  }

  Future<Map<String, String>> fetchRandomJoke() async {
    final response = await http.get(Uri.parse('https://official-joke-api.appspot.com/random_joke'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return {
        'setup': data['setup'],
        'punchline': data['punchline'],
      };
    } else {
      throw Exception('Failed to load random joke');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Random Joke of the Day'),
        backgroundColor: Colors.yellow,
      ),
      body: FutureBuilder<Map<String, String>>(
        future: randomJoke,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    snapshot.data!['setup']!,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Text(
                    snapshot.data!['punchline']!,
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          } else {
            return Center(child: Text('No joke found.'));
          }
        },
      ),
    );
  }
}
