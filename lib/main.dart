import 'package:edible/routes.dart' as routes;
import 'package:flutter/material.dart';
import 'package:edible/screens/home/home_screen.dart';
import 'package:edible/screens/login/login_screen2.dart';
import 'package:edible/data/database_helper.dart';
import 'package:edible/models/user.dart';

import 'package:edible/database.dart' as db;

DatabaseHelper dbh = new DatabaseHelper();

void main() async {

  Widget _defaultHome = new LoginScreen2();

  bool _isLoggedIn = await dbh.isLoggedIn();
  
  if(_isLoggedIn){
    User user = await dbh.getUser();
    print(user);
    _defaultHome = new HomeScreen(title: 'Edible', user: user);
  }

  runApp(new MyApp(_defaultHome));

}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  MyApp(this._home);

  final Widget _home;

  @override
  Widget build(BuildContext context) {
    db.fetchIngredient().then((value){
      db.ingredients.addAll(value);
    });

    return MaterialApp(
      title: 'Edible',
      theme: ThemeData(primarySwatch: Colors.green),
      home: _home,
      routes: routes.routes,
    );
  }
}


