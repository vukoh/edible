import 'package:edible/screens/changeDetails/changeDetail_screen.dart';
import 'package:flutter/material.dart';
import 'package:edible/results.dart';
import 'package:edible/search.dart';
import 'package:edible/data/database_helper.dart';
import 'package:edible/models/user.dart';
import 'package:edible/screens/accountInfo/accountInfo_screen.dart';
import 'package:edible/database.dart' as fdb;
import 'package:edible/ingredient.dart';
import 'package:edible/information.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key key, this.title, this.user}) : super(key: key);

  final String title;
  final User user;

  final DatabaseHelper db = new DatabaseHelper();
  final List<Ingredient> _ingredientsForDisplay = fdb.ingredients;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.title),
        backgroundColor: Color.fromRGBO(58, 86, 58, 1.0),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPage()),
              );
            },
          )
        ],
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return _listItem(index, context);
        },
        itemCount: _ingredientsForDisplay.length,
      ),
      // body: Center(
      //   child: Column(
      //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //       children: <Widget>[
      //         ButtonTheme(
      //             minWidth: 200.0,
      //             height: 100.0,
      //             child: RaisedButton(
      //                 onPressed: () {
      //                   Navigator.push(
      //                     context,
      //                     MaterialPageRoute(builder: (context) => SearchPage()),
      //                   );
      //                 },
      //                 elevation: 20.0,
      //                 color: Color.fromRGBO(64, 96, 64, .9),
      //                 child: Text(
      //                   'Search an Ingredient',
      //                   style: TextStyle(color: Colors.white),
      //                 )))
      //       ]),
      // ),
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
                        builder: (context) => new AccountInfoScreen(user)));
              },
            ),
            new ListTile(
              title: new Text('Change Account Settings'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => new ChangeDetailScreen(user)));
              },
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
        backgroundColor: Color.fromRGBO(64, 96, 10, 1.0),
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

  _listItem(index, context) {
    return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      InformationPage(_ingredientsForDisplay[index])));
        },
        child: Card(
            elevation: 8.0,
            color: Color.fromRGBO(64, 96, 64, .9),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 32.0, bottom: 32.0, left: 16.0, right: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(_ingredientsForDisplay[index].name,
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade200)),
                  Text(_ingredientsForDisplay[index].description,
                      style: TextStyle(color: Colors.grey.shade400)),
                ],
              ),
            )));
  }
}
