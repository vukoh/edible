library image_process;

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:edible/parse.dart' as parse;

Future<String> translate(String unparsed_ingredient_text) async {
  String langauge = 'en'; 
  String key = 'AIzaSyAhvb8k3CJx4B8Yp0E1Pjl207II9fCDFHM';
  String q = unparsed_ingredient_text;


  var url = 'https://translation.googleapis.com/language/translate/v2?target=' + langauge +
  '&key=' + key + '&q=' + q;
  var response = await http.get(url);
  var data;
  var raw_translations;
  var detected_language;
  var translated;

  data = Data.fromJson(json.decode(response.body));
  raw_translations = data.data['translations'];
  translated = raw_translations[0]['translatedText'];
  detected_language = raw_translations[0]['detectedSourceLangauge'];
  return translated;
}

class Data{
  Map<String, dynamic> data;

  Data({this.data});
  Data.fromJson(Map<String, dynamic> json) {
    data = json['data'];
  }
}

Future<dynamic> post(String url, var body) async{
  return await http
      .post(Uri.encodeFull(url), body: body, headers: {"Accept":"application/json"})
      .then((http.Response response) {
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    var saved_response = json.decode(response.body)['responses'][0]['textAnnotations'][0];
    var detected_language = saved_response['locale'];
    var unparsed_ingredient_text = saved_response['description'];
    print(detected_language);
    print(unparsed_ingredient_text);
    return unparsed_ingredient_text;
  });
}

Future<List<String>> overall() async {
  print("0");
  var _image = await ImagePicker.pickImage(source: ImageSource.camera);
  print("1");
  List<int> imageBytes = _image.readAsBytesSync();
  String base64Image = base64Encode(imageBytes);
  var url = 'https://vision.googleapis.com/v1/images:annotate?key=AIzaSyAhvb8k3CJx4B8Yp0E1Pjl207II9fCDFHM';
  var body = 
    {
      "requests":[
        {
          "image":{
            "content": base64Image
          },
          "features":[
            {
              "type":"TEXT_DETECTION",
            }
          ]
        }
      ]
    };
  var unparsed_ingredient_text = await post(url, json.encode(body));
  var translated_ingredients = await translate(unparsed_ingredient_text);
  print(unparsed_ingredient_text);
  print(translated_ingredients);
  return parse.clean(translated_ingredients);
}