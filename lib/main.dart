import 'dart:io';
import 'package:edible/results.dart';
import 'package:edible/search.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:image_picker/image_picker.dart';
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
            MaterialPageRoute(builder: (context) => ResultsPage(readTextfromCamera())),
          );
        },
      ),
    );
  }
}
Future<List<String>> readTextfromCamera() async {
  List<String> _stringIngredientNamesToCheck = List<String>();

  File pickedImage = await ImagePicker.pickImage(source: ImageSource.camera);
  FirebaseVisionImage ourImage = FirebaseVisionImage.fromFile(pickedImage);
  TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
  VisionText readText = await recognizeText.processImage(ourImage);

  for (TextBlock block in readText.blocks) {
    for (TextLine line in block.lines) {
      for (TextElement word in line.elements) {
        _stringIngredientNamesToCheck.add(word.text);
      }
    }
  }
  return _stringIngredientNamesToCheck;
}
//Todo: Fix function so using back in camera doesn't crash app