import 'package:flutter/material.dart';
import '../services/api_service.dart';

class JokeScreen extends StatelessWidget {
  final String type;

  JokeScreen({required this.type});

  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Joke: $type")),
      body: FutureBuilder<Map<String, dynamic>>(
        future: apiService.fetchRandomJokeByType(type),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            final joke = snapshot.data ?? {};
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    joke['setup'] ?? "No joke found",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Text(
                    joke['punchline'] ?? "",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
