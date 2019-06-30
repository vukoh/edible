import 'dart:io';
import 'package:edible/database.dart' as db;
import 'package:edible/ingredient.dart';
import 'package:flutter/material.dart';
import 'package:edible/information.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:image_picker/image_picker.dart';


//Rename to something better, better architecture possible?
class ResultsPage extends StatelessWidget {
  List<String> _stringIngredientNamesToCheck = new List<String>();
  List<Ingredient> nonHalalIngredients = new List<Ingredient>();
  List<String> missingIngredients = new List<String>();
  List<Ingredient> halalIngredients = new List<Ingredient>();

  List<ListItem> setHalal() {
    //Logic for seperating
    for(String name_to_check in _stringIngredientNamesToCheck) {
      bool foundIngredient = false;
      for(Ingredient curr_ingredient in db.ingredients) {
        if(curr_ingredient.name.contains(name_to_check)) {
          foundIngredient = true;
          if(curr_ingredient.isHalal()) {
            halalIngredients.add(curr_ingredient);
            break;
          } else {
            nonHalalIngredients.add(curr_ingredient);
            break;
          }
        }
      }
      if(foundIngredient == false) {
        missingIngredients.add(name_to_check);
      }
    }
    //Combining into one list
    List<ListItem> outputList = new List<ListItem>();

    outputList.add(new HeadingItem('Non-Halal Ingredients'));
    for(Ingredient curr_nonHalalIngredient in nonHalalIngredients) {
      outputList.add(new IngredientItem(curr_nonHalalIngredient));
    }
    if(nonHalalIngredients.isEmpty) {
      outputList.add(new MessageItem('No non-halal ingredients found!'));
    }

    outputList.add(new HeadingItem('Missing Ingredients'));
    for(String curr_missingIngredient in missingIngredients) {
      outputList.add(new MessageItem(curr_missingIngredient));
    }
    if(missingIngredients.isEmpty) {
      outputList.add(new MessageItem('No missing ingredients - all ingredients found!'));
    }

    outputList.add(new HeadingItem('Halal Ingredients'));
    for(Ingredient curr_halalIngredient in halalIngredients) {
      outputList.add(new IngredientItem(curr_halalIngredient));
    }
    if(halalIngredients.isEmpty) {
      outputList.add(new MessageItem('No halal ingredients found!'));
    }

    return outputList;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: readTextfromCamera(),
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        if(snapshot.connectionState == ConnectionState.done){
          final title = 'Results';
          _stringIngredientNamesToCheck = snapshot.data;
          final List<ListItem> items = setHalal();
          return MaterialApp(
            title: title,
            home: Scaffold(
              appBar: AppBar(
                title: Text(title),
              ),
              body: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];

                  if (item is HeadingItem) {
                    return ListTile(
                      title: Text(
                        item.heading,
                        style: Theme.of(context).textTheme.headline,
                      ),
                    );
                  } else if (item is MessageItem) {
                    return ListTile(
                      title: Text(item.sender),
                    );
                  } else if (item is IngredientItem) {
                    return ListTile(
                      title: Text(item.ingredient.name),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                              InformationPage(item.ingredient)));
                      },
                    );
                  }
                },
              ),
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      }
    );
  }
}
abstract class ListItem {}

// A ListItem that contains data to display a heading.
class HeadingItem implements ListItem {
  final String heading;
  HeadingItem(this.heading);
}

// A ListItem that contains data to display a message.
class MessageItem implements ListItem {
  final String sender;
  MessageItem(this.sender);
}
class IngredientItem implements ListItem {
  final Ingredient ingredient;
  IngredientItem(this.ingredient);
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