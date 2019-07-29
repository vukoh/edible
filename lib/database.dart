library edible_database;

import 'package:edible/ingredient.dart';
// import 'package:http/http.dart';
// import 'dart:convert';


  // Future<List<Ingredient>> fetchIngredient() async {
  //   var url = 'https://cryptic-lake-93970.herokuapp.com/ingredients';
  //   var response = await get(url);

  //   var ingredients = List<Ingredient>();

  //   if (response.statusCode == 200) {
  //     var ingredientsJson = json.decode(response.body);
  //     for (var ingredientJson in ingredientsJson) {
  //       ingredients.add(Ingredient.fromJson(ingredientJson));
  //     }
  //   }

  //   return ingredients;
  // }

  List<Ingredient> ingredients = List<Ingredient>();
