library edible_parse;

import 'dart:io';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:image_picker/image_picker.dart';


Future<List<String>> readTextfromCamera() async {

  List<List<String>> ingredientsListToCheck = new List<List<String>>();

  File pickedImage = await ImagePicker.pickImage(source: ImageSource.camera);
  FirebaseVisionImage ourImage = FirebaseVisionImage.fromFile(pickedImage);
  TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
  VisionText readText = await recognizeText.processImage(ourImage);
  for (TextBlock block in readText.blocks) {
    ingredientsListToCheck.add(splitByComma(block.text));
  }
  List<String> finalList = new List<String>();
  for (List<String> blockList in ingredientsListToCheck) {
    for (String ingredient in blockList) {
        finalList.add(ingredient);
    }
  }
  return finalList;
}
//Todo: Fix function so using back in camera doesn't crash app, add option to pick from library

List<String> splitByComma(String rawtext) {
  List<String> returnedList = rawtext.split(",");
  return returnedList;
}
