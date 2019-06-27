import 'dart:io';
import 'package:edible/ingredient.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';


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

  List<Ingredient> _ingredients = List<Ingredient>();

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

  @override
  void initState(){
    fetchIngredient().then((value) {
      setState(() {
        _ingredients.addAll(value);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text('Search Ingredient'),
        ),
        body: ListView.builder(
          itemBuilder: (context, index) {
            return Card(
                child: Padding(
              padding: const EdgeInsets.only(
                  top: 32.0, bottom: 32.0, left: 16.0, right: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(_ingredients[index].name,
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  Text(_ingredients[index].description,
                      style: TextStyle(color: Colors.grey.shade600)),
                ],
              ),
            ));
          },
          itemCount: _ingredients.length,
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
  return 'https://cryptic-lake-93970.herokuapp.com';
}
