import 'package:flutter/material.dart';
import 'package:flutter_sample_app/data/response.dart';
import 'package:flutter_sample_app/detail.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Featured Repo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({this.title});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<RepoResponse> fetchRepos() async {
    final response = await http
        .get('https://api.github.com/search/repositories?q=flutter:featured');
    if (response.statusCode == 200) {
      print(response.body);
      // If the call to the server was successful, parse the JSON
      return RepoResponse.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load repositories');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Feature repsitories"),
        centerTitle: true,
      ),
      body: FutureBuilder<RepoResponse>(
        future: fetchRepos(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemBuilder: (context, index) {
                return ListItemWidget(snapshot.data, index);
              },
              itemCount: snapshot.data.totalCount,
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class ListItemWidget extends StatefulWidget {
  final RepoResponse data;
  final int index;

  ListItemWidget(this.data, this.index);

  @override
  _ListItemWidgetState createState() => _ListItemWidgetState();
}

class _ListItemWidgetState extends State<ListItemWidget> {
  Items item;
  SharedPreferences prefs;

  @override
  void initState() {
    item = widget.data.items[widget.index];
    getPref(item);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: item.owner.avatarUrl,
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(
            item.owner.avatarUrl,
          ),
        ),
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Detail(item)));
        },
        trailing: IconButton(
          icon: Icon(
            item.isFav ? Icons.favorite : Icons.favorite_border,
            color: Colors.redAccent,
          ),
          onPressed: () {
            addToFav(item);
          },
        ),
        title: Text(
          widget.data.items[widget.index].fullName,
          style: Theme.of(context).textTheme.title,
        ),
      ),
    );
  }

  void getPref(Items item) async {
    prefs = await SharedPreferences.getInstance();
    item.isFav = prefs.getBool(item.fullName) == null
        ? false
        : prefs.getBool(item.fullName);
    setState(() {});
  }

  void addToFav(Items item) async {
    item.isFav = !item.isFav;
    await prefs.setBool(item.fullName, item.isFav);
    setState(() {});
  }
}
