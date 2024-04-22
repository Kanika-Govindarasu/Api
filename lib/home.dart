import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/model.dart/todos.dart';

class Home extends StatefulWidget {
  const Home({Key? key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<Todos>> _futurePosts;

  @override
  void initState() {
    super.initState();
    _futurePosts = fetchPosts();
  }

  Future<List<Todos>> fetchPosts() async {
    var response =
        await http.get(Uri.parse("https://jsonplaceholder.typicode.com/todos"));

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      List<Todos> posts = jsonList.map((e) => Todos.fromJson(e)).toList();
      return posts;
    } else {
      throw Exception("Data not fetched");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("API Example"),
      ),
      body: FutureBuilder(
        future: _futurePosts,
        builder: (context, AsyncSnapshot<List<Todos>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error fetching data"),
            );
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data![index].id.toString()),
                  subtitle: Text(snapshot.data![index].title),
                  trailing:Text(snapshot.data![index].completed.toString()) ,
                );
              },
            );
          } else {
            return Center(
              child: Text("No data"),
            );
          }
        },
      ),
    );
  }
}