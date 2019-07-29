import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:edible/models/user.dart';
import 'package:edible/utils/network_util.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  String firstName, lastName, email, password, dietaryRestriction, language;

  NetworkUtil _networkUtil = new NetworkUtil();

  void signup() {
    User user = new User(
        email, firstName, lastName, password, dietaryRestriction, language);
    Map<String, String> header = {
      "Content-Type": "application/json"
    };
    print(user.toMap());
    _networkUtil.post('http://cryptic-lake-93970.herokuapp.com/users',
        body: jsonEncode(user.toMap()), headers: header);
    Navigator.pop(context);
  }
  String dropdownvalueDiet = 'Halal';
  String dropdownvalueLanguage = 'English';
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Stack(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(15.0, 60.0, 0.0, 0.0),
                      child: Text(
                        'Signup',
                        style: TextStyle(
                            fontSize: 80.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(260.0, 60.0, 0.0, 0.0),
                      child: Text(
                        '.',
                        style: TextStyle(
                            fontSize: 80.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                  padding: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
                  child: Column(
                    children: <Widget>[
                      TextField(
                        onChanged: (val) => firstName = val,
                        decoration: InputDecoration(
                            labelText: 'FIRST NAME',
                            labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            // hintText: 'EMAIL',
                            // hintStyle: ,
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green))),
                      ),
                      SizedBox(height: 10.0),
                      TextField(
                        onChanged: (val) => lastName = val,
                        decoration: InputDecoration(
                            labelText: 'LAST NAME',
                            labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green))),
                      ),
                      SizedBox(height: 10.0),
                      TextField(
                        onChanged: (val) => email = val,
                        decoration: InputDecoration(
                            labelText: 'EMAIL',
                            labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green))),
                      ),
                      SizedBox(height: 10.0),
                      TextField(
                        onChanged: (val) => password = val,
                        decoration: InputDecoration(
                            labelText: 'PASSWORD ',
                            labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green))),
                        obscureText: true,
                      ),
                      SizedBox(height: 10.0),
                      DropdownButton<String>(
                        value: dropdownvalueDiet,
                        onChanged: (String newValue) {
                          dietaryRestriction = newValue;
                          setState(() {
                            dropdownvalueDiet = newValue;
                          });
                        },
                        items: diets
                          .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          })
                          .toList(),
                      ),
                      /*
                      TextField(
                        onChanged: (val) => dietaryRestriction = val,
                        decoration: InputDecoration(
                            labelText: 'DIETARY RESTRICTION',
                            labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green))),
                      ),
                      */
                      SizedBox(height: 10.0),
                      DropdownButton<String>(
                        value: dropdownvalueLanguage,
                        onChanged: (String newValue) {
                          setState(() {
                            dropdownvalueLanguage = newValue;
                          });
                          language = newValue;
                        },
                        items: languages
                          .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          })
                          .toList(),
                      ),
                      /*
                      TextField(
                        onChanged: (val) => language = val,
                        decoration: InputDecoration(
                            labelText: 'PREFERRED LANGUAGE',
                            labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green))),
                      ),
                      */
                      SizedBox(height: 20),
                      ButtonTheme(
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(20.0)),
                        height: 40,
                        minWidth: 320,
                        child: RaisedButton(
                          onPressed: () {
                            signup();
                          },
                          color: Colors.green,
                          elevation: 7.0,
                          child: Text(
                            'SIGNUP',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat'),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        height: 40.0,
                        color: Colors.transparent,
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.black,
                                  style: BorderStyle.solid,
                                  width: 1.0),
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(20.0)),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Center(
                              child: Text('Go Back',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat')),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
              // SizedBox(height: 15.0),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: <Widget>[
              //     Text(
              //       'New to Spotify?',
              //       style: TextStyle(
              //         fontFamily: 'Montserrat',
              //       ),
              //     ),
              //     SizedBox(width: 5.0),
              //     InkWell(
              //       child: Text('Register',
              //           style: TextStyle(
              //               color: Colors.green,
              //               fontFamily: 'Montserrat',
              //               fontWeight: FontWeight.bold,
              //               decoration: TextDecoration.underline)),
              //     )
              //   ],
              // )
            ]));
  }
}
var languages = ['Afrikaans',
'Albanian',
'Amharic',
'Arabic',
'Armenian',
'Azerbaijani',
'Basque',
'Belarusian',
'Bengali',
'Bosnian',
'Bulgarian',
'Catalan',
'Cebuano',
'Chinese (Simplified)',
'Chinese (Traditional)',
'Corsican',
'Croatian',
'Czech',
'Danish',
'Dutch',
'English',
'Esperanto',
'Estonian',
'Finnish',
'French',
'Frisian',
'Galician',
'Georgian',
'German',
'Greek',
'Gujarati',
'Haitian Creole',
'Hausa',
'Hawaiian',
'Hebrew',
'Hindi',
'Hmong',
'Hungarian',
'Icelandic',
'Igbo',
'Indonesian',
'Irish',
'Italian',
'Japanese',
'Javanese',
'Kannada',
'Kazakh',
'Khmer',
'Korean',
'Kurdish',
'Kyrgyz',
'Lao',
'Latin',
'Latvian',
'Lithuanian',
'Luxembourgish',
'Macedonian',
'Malagasy',
'Malay',
'Malayalam',
'Maltese',
'Maori',
'Marathi',
'Mongolian',
'Myanmar (Burmese)',
'Nepali',
'Norwegian',
'Nyanja (Chichewa)',
'Pashto',
'Persian',
'Polish',
'Portuguese (Portugal, Brazil)',
'Punjabi',
'Romanian',
'Russian',
'Samoan',
'Scots Gaelic',
'Serbian',
'Sesotho',
'Shona',
'Sindhi',
'Sinhala (Sinhalese)',
'Slovak',
'Slovenian',
'Somali',
'Spanish',
'Sundanese',
'Swahili',
'Swedish',
'Tagalog (Filipino)',
'Tajik',
'Tamil',
'Telugu',
'Thai',
'Turkish',
'Ukrainian',
'Urdu',
'Uzbek',
'Vietnamese',
'Welsh',
'Xhosa',
'Yiddish',
'Yoruba',
'Zulu'];
var diets = ['Halal',
'Vegetarian',
'Vegetarian (No milk)',
'Vegetarian (No egg)',
'Vegetarian (No milk & No egg)',
'Vegan',
'LactoOvoPescatarian',
'Kosher'];