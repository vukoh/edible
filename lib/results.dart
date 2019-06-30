import 'dart:io';

import 'package:edible/search.dart';
import 'package:edible/ingredient.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';


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

//Rename to something better, better architecture possible?
class ResultsPage extends StatelessWidget {
  List<String> _stringIngredientNamesToCheck;
  List<Ingredient> nonHalalIngredients;
  List<String> missingIngredients;
  List<Ingredient> halalIngredients;
  List<Ingredient> masterList = await fetchIngredient(); //Change to reference masterlist

  ResultsPage(Future<List<String>> _stringIngredientNamesToCheck) {
    this._stringIngredientNamesToCheck = _stringIngredientNamesToCheck;
  }

  List<ListItem> setHalal() {
    //Logic for seperating
    for(String name_to_check in _stringIngredientNamesToCheck) {
      bool foundIngredient = false;
      for(Ingredient curr_ingredient in masterList) {
        if(name_to_check == curr_ingredient.name) {
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
      outputList.add(new MessageItem(curr_nonHalalIngredient.name));
    }
    outputList.add(new HeadingItem('Missing Ingredients'));
    for(String curr_missingIngredient in missingIngredients) {
      outputList.add(new MessageItem(curr_missingIngredient));
    }
    outputList.add(new HeadingItem('Missing Ingredients'));
    for(Ingredient curr_halalIngredient in halalIngredients) {
      outputList.add(new MessageItem(curr_halalIngredient.name));
    }
    return outputList;
  }

  @override
  Widget build(BuildContext context) {
    final title = 'Results';
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
            }
          },
        ),
      ),
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