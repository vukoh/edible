import 'dart:io';

import 'package:edible/search.dart';
import 'package:edible/ingredient.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'; //For repeated method
import 'dart:convert'; //For repeated method
import 'package:image_picker/image_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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

  Future<List<Ingredient>> fetchIngredient() async {
    var url = 'https://cryptic-lake-93970.herokuapp.com/ingredients';
    var response = await get(url);

    var ingredients = List<Ingredient>();
  	
    if (response.statusCode == 200) {
      var ingredientsJson = json.decode(response.body);
      for (var ingredientJson in ingredientsJson) {
        ingredients.add(Ingredient.fromJson(ingredientJson));
      }
    }

    return ingredients;
  }
  //Repeated function from search.dart, how to abstract this away but mounted/not mounted issue
  
  void finalFunction() async {
    var _stringIngredientNamesToCheck = await readTextfromCamera();
    var ingredients = await fetchIngredient();
    bool _foundIngredient = false;

    for(String name_to_check in _stringIngredientNamesToCheck) {
      _foundIngredient = false;
      for(Ingredient curr_ingredient in ingredients) {
        if(curr_ingredient.name == name_to_check) {
          _foundIngredient = true;
          print('Found ingredient: ' + name_to_check);
          if(curr_ingredient.isHalal()) {
            print(name_to_check + ' is halal');
          } else {
            print(name_to_check + ' is not halal');
          }
        }
      }
      if(_foundIngredient == false) {
        print(name_to_check + ' not found');
      }
    }
  }
  //Rename to something better, better architecture possible?

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
        onPressed: finalFunction,
      ),
    );
  }
}
