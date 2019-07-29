import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:edible/models/user.dart';
import 'package:edible/utils/network_util.dart';
import 'package:edible/data/database_helper.dart';

class ChangeDetailScreen extends StatefulWidget {
  ChangeDetailScreen(this.user);

  final User user;

  @override
  _ChangeDetailScreenState createState() => _ChangeDetailScreenState(user);
}

class _ChangeDetailScreenState extends State<ChangeDetailScreen> {
  _ChangeDetailScreenState(this.user);

  User user;
  DatabaseHelper db = new DatabaseHelper();
  NetworkUtil _netUtil = new NetworkUtil();

  void changeDetails() {
    if (!isChanged) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("No change has been made!"),
                content: Text('Please try again'),
                actions: [
                  FlatButton(
                      child: Text('Ok'),
                      onPressed: () => Navigator.pop(context))
                ],
              ));
      return;
    }
    String password;
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Please enter your password to confirm the change'),
              content: TextField(
                onChanged: (val) => password = val,
              ),
              actions: [
                FlatButton(
                    child: Text('Enter'),
                    onPressed: () {
                      makeChange(user, password);
                      Navigator.pop(context);
                    })
              ],
            ));
    // User user = new User(
    //     email, firstName, lastName, password, dietaryRestriction, language);
    // Map<String, String> header = {
    //   "Content-Type": "application/json"
    // };
    // print(user.toMap());
    // _networkUtil.post('http://cryptic-lake-93970.herokuapp.com/users',
    //     body: jsonEncode(user.toMap()), headers: header);
    // Navigator.pop(context);
  }

  void makeChange(User user, String password) async {
    Map<String, String> header = {"Content-Type": "application/json"};
    var jwt = await _netUtil.post(
        'http://cryptic-lake-93970.herokuapp.com/auth',
        headers: header,
        body: jsonEncode({'email': user.username, 'password': password}));
    String token = jwt["accessToken"];
    String id = jwt["id"];
    if (token == null) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Wrong Password"),
                content: Text('Please try again'),
                actions: [
                  FlatButton(
                      child: Text('Ok'),
                      onPressed: () {
                        print(user.id);
                        Navigator.pop(context);
                      })
                ],
              ));
      return;
    }
    var LOGIN_URL = 'http://cryptic-lake-93970.herokuapp.com/users/' + id;
    print('here');
    // var queryParameters = {
    //   "param1": "one",
    //   "param2": "two",
    // };
    Map<String, String> getHeaders = {
      "Content-Type": "application/json",
      "Authorization": "Bearer " + token
    };
    _netUtil.patch(LOGIN_URL,
        headers: getHeaders, body: jsonEncode(user.toMap()));
    if (token != null) {
      db.deleteUsers();
      db.saveUser(user);
    }
    Navigator.pop(context);
  }

  final TextEditingController _firstNameController =
      new TextEditingController();
  final TextEditingController _lastNameController = new TextEditingController();
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  final TextEditingController _dietaryRestrictionController =
      new TextEditingController();
  final TextEditingController _languageController = new TextEditingController();
  bool isChanged;

  @override
  void initState() {
    _firstNameController.text = user.firstName;
    _lastNameController.text = user.lastName;
    _emailController.text = user.username;
    _passwordController.text = user.password;
    _dietaryRestrictionController.text = user.dietaryRestriction;
    _languageController.text = user.language;
    isChanged = false;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    String dropdownvalueDiet = user.dietaryRestriction;
    String dropdownvalueLanguage = user.language;
    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Stack(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(15.0, 40.0, 0.0, 0.0),
                      child: Text(
                        'Change',
                        style: TextStyle(
                            fontSize: 72.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(257.0, 38.0, 0.0, 0.0),
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
                        onChanged: (val) {
                          isChanged = true;
                          user.setFirstName(val);
                        },
                        controller: _firstNameController,
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
                        onChanged: (val) {
                          isChanged = true;
                          user.setLastName(val);
                        },
                        controller: _lastNameController,
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
                      TextFormField(
                        onSaved: (val) {
                          isChanged = true;
                          user.setUsername(val);
                        },
                        controller: _emailController,
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
                        onChanged: (val) {
                          isChanged = true;
                          user.setPassword(val);
                        },
                        decoration: InputDecoration(
                            labelText: 'PASSWORD',
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
                          isChanged = true;
                          user.setDiet(newValue);
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
                      SizedBox(height: 10.0),
                      /*
                      TextField(
                        onChanged: (val) {
                          isChanged = true;
                          user.setDiet(val);
                        },
                        controller: _dietaryRestrictionController,
                        decoration: InputDecoration(
                            labelText: 'DIETARY RESTRICTION',
                            labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green))),
                      ),
                      SizedBox(height: 10.0),
                      */
                      DropdownButton<String>(
                        value: dropdownvalueLanguage,
                        onChanged: (String newValue) {
                          isChanged = true;
                          user.setLanguage(newValue);
                          setState(() {
                            dropdownvalueLanguage = newValue;
                          });
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
                        onChanged: (val) {
                          isChanged = true;
                          user.setLanguage(val);
                        },
                        controller: _languageController,
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
                            changeDetails();
                          },
                          color: Colors.green,
                          elevation: 7.0,
                          child: Text(
                            'CHANGE',
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
                              child: Text('Cancel',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat')),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
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