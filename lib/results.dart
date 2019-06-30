import 'dart:io';

import 'package:edible/search.dart';
import 'package:edible/ingredient.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:http/http.dart';
import 'dart:convert';

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

void init() async {
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
class ResultsPage extends StatelessWidget {
  var initial = init();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Results"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}