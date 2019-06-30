import 'package:edible/results.dart';
import 'package:edible/search.dart';
import 'package:flutter/material.dart';
<<<<<<< HEAD

=======
import 'package:http/http.dart'; //For repeated method
import 'dart:convert'; //For repeated method
import 'package:image_picker/image_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:edible/database.dart' as db;
>>>>>>> 901a18d3a5d60da09ae524c68bf8c6e56d4af779

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
      home: MyHomePage(title: 'Edible Home'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

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
