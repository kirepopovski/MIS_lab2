import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jokes_app/models/joke.dart';
import 'package:jokes_app/screens/FavoritesScreen.dart';

class JokesListScreen extends StatefulWidget {
  final String type;

  JokesListScreen({required this.type});

  @override
  _JokesListScreenState createState() => _JokesListScreenState();
}

class _JokesListScreenState extends State<JokesListScreen> {
  late Future<List<Joke>> jokes;
  List<Joke> favoriteJokes = []; // To store favorite jokes

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

  void addToFavorites(Joke joke) {
    setState(() {
      if (!favoriteJokes.contains(joke)) {
        favoriteJokes.add(joke);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.type} Jokes'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              // Navigate to the Favorites Screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoritesScreen(favoriteJokes: favoriteJokes),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Joke>>(
        future: jokes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 6.0,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final joke = snapshot.data![index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(15),
                    title: Text(
                      joke.setup,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                    ),
                    subtitle: Text(
                      joke.punchline,
                      style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        favoriteJokes.contains(joke) ? Icons.favorite : Icons.favorite_border,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        addToFavorites(joke); // Add to favorites
                      },
                    ),
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
