import 'package:flutter/material.dart';
import 'package:edible/results.dart';
import 'package:edible/search.dart';
import 'package:edible/data/database_helper.dart';
import 'package:edible/models/user.dart';
import 'package:edible/screens/accountInfo/accountInfo_screen.dart';

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
        backgroundColor: Color.fromRGBO(58, 86, 58, 1.0),
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
                      color: Color.fromRGBO(64, 96, 64, .9),
                      child: Text(
                        'Search an Ingredient',
                        style: TextStyle(color: Colors.white),
                      )))
            ]),
      ),
      drawer: new Drawer(
        child: ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
                accountName: new Text(user.firstName + " " + user.lastName),
                accountEmail: new Text(user.username),
                currentAccountPicture:
                    Image(image: AssetImage('images/acc_icon.png'))),
            new ListTile(
              title: new Text('Account Info'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => new AccountInfoScreen()));
              },
            ),
            new ListTile(
              title: new Text('Change Account Settings'),
              onTap: () {},
            ),
            new ListTile(
              title: new Text('Logout'),
              onTap: () {
                db.deleteUsers();
                Navigator.of(context).pushReplacementNamed('/login');
              },
            )
          ],
        ),
      ),
      backgroundColor: Color.fromRGBO(58, 86, 58, 1.0),
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
