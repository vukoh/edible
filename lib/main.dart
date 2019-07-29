import 'package:edible/data/foodDatabase_helper.dart';
import 'package:edible/routes.dart' as routes;
import 'package:flutter/material.dart';
import 'package:edible/screens/home/home_screen.dart';
import 'package:edible/screens/login/login_screen2.dart';
import 'package:edible/data/database_helper.dart';
import 'package:edible/models/user.dart';
import 'package:edible/utils/network_util.dart';

import 'package:edible/database.dart' as db;

DatabaseHelper dbh = new DatabaseHelper();
FoodDatabaseHelper fdb = new FoodDatabaseHelper();
NetworkUtil _netUtil = NetworkUtil();

void main() async {

  Widget _defaultHome = new LoginScreen2();
  bool _isLoggedIn = await dbh.isLoggedIn();
  int fdbLocalVersion = await fdb.getVersion();
  var versionJSON = await _netUtil.get("https://cryptic-lake-93970.herokuapp.com/ingredients/version");
  int fdbOnlineVersion = versionJSON["version"];

  print(fdbLocalVersion);
  print(fdbOnlineVersion);
  if(fdbLocalVersion != fdbOnlineVersion){
    await fdb.updateDB();
    fdb.setVersion(fdbOnlineVersion);
  }

  if(_isLoggedIn){
    User user = await dbh.getUser();
    print(user);
    _defaultHome = new HomeScreen(title: 'Edible', user: user);
  }

  db.ingredients = await fdb.getIngredients();

  runApp(new MyApp(_defaultHome));

}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  MyApp(this._home);

  final Widget _home;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Edible',
      theme: ThemeData(primarySwatch: Colors.green),
      home: _home,
      routes: routes.routes,
    );
  }
}


