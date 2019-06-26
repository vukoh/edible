import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Search Ingredient'),
        ),
        body: Center(
          child: Column(children: [
            TextField(
              controller: myController,
            ),
            RaisedButton(
              child: Icon(Icons.search),
              onPressed: () {
                _makeGetRequest();
              },
            ),
          ]),
        ));
  }

  _makeGetRequest() async {
        // only get a single item at index 0
        String ingredientToGet = myController.text;
        String url = '${_hostname()}/ingredients/$ingredientToGet';
        Response response = await get(url);
        int statusCode = response.statusCode;
        String jsonString = response.body;
        print('Status: $statusCode, $jsonString');
      }
}

String _hostname() {
        if (Platform.isAndroid)
          return 'http://10.0.2.2:3000';
        else
          return 'http://localhost:3000';
      }


