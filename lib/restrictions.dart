library edible_restrictions;

import 'package:edible/database.dart' as db;
import 'package:edible/ingredient.dart';
import 'package:edible/models/user.dart';

//Todo add functionality for "maybe" ie maybe halal etc.

class IntermediaryList {
  List<IngredientItem> suitableIngredients;
  List<IngredientItem> unsuitableIngredients;
  List<String> missingIngredients;
  String restriction;
  IntermediaryList(this.suitableIngredients, this.unsuitableIngredients, this.missingIngredients, this.restriction);

  List<ListItem> combineList() {
    List<ListItem> outputList = new List<ListItem>();

    outputList.add(new HeadingItem('Non-' + this.restriction + ' Ingredients'));
    for(IngredientItem curr in this.unsuitableIngredients) {
      outputList.add(curr);
    }
    if(unsuitableIngredients.isEmpty) {
      outputList.add(new MessageItem('No non-' + this.restriction + ' ingredients found!'));
    }

    outputList.add(new HeadingItem('Missing Ingredients'));
    for(String curr in this.missingIngredients) {
      outputList.add(new MessageItem(curr));
    }
    if(missingIngredients.isEmpty) {
      outputList.add(new MessageItem('No missing ingredients - all ingredients found!'));
    }

    outputList.add(new HeadingItem(this.restriction +' Ingredients'));
    for(IngredientItem curr in this.suitableIngredients) {
      outputList.add(curr);
    }
    if(this.suitableIngredients.isEmpty) {
      outputList.add(new MessageItem('No ' + this.restriction + ' ingredients found!'));
    }

    return outputList;
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
class IngredientItem implements ListItem {
  final Ingredient ingredient;
  final String translated;
  IngredientItem(this.ingredient, this.translated);
}

List<ListItem> setHalal(List<String> _stringIngredientNamesToCheckTranslated, List<String> cleaned_english_ingredients) {
  List<IngredientItem> nonHalalIngredients = new List<IngredientItem>();
  List<String> missingIngredients = new List<String>();
  List<IngredientItem> halalIngredients = new List<IngredientItem>();
  String restriction = 'Halal';
  int length = cleaned_english_ingredients.length;
  //Logic for seperating
  for(int i = 0; i < length; i++) {
    bool foundIngredient = false;
    for(Ingredient curr_ingredient in db.ingredients) {
      if(curr_ingredient.name.contains(cleaned_english_ingredients[i])) {
        foundIngredient = true;
        if(curr_ingredient.isHalal()) {
          halalIngredients.add(new IngredientItem(curr_ingredient, _stringIngredientNamesToCheckTranslated[i]));
          break;
        } else {
          nonHalalIngredients.add(new IngredientItem(curr_ingredient, _stringIngredientNamesToCheckTranslated[i]));
          break;
        }
      }
    }
    if(foundIngredient == false) {
      missingIngredients.add(_stringIngredientNamesToCheckTranslated[i]);
    }
  }
  IntermediaryList intermediaryList = new IntermediaryList(halalIngredients, nonHalalIngredients, missingIngredients, restriction);
  List<ListItem> outputList = intermediaryList.combineList();
  return outputList;
}

List<ListItem> setVegetarian(List<String> _stringIngredientNamesToCheckTranslated, List<String> cleaned_english_ingredients) {
  List<IngredientItem> nonVegetarianIngredients = new List<IngredientItem>();
  List<String> missingIngredients = new List<String>();
  List<IngredientItem> vegetarianIngredients = new List<IngredientItem>();
  String restriction = 'Vegetarian';
  int length = cleaned_english_ingredients.length;
  //Logic for seperating
  print(_stringIngredientNamesToCheckTranslated.length == cleaned_english_ingredients.length);
  for(int i = 0; i < length; i++) {
    bool foundIngredient = false;
    for(Ingredient curr_ingredient in db.ingredients) {
      print('Reached here 3');
      print('Curr ingredient: ' + curr_ingredient.name);
      print(cleaned_english_ingredients[i]);
      print(_stringIngredientNamesToCheckTranslated);
      if(curr_ingredient.name.contains(cleaned_english_ingredients[i])) {
        print('Reached here 4');
        foundIngredient = true;
        if(curr_ingredient.isVegetarian()) {
          print('Reached here 5');
          vegetarianIngredients.add(new IngredientItem(curr_ingredient, _stringIngredientNamesToCheckTranslated[i]));
          break;
        } else {
          print('Reached here 6');
          nonVegetarianIngredients.add(new IngredientItem(curr_ingredient, _stringIngredientNamesToCheckTranslated[i]));
          break;
        }
      }
    }
    if(foundIngredient == false) {
      print('Reached here 7');
      missingIngredients.add(_stringIngredientNamesToCheckTranslated[i]);
    }
  }
  print('Reached here 8');
  IntermediaryList intermediaryList = new IntermediaryList(vegetarianIngredients, nonVegetarianIngredients, missingIngredients, restriction);
  List<ListItem> outputList = intermediaryList.combineList();
  print('Reached here 9');
  return outputList;
}

List<ListItem> setVegetarianNoMilk(List<String> _stringIngredientNamesToCheckTranslated, List<String> cleaned_english_ingredients) {
  List<IngredientItem> nonVegetarianIngredients = new List<IngredientItem>();
  List<String> missingIngredients = new List<String>();
  List<IngredientItem> vegetarianIngredients = new List<IngredientItem>();
  String restriction = 'Vegetarian (No Milk)';
  int length = cleaned_english_ingredients.length;
  //Logic for seperating
  for(int i = 0; i < length; i++) {
    bool foundIngredient = false;
    for(Ingredient curr_ingredient in db.ingredients) {
      if(curr_ingredient.name.contains(cleaned_english_ingredients[i])) {
        foundIngredient = true;
        if(curr_ingredient.isVegetarianNoMilk()) {
          vegetarianIngredients.add(new IngredientItem(curr_ingredient, _stringIngredientNamesToCheckTranslated[i]));
          break;
        } else {
          nonVegetarianIngredients.add(new IngredientItem(curr_ingredient, _stringIngredientNamesToCheckTranslated[i]));
          break;
        }
      }
    }
    if(foundIngredient == false) {
      missingIngredients.add(_stringIngredientNamesToCheckTranslated[i]);
    }
  }
  IntermediaryList intermediaryList = new IntermediaryList(vegetarianIngredients, nonVegetarianIngredients, missingIngredients, restriction);
  List<ListItem> outputList = intermediaryList.combineList();
  return outputList;
}

List<ListItem> setVegetarianNoEgg(List<String> _stringIngredientNamesToCheckTranslated, List<String> cleaned_english_ingredients) {
  List<IngredientItem> nonVegetarianIngredients = new List<IngredientItem>();
  List<String> missingIngredients = new List<String>();
  List<IngredientItem> vegetarianIngredients = new List<IngredientItem>();
  String restriction = 'Vegetarian (No Egg)';
  int length = cleaned_english_ingredients.length;
  //Logic for seperating
  for(int i = 0; i < length; i++) {
    bool foundIngredient = false;
    for(Ingredient curr_ingredient in db.ingredients) {
      if(curr_ingredient.name.contains(cleaned_english_ingredients[i])) {
        foundIngredient = true;
        if(curr_ingredient.isVegetarianNoEgg()) {
          vegetarianIngredients.add(new IngredientItem(curr_ingredient, _stringIngredientNamesToCheckTranslated[i]));
          break;
        } else {
          nonVegetarianIngredients.add(new IngredientItem(curr_ingredient, _stringIngredientNamesToCheckTranslated[i]));
          break;
        }
      }
    }
    if(foundIngredient == false) {
      missingIngredients.add(_stringIngredientNamesToCheckTranslated[i]);
    }
  }
  IntermediaryList intermediaryList = new IntermediaryList(vegetarianIngredients, nonVegetarianIngredients, missingIngredients, restriction);
  List<ListItem> outputList = intermediaryList.combineList();
  return outputList;
}

List<ListItem> setVegetarianNoMilkNoEgg(List<String> _stringIngredientNamesToCheckTranslated, List<String> cleaned_english_ingredients) {
  List<IngredientItem> nonVegetarianIngredients = new List<IngredientItem>();
  List<String> missingIngredients = new List<String>();
  List<IngredientItem> vegetarianIngredients = new List<IngredientItem>();
  String restriction = 'Vegetarian (No Milk & No Egg)';
  int length = cleaned_english_ingredients.length;
  //Logic for seperating
  for(int i = 0; i < length; i++) {
    bool foundIngredient = false;
    for(Ingredient curr_ingredient in db.ingredients) {
      if(curr_ingredient.name.contains(cleaned_english_ingredients[i])) {
        foundIngredient = true;
        if(curr_ingredient.isVegetarianNoMilkNoEgg()) {
          vegetarianIngredients.add(new IngredientItem(curr_ingredient, _stringIngredientNamesToCheckTranslated[i]));
          break;
        } else {
          nonVegetarianIngredients.add(new IngredientItem(curr_ingredient, _stringIngredientNamesToCheckTranslated[i]));
          break;
        }
      }
    }
    if(foundIngredient == false) {
      missingIngredients.add(_stringIngredientNamesToCheckTranslated[i]);
    }
  }
  IntermediaryList intermediaryList = new IntermediaryList(vegetarianIngredients, nonVegetarianIngredients, missingIngredients, restriction);
  List<ListItem> outputList = intermediaryList.combineList();
  return outputList;
}

List<ListItem> setVegan(List<String> _stringIngredientNamesToCheckTranslated, List<String> cleaned_english_ingredients) {
  List<IngredientItem> nonVeganIngredients = new List<IngredientItem>();
  List<String> missingIngredients = new List<String>();
  List<IngredientItem> veganIngredients = new List<IngredientItem>();
  String restriction = 'Vegan';
  int length = cleaned_english_ingredients.length;
  //Logic for seperating
  for(int i = 0; i < length; i++) {
    bool foundIngredient = false;
    for(Ingredient curr_ingredient in db.ingredients) {
      if(curr_ingredient.name.contains(cleaned_english_ingredients[i])) {
        foundIngredient = true;
        if(curr_ingredient.isVegan()) {
          veganIngredients.add(new IngredientItem(curr_ingredient, _stringIngredientNamesToCheckTranslated[i]));
          break;
        } else {
          nonVeganIngredients.add(new IngredientItem(curr_ingredient, _stringIngredientNamesToCheckTranslated[i]));
          break;
        }
      }
    }
    if(foundIngredient == false) {
      missingIngredients.add(_stringIngredientNamesToCheckTranslated[i]);
    }
  }
  IntermediaryList intermediaryList = new IntermediaryList(veganIngredients, nonVeganIngredients, missingIngredients, restriction);
  List<ListItem> outputList = intermediaryList.combineList();
  return outputList;
}

List<ListItem> setLactoOvoPescatarian(List<String> _stringIngredientNamesToCheckTranslated, List<String> cleaned_english_ingredients) {
  List<IngredientItem> nonLactoOvoPescatarianIngredients = new List<IngredientItem>();
  List<String> missingIngredients = new List<String>();
  List<IngredientItem> lactoOvoPescatarianIngredients = new List<IngredientItem>();
  String restriction = 'LactoOvoPescatarian';
  int length = cleaned_english_ingredients.length;
  //Logic for seperating
  for(int i = 0; i < length; i++) {
    bool foundIngredient = false;
    for(Ingredient curr_ingredient in db.ingredients) {
      if(curr_ingredient.name.contains(cleaned_english_ingredients[i])) {
        foundIngredient = true;
        if(curr_ingredient.isLactoOvoPescatarian()) {
          lactoOvoPescatarianIngredients.add(new IngredientItem(curr_ingredient, _stringIngredientNamesToCheckTranslated[i]));
          break;
        } else {
          nonLactoOvoPescatarianIngredients.add(new IngredientItem(curr_ingredient, _stringIngredientNamesToCheckTranslated[i]));
          break;
        }
      }
    }
    if(foundIngredient == false) {
      missingIngredients.add(_stringIngredientNamesToCheckTranslated[i]);
    }
  }
  IntermediaryList intermediaryList = new IntermediaryList(lactoOvoPescatarianIngredients, nonLactoOvoPescatarianIngredients, missingIngredients, restriction);
  List<ListItem> outputList = intermediaryList.combineList();
  return outputList;
}

List<ListItem> setKosher(List<String> _stringIngredientNamesToCheckTranslated, List<String> cleaned_english_ingredients) {
  List<IngredientItem> nonKosherIngredients = new List<IngredientItem>();
  List<String> missingIngredients = new List<String>();
  List<IngredientItem> kosherIngredients = new List<IngredientItem>();
  String restriction = 'Kosher';
  int length = cleaned_english_ingredients.length;
  //Logic for seperating
  for(int i = 0; i < length; i++) {
    bool foundIngredient = false;
    for(Ingredient curr_ingredient in db.ingredients) {
      if(curr_ingredient.name.contains(cleaned_english_ingredients[i])) {
        foundIngredient = true;
        if(curr_ingredient.isKosher()) {
          kosherIngredients.add(new IngredientItem(curr_ingredient, _stringIngredientNamesToCheckTranslated[i]));
          break;
        } else {
          nonKosherIngredients.add(new IngredientItem(curr_ingredient, _stringIngredientNamesToCheckTranslated[i]));
          break;
        }
      }
    }
    if(foundIngredient == false) {
      missingIngredients.add(_stringIngredientNamesToCheckTranslated[i]);
    }
  }
  IntermediaryList intermediaryList = new IntermediaryList(kosherIngredients, nonKosherIngredients, missingIngredients, restriction);
  List<ListItem> outputList = intermediaryList.combineList();
  return outputList;
}

List<ListItem> checkandSet(List<String> _stringIngredientNamesToCheckTranslated, List<String> cleaned_english_ingredients, User user) {
  if(user.dietaryRestriction == 'Halal') {
    return setHalal(_stringIngredientNamesToCheckTranslated, cleaned_english_ingredients);
  } else if(user.dietaryRestriction == 'Vegetarian') {
    return setVegetarian(_stringIngredientNamesToCheckTranslated, cleaned_english_ingredients);
  } else if(user.dietaryRestriction == 'Vegetarian (No milk)') {
    return setVegetarianNoMilk(_stringIngredientNamesToCheckTranslated, cleaned_english_ingredients);
  } else if(user.dietaryRestriction == 'Vegetarian (No egg)') {
    return setVegetarianNoEgg(_stringIngredientNamesToCheckTranslated, cleaned_english_ingredients);
  } else if(user.dietaryRestriction == 'Vegetarian (No milk & No egg)') {
    return setVegetarianNoMilkNoEgg(_stringIngredientNamesToCheckTranslated, cleaned_english_ingredients);
  } else if(user.dietaryRestriction == 'Vegan') {
    return setVegan(_stringIngredientNamesToCheckTranslated, cleaned_english_ingredients);
  } else if(user.dietaryRestriction == 'LactoOvoPescatarian') {
    return setLactoOvoPescatarian(_stringIngredientNamesToCheckTranslated, cleaned_english_ingredients);
  } else {
    return setKosher(_stringIngredientNamesToCheckTranslated, cleaned_english_ingredients);
  }
}
//Todo: Change every function to accept map<string, string>