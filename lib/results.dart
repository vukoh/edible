import 'package:edible/database.dart' as db;
import 'package:edible/ingredient.dart';
import 'package:edible/loader.dart';
import 'package:flutter/material.dart';
import 'package:edible/information.dart';
import 'package:edible/parse.dart' as parse;


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
      future: parse.readTextfromCamera(),
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        if(snapshot.connectionState == ConnectionState.done){
          final title = 'Results';
          _stringIngredientNamesToCheck = snapshot.data;
          final List<ListItem> items = setHalal();
          return MaterialApp(
            title: title,
            home: Scaffold(
              backgroundColor: Color.fromRGBO(58, 86, 58, 1.0),
              appBar: AppBar(
                title: Text(title),
                backgroundColor: Color.fromRGBO(58, 86, 58, 1.0),
              ),
              body: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];

                  if (item is HeadingItem) {
                    return InkWell(
                      child: Card(
                          elevation: 8.0,
                          color: Color.fromRGBO(64, 96, 64, .9),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 32.0, bottom: 32.0, left: 16.0, right: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(item.heading,
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey.shade200)),
                              ],
                            ),
                          )));

                  } else if (item is MessageItem) {
                      return InkWell(
                        child: Card(
                            elevation: 8.0,
                            color: Color.fromRGBO(64, 96, 64, .9),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 32.0, bottom: 32.0, left: 16.0, right: 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(item.sender,
                                      style: TextStyle(
                                          fontSize: 18,
                                          //fontWeight: FontWeight.bold,
                                          color: Colors.grey.shade200)),
                                ],
                              ),
                            )));

                  } else if (item is IngredientItem) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      InformationPage(item.ingredient)));
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
                                  Text(item.ingredient.name,
                                      style: TextStyle(
                                          fontSize: 18,
                                          //fontWeight: FontWeight.bold,
                                          color: Colors.grey.shade200)),
                                  Text(item.ingredient.description,
                                      style: TextStyle(color: Colors.grey.shade400)),
                                ],
                              ),
                            )));
                  }
                },
              ),
            ),
          );
        } else {
            return new ColorLoader3();
          //return CircularProgressIndicator();
        }
      }
    );
  }
}
//To do: Adjust function to put under maybe halal etc, convert all to lowercase to compare
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