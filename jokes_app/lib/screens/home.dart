import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'JokesListScreen.dart';
import 'RandomJokeScreen.dart';

class HomeScreen extends StatelessWidget {
  final List<String> jokeTypes = ['general', 'programming', 'knock-knock'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Joke Categories'),
        backgroundColor: Colors.greenAccent,
        actions: [
          IconButton(
            color: Colors.yellow,
            icon: Icon(Icons.star),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RandomJokeScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: jokeTypes.length,
        itemBuilder: (context, index) {
          return Card(
            color: Colors.lightBlueAccent,
            child: ListTile(
              title: Text(jokeTypes[index]),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JokesListScreen(type: jokeTypes[index]),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
