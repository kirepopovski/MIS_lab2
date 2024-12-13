import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jokes_app/models/joke.dart';

class JokesListScreen extends StatefulWidget {
  final String type;

  JokesListScreen({required this.type});

  @override
  _JokesListScreenState createState() => _JokesListScreenState();
}

class _JokesListScreenState extends State<JokesListScreen> {
  late Future<List<Joke>> jokes;

  @override
  void initState() {
    super.initState();
    jokes = fetchJokes(widget.type);
  }

  Future<List<Joke>> fetchJokes(String type) async {
    final response = await http.get(Uri.parse('https://official-joke-api.appspot.com/jokes/$type/ten'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Joke.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load jokes');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.type} Jokes'),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<List<Joke>>(
        future: jokes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final joke = snapshot.data![index];
                return Card(
                  child: ListTile(
                    title: Text(joke.setup),
                    subtitle: Text(joke.punchline),
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('No jokes found.'));
          }
        },
      ),
    );
  }
}
