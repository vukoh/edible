import 'package:edible/routes.dart' as routes;
import 'package:flutter/material.dart';

import 'package:edible/database.dart' as db;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    db.fetchIngredient().then((value){
      db.ingredients.addAll(value);
    });

    return MaterialApp(
      title: 'Edible',
      theme: ThemeData(primarySwatch: Colors.green),
      routes: routes.routes,
    );
  }
}


