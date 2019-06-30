
import 'package:edible/ingredient.dart';
import 'package:flutter/material.dart';
import 'package:edible/information.dart';
import 'package:edible/database.dart' as db; 

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // final myController = TextEditingController();

  // @override
  // void dispose() {
  //   // Clean up the controller when the widget is disposed.
  //   myController.dispose();
  //   super.dispose();
  // }

  List<Ingredient> _ingredientsForDisplay = db.ingredients;

  @override
  void initState() {
      setState(() {
        _ingredientsForDisplay = db.ingredients;
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(58, 86, 58, 1.0),
        appBar: AppBar(
          title: Text('Search Ingredient'),
          backgroundColor: Color.fromRGBO(58, 86, 58, 1.0),
        ),
        body: ListView.builder(
          itemBuilder: (context, index) {
            return index == 0 ? _searchBar() : _listItem(index - 1);
          },
          itemCount: _ingredientsForDisplay.length + 1,
        ));
  }

  _searchBar() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
            decoration: InputDecoration(
                hintText: 'Search...',
                hintStyle: TextStyle(color: Colors.white)),
            onChanged: (text) {
              text = text.toLowerCase();
              setState(() {
                _ingredientsForDisplay = db.ingredients.where((ingredient) {
                  var ingredientName = ingredient.name.toLowerCase();
                  return ingredientName.contains(text);
                }).toList();
              });
            }));
  }

  _listItem(index) {
    return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      InformationPage(_ingredientsForDisplay[index])));
        },
        child: Card(
            elevation: 8.0,
            color: Color.fromRGBO(64, 96, 64, .9),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 32.0, bottom: 32.0, left: 16.0, right: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(_ingredientsForDisplay[index].name,
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade200)),
                  Text(_ingredientsForDisplay[index].description,
                      style: TextStyle(color: Colors.grey.shade400)),
                ],
              ),
            )));
  }
}
//   _makeGetRequest() async {
//     // only get a single item at index 0
//     String ingredientToGet = myController.text;
//     String url = '${_hostname()}/ingredients/$ingredientToGet';
//     Response response = await get(url);
//     int statusCode = response.statusCode;
//     String jsonString = response.body;
//     print('Status: $statusCode, $jsonString');
//   }
// }

// String _hostname() {
//   return 'https://cryptic-lake-93970.herokuapp.com';
// }
