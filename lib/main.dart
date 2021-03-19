import 'dart:developer';

import 'package:chopper/chopper.dart' as Chopper;
import 'package:flutter/material.dart';
import 'package:kraken_network_arch_chopper/network/service/api_service.dart';

import 'model/post.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ApiService service;

  List<Post> postList = List<Post>();

  @override
  void initState() {
    service = ApiService.create();
    super.initState();
  }

  void _getPostsAndReloadScreen() async {
    this.postList = await getPosts();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: buildPostList(),
      floatingActionButton: FloatingActionButton(
        onPressed: _getPostsAndReloadScreen,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  // 1
  Future<List<Post>> getPosts() async {
    // 2
    final Chopper.Response postResponse = await service.getPosts();

    // 3
    if (postResponse.isSuccessful) {
      // 4
      final postObjectList = postResponse.body as List;
      // 5
      final posts = postObjectList
          .map((singleJsonObject) => Post.fromJson(singleJsonObject))
          .toList();
      return posts;
    } else {
      // 6
      return List<Post>();
    }
  }

  Widget buildPostList() {
    if (this.postList.isEmpty) {
      return Container(
        child: Center(
          child: Text("no items in list"),
        ),
      );
    } else {
      return Container(
        child: ListView.builder(
            itemCount: postList.length,
            itemBuilder: (BuildContext ctxt, int index) {
              return Card(
                child: ListTile(
                  leading: FlutterLogo(size: 72.0),
                  title: Text(postList[index].title),
                  subtitle: Text(postList[index].body),
                  trailing: Icon(Icons.more_vert),
                  isThreeLine: true,
                ),
              );
            }),
      );
    }
  }
}
