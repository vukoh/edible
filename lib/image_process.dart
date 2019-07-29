library image_process;

import 'package:edible/results.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:edible/parse.dart' as parse;
import 'package:edible/data/database_helper.dart';
import 'package:edible/models/user.dart';
//import 'package:image_cropper/image_cropper.dart';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';

Future<String> translate(String unparsed_ingredient_text, String _languageCode) async {
  String key = 'AIzaSyAhvb8k3CJx4B8Yp0E1Pjl207II9fCDFHM';
  String q = unparsed_ingredient_text;


  var url = 'https://translation.googleapis.com/language/translate/v2?target=' + _languageCode +
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

Future<PostResult> post(String url, var body) async{
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
    return new PostResult(unparsed_ingredient_text, detected_language);
  });
}
class PostResult {
  String unparsed_ingredient_text;
  String detected_language;
  PostResult(this.unparsed_ingredient_text, this.detected_language);
}

/*
Future<File> _cropImage(File imageFile) async {
  File croppedFile = await ImageCropper.cropImage(
    sourcePath: imageFile.path,
    ratioX: 1.0,
    ratioY: 1.0,
    maxWidth: 512,
    maxHeight: 512,
  );
  return croppedFile;
}
*/

Future<AwaitedInformation> overall() async {
  DatabaseHelper dbh = new DatabaseHelper();
  User user = await dbh.getUser();
  String userlanguageCode = getLanguage(user);
  Fluttertoast.showToast(
        msg: "Please make sure the ingredients are the only text in frame! Tip - Use your hand to cover up other text",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        //timeInSecForIos: 1,
        backgroundColor: Color.fromRGBO(58, 86, 58, 1.0),
        textColor: Colors.white,
        //fontSize: 16.0
    );
  File _image = await ImagePicker.pickImage(source: ImageSource.camera);
  //var _imagecropped = await _cropImage(_image);
  //List<int> imageBytes = _imagecropped.readAsBytesSync();
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
  var postResult = await post(url, json.encode(body));
  List<String> _stringIngredientNamesToCheckTranslated = new List<String>();
  List<String> cleaned_english_ingredients = new List<String>();
  if(postResult.detected_language == 'en') {
    cleaned_english_ingredients = parse.clean(postResult.unparsed_ingredient_text);
  } else {
    cleaned_english_ingredients = parse.clean(await translate(postResult.unparsed_ingredient_text, 'en'));
  }
  if(userlanguageCode == 'en') {
    _stringIngredientNamesToCheckTranslated = cleaned_english_ingredients;
  } else {
    for(String ingredient in cleaned_english_ingredients) {
      _stringIngredientNamesToCheckTranslated.add(await translate(ingredient, userlanguageCode));
    }
  }
  return new AwaitedInformation(user, _stringIngredientNamesToCheckTranslated, cleaned_english_ingredients);
}

String getLanguage(User user) {
  String _languageCode;
  if(user.language == 'English') {
    _languageCode = 'en';
  } else if(user.language == 'Afrikaans') {
    _languageCode = 'af';
  } else if(user.language == 'Albanian') {
    _languageCode = 'sq';
  } else if(user.language == 'Amharic') {
    _languageCode = 'am';
  } else if(user.language == 'Arabic') {
    _languageCode = 'ar';
  } else if(user.language == 'Armenian') {
    _languageCode = 'hy';
  } else if(user.language == 'Azerbaijani') {
    _languageCode = 'az';
  } else if(user.language == 'Basque') {
    _languageCode = 'eu';
  } else if(user.language == 'Belarusian') {
    _languageCode = 'be';
  } else if(user.language == 'Bengali') {
    _languageCode = 'bn';
  } else if(user.language == 'Bosnian') {
    _languageCode = 'bs';
  } else if(user.language == 'Bulgarian') {
    _languageCode = 'bg';
  } else if(user.language == 'Catalan') {
    _languageCode = 'ca';
  } else if(user.language == 'Cebuano') {
    _languageCode = 'ceb';
  } else if(user.language == 'Chinese (Simplified)') {
    _languageCode = 'zh';
  } else if(user.language == 'Chinese (Traditional)') {
    _languageCode = 'zh-TW';
  } else if(user.language == 'Corsican') {
    _languageCode = 'co';
  } else if(user.language == 'Croatian') {
    _languageCode = 'hr';
  } else if(user.language == 'Czech') {
    _languageCode = 'cs';
  } else if(user.language == 'Danish') {
    _languageCode = 'da';
  } else if(user.language == 'Dutch') {
    _languageCode = 'nl';
  } else if(user.language == 'Esperanto') {
    _languageCode = 'eo';
  } else if(user.language == 'Estonian') {
    _languageCode = 'et';
  } else if(user.language == 'Finnish') {
    _languageCode = 'fi';
  } else if(user.language == 'French') {
    _languageCode = 'fr';
  } else if(user.language == 'Frisian') {
    _languageCode = 'fy';
  } else if(user.language == 'Galician') {
    _languageCode = 'gl';
  } else if(user.language == 'Georgian') {
    _languageCode = 'ka';
  } else if(user.language == 'German') {
    _languageCode = 'de';
  } else if(user.language == 'Greek') {
    _languageCode = 'el';
  } else if(user.language == 'Gujarati') {
    _languageCode = 'gu';
  } else if(user.language == 'Haitian Creole') {
    _languageCode = 'ht';
  } else if(user.language == 'Hausa') {
    _languageCode = 'ha';
  } else if(user.language == 'Hawaiian') {
    _languageCode = 'haw';
  } else if(user.language == 'Hebrew') {
    _languageCode = 'he';
  } else if(user.language == 'Hindi') {
    _languageCode = 'hi';
  } else if(user.language == 'Hmong') {
    _languageCode = 'hmn';
  } else if(user.language == 'Hungarian') {
    _languageCode = 'hu';
  } else if(user.language == 'Icelandic') {
    _languageCode = 'is';
  } else if(user.language == 'Igbo') {
    _languageCode = 'ig';
  } else if(user.language == 'Indonesian') {
    _languageCode = 'id';
  } else if(user.language == 'Irish') {
    _languageCode = 'ga';
  } else if(user.language == 'Italian') {
    _languageCode = 'it';
  } else if(user.language == 'Japanese') {
    _languageCode = 'ja';
  } else if(user.language == 'Javanese') {
    _languageCode = 'jw';
  } else if(user.language == 'Kannada') {
    _languageCode = 'kn';
  } else if(user.language == 'Kazakh') {
    _languageCode = 'kk';
  } else if(user.language == 'Khmer') {
    _languageCode = 'km';
  } else if(user.language == 'Korean') {
    _languageCode = 'ko';
  } else if(user.language == 'Kurdish') {
    _languageCode = 'ku';
  } else if(user.language == 'Kyrgyz') {
    _languageCode = 'ky';
  } else if(user.language == 'Lao') {
    _languageCode = 'lo';
  } else if(user.language == 'Latin') {
    _languageCode = 'la';
  } else if(user.language == 'Latvian') {
    _languageCode = 'lv';
  } else if(user.language == 'Lithuanian') {
    _languageCode = 'lt';
  } else if(user.language == 'Luxembourgish') {
    _languageCode = 'lb';
  } else if(user.language == 'Macedonian') {
    _languageCode = 'mk';
  } else if(user.language == 'Malagasy') {
    _languageCode = 'mg';
  } else if(user.language == 'Malay') {
    _languageCode = 'ms';
  } else if(user.language == 'Malayalam') {
    _languageCode = 'ml';
  } else if(user.language == 'Maltese') {
    _languageCode = 'mt';
  } else if(user.language == 'Maori') {
    _languageCode = 'mi';
  } else if(user.language == 'Marathi') {
    _languageCode = 'mr';
  } else if(user.language == 'Mongolian') {
    _languageCode = 'mn';
  } else if(user.language == 'Myanmar (Burmese)') {
    _languageCode = 'my';
  } else if(user.language == 'Nepali') {
    _languageCode = 'ne';
  } else if(user.language == 'Norwegian') {
    _languageCode = 'no';
  } else if(user.language == 'Nyanja (Chichewa)') {
    _languageCode = 'ny';
  } else if(user.language == 'Pashto') {
    _languageCode = 'ps';
  } else if(user.language == 'Persian') {
    _languageCode = 'fa';
  } else if(user.language == 'Polish') {
    _languageCode = 'pl';
  } else if(user.language == 'Portuguese (Portugal, Brazil)') {
    _languageCode = 'pt';
  } else if(user.language == 'Punjabi') {
    _languageCode = 'pa';
  } else if(user.language == 'Romanian') {
    _languageCode = 'ro';
  } else if(user.language == 'Russian') {
    _languageCode = 'ru';
  } else if(user.language == 'Samoan') {
    _languageCode = 'sm';
  } else if(user.language == 'Scots Gaelic') {
    _languageCode = 'gd';
  } else if(user.language == 'Serbian') {
    _languageCode = 'sr';
  } else if(user.language == 'Sesotho') {
    _languageCode = 'st';
  } else if(user.language == 'Shona') {
    _languageCode = 'sn';
  } else if(user.language == 'Sindhi	') {
    _languageCode = 'sd';
  } else if(user.language == 'Sinhala (Sinhalese)') {
    _languageCode = 'si';
  } else if(user.language == 'Slovak') {
    _languageCode = 'sk';
  } else if(user.language == 'Slovenian') {
    _languageCode = 'sl';
  } else if(user.language == 'Somali') {
    _languageCode = 'so';
  } else if(user.language == 'Spanish') {
    _languageCode = 'es';
  } else if(user.language == 'Sundanese') {
    _languageCode = 'su';
  } else if(user.language == 'Swahili') {
    _languageCode = 'sw';
  } else if(user.language == 'Swedish') {
    _languageCode = 'sv';
  } else if(user.language == 'Tagalog (Filipino)') {
    _languageCode = 'tl';
  } else if(user.language == 'Tajik') {
    _languageCode = 'tg';
  } else if(user.language == 'Tamil') {
    _languageCode = 'ta';
  } else if(user.language == 'Telugu') {
    _languageCode = 'te';
  } else if(user.language == 'Thai') {
    _languageCode = 'th';
  } else if(user.language == 'Turkish') {
    _languageCode = 'tr';
  } else if(user.language == 'Ukrainian') {
    _languageCode = 'uk';
  } else if(user.language == 'Urdu') {
    _languageCode = 'ur';
  } else if(user.language == 'Uzbek') {
    _languageCode = 'uz';
  } else if(user.language == 'Vietnamese') {
    _languageCode = 'vi';
  } else if(user.language == 'Welsh') {
    _languageCode = 'cy';
  } else if(user.language == 'Xhosa') {
    _languageCode = 'xh';
  } else if(user.language == 'Yiddish') {
    _languageCode = 'yi';
  } else if(user.language == 'Yoruba') {
    _languageCode = 'yo';
  } else{
    _languageCode = 'zu';
  }
  return _languageCode;
}