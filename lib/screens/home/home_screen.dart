import 'package:flutter/material.dart';
import 'package:edible/results.dart';
import 'package:edible/search.dart';
import 'package:edible/data/database_helper.dart';
import 'package:edible/models/user.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key key, this.title, this.user}) : super(key: key);

  final String title;
  final User user;

  final DatabaseHelper db = new DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.title),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ButtonTheme(
                  minWidth: 200.0,
                  height: 100.0,
                  child: RaisedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SearchPage()),
                        );
                      },
                      elevation: 20.0,
                      color: Colors.green,
                      child: Text('Search an Ingredient')))
            ]),
      ),
      drawer: new Drawer(
        child: ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Text(user.password),
              accountEmail: new Text(user.username), 
            ),
            new ListTile(
              title: new Text('Logout'),
              onTap: (){
                db.deleteUsers();
                Navigator.of(context).pushReplacementNamed('/login');
              },
            )
          ],
        ),),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ResultsPage()),
          );
        },
      ),
    );
  }
}