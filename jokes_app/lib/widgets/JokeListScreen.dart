import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class JokesListScreen extends StatefulWidget {
  @override
  _JokesListScreenState createState() => _JokesListScreenState();
}

class _JokesListScreenState extends State<JokesListScreen> {
  bool _isLoading = true;
  List<String> jokeTypes = [];
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    _fetchJokeTypes();
  }


  Future<void> _fetchJokeTypes() async {
    final response = await http.get(Uri.parse('https://official-joke-api.appspot.com/types'));

    if (response.statusCode == 200) {
      setState(() {
        jokeTypes = List<String>.from(json.decode(response.body));
        _isLoading = false;
      });

      for (int i = 0; i < jokeTypes.length; i++) {
        await Future.delayed(Duration(milliseconds: 300));
        _listKey.currentState?.insertItem(i);
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jokes List'),
      ),
      body: Center(
        child: AnimatedOpacity(
          opacity: _isLoading ? 1.0 : 0.0,
          duration: Duration(seconds: 1),
          child: _isLoading
              ? CircularProgressIndicator(
            strokeWidth: 6.0,
          )
              : AnimatedList(
            key: _listKey, // AnimatedList key
            initialItemCount: jokeTypes.length,
            itemBuilder: (context, index, animation) {
              return _buildAnimatedItem(jokeTypes[index], animation);
            },
          ),
        ),
      ),
    );
  }


  Widget _buildAnimatedItem(String jokeType, Animation<double> animation) {
    return FadeTransition(
      opacity: animation,
      child: Card(
        child: ListTile(
          title: Text(jokeType),
        ),
      ),
    );
  }
}
