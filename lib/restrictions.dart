library edible_restrictions;

import 'package:edible/database.dart' as db;
import 'package:edible/ingredient.dart';

//Todo add functionality for "maybe" ie maybe halal etc.

class IntermediaryList {
  List<Ingredient> suitableIngredients;
  List<Ingredient> unsuitableIngredients;
  List<String> missingIngredients;
  String restriction;
  IntermediaryList(this.suitableIngredients, this.unsuitableIngredients, this.missingIngredients, this.restriction);

  List<ListItem> combineList() {
    List<ListItem> outputList = new List<ListItem>();

    outputList.add(new HeadingItem('Non-' + this.restriction + ' Ingredients'));
    for(Ingredient curr in this.unsuitableIngredients) {
      outputList.add(new IngredientItem(curr));
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
    for(Ingredient curr in this.suitableIngredients) {
      outputList.add(new IngredientItem(curr));
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
  IngredientItem(this.ingredient);
}

List<ListItem> setHalal(List<String> _stringIngredientNamesToCheck) {
    List<Ingredient> nonHalalIngredients = new List<Ingredient>();
    List<String> missingIngredients = new List<String>();
    List<Ingredient> halalIngredients = new List<Ingredient>();
    String restriction = 'Halal';
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
    IntermediaryList intermediaryList = new IntermediaryList(halalIngredients, nonHalalIngredients, missingIngredients, restriction);
    List<ListItem> outputList = intermediaryList.combineList();
    return outputList;
  }

List<ListItem> setVegetarian(List<String> _stringIngredientNamesToCheck) {
    List<Ingredient> nonVegetarianIngredients = new List<Ingredient>();
    List<String> missingIngredients = new List<String>();
    List<Ingredient> vegetarianIngredients = new List<Ingredient>();
    String restriction = 'Vegetarian';
    //Logic for seperating
    for(String name_to_check in _stringIngredientNamesToCheck) {
      bool foundIngredient = false;
      for(Ingredient curr_ingredient in db.ingredients) {
        if(curr_ingredient.name.contains(name_to_check)) {
          foundIngredient = true;
          if(curr_ingredient.isHalal()) {
            vegetarianIngredients.add(curr_ingredient);
            break;
          } else {
            nonVegetarianIngredients.add(curr_ingredient);
            break;
          }
        }
      }
      if(foundIngredient == false) {
        missingIngredients.add(name_to_check);
      }
    }
    IntermediaryList intermediaryList = new IntermediaryList(vegetarianIngredients, nonVegetarianIngredients, missingIngredients, restriction);
    List<ListItem> outputList = intermediaryList.combineList();
    return outputList;
  }

List<ListItem> setVegetarianNoMilk(List<String> _stringIngredientNamesToCheck) {
    List<Ingredient> nonVegetarianIngredients = new List<Ingredient>();
    List<String> missingIngredients = new List<String>();
    List<Ingredient> vegetarianIngredients = new List<Ingredient>();
    String restriction = 'Vegetarian (No Milk)';
    //Logic for seperating
    for(String name_to_check in _stringIngredientNamesToCheck) {
      bool foundIngredient = false;
      for(Ingredient curr_ingredient in db.ingredients) {
        if(curr_ingredient.name.contains(name_to_check)) {
          foundIngredient = true;
          if(curr_ingredient.isHalal()) {
            vegetarianIngredients.add(curr_ingredient);
            break;
          } else {
            nonVegetarianIngredients.add(curr_ingredient);
            break;
          }
        }
      }
      if(foundIngredient == false) {
        missingIngredients.add(name_to_check);
      }
    }
    IntermediaryList intermediaryList = new IntermediaryList(vegetarianIngredients, nonVegetarianIngredients, missingIngredients, restriction);
    List<ListItem> outputList = intermediaryList.combineList();
    return outputList;
  }

List<ListItem> setVegetarianNoEgg(List<String> _stringIngredientNamesToCheck) {
    List<Ingredient> nonVegetarianIngredients = new List<Ingredient>();
    List<String> missingIngredients = new List<String>();
    List<Ingredient> vegetarianIngredients = new List<Ingredient>();
    String restriction = 'Vegetarian (No egg)';
    //Logic for seperating
    for(String name_to_check in _stringIngredientNamesToCheck) {
      bool foundIngredient = false;
      for(Ingredient curr_ingredient in db.ingredients) {
        if(curr_ingredient.name.contains(name_to_check)) {
          foundIngredient = true;
          if(curr_ingredient.isHalal()) {
            vegetarianIngredients.add(curr_ingredient);
            break;
          } else {
            nonVegetarianIngredients.add(curr_ingredient);
            break;
          }
        }
      }
      if(foundIngredient == false) {
        missingIngredients.add(name_to_check);
      }
    }
    IntermediaryList intermediaryList = new IntermediaryList(vegetarianIngredients, nonVegetarianIngredients, missingIngredients, restriction);
    List<ListItem> outputList = intermediaryList.combineList();
    return outputList;
  }

List<ListItem> setVegetarianNoMilkNoEgg(List<String> _stringIngredientNamesToCheck) {
    List<Ingredient> nonVegetarianIngredients = new List<Ingredient>();
    List<String> missingIngredients = new List<String>();
    List<Ingredient> vegetarianIngredients = new List<Ingredient>();
    String restriction = 'Vegetarian (No milk & egg)';
    //Logic for seperating
    for(String name_to_check in _stringIngredientNamesToCheck) {
      bool foundIngredient = false;
      for(Ingredient curr_ingredient in db.ingredients) {
        if(curr_ingredient.name.contains(name_to_check)) {
          foundIngredient = true;
          if(curr_ingredient.isHalal()) {
            vegetarianIngredients.add(curr_ingredient);
            break;
          } else {
            nonVegetarianIngredients.add(curr_ingredient);
            break;
          }
        }
      }
      if(foundIngredient == false) {
        missingIngredients.add(name_to_check);
      }
    }
    IntermediaryList intermediaryList = new IntermediaryList(vegetarianIngredients, nonVegetarianIngredients, missingIngredients, restriction);
    List<ListItem> outputList = intermediaryList.combineList();
    return outputList;
  }

List<ListItem> setVegan(List<String> _stringIngredientNamesToCheck) {
    List<Ingredient> nonVeganIngredients = new List<Ingredient>();
    List<String> missingIngredients = new List<String>();
    List<Ingredient> veganIngredients = new List<Ingredient>();
    String restriction = 'Vegan';
    //Logic for seperating
    for(String name_to_check in _stringIngredientNamesToCheck) {
      bool foundIngredient = false;
      for(Ingredient curr_ingredient in db.ingredients) {
        if(curr_ingredient.name.contains(name_to_check)) {
          foundIngredient = true;
          if(curr_ingredient.isHalal()) {
            veganIngredients.add(curr_ingredient);
            break;
          } else {
            nonVeganIngredients.add(curr_ingredient);
            break;
          }
        }
      }
      if(foundIngredient == false) {
        missingIngredients.add(name_to_check);
      }
    }
    IntermediaryList intermediaryList = new IntermediaryList(veganIngredients, nonVeganIngredients, missingIngredients, restriction);
    List<ListItem> outputList = intermediaryList.combineList();
    return outputList;
  }

List<ListItem> setLactoOvoPescatarian(List<String> _stringIngredientNamesToCheck) {
    List<Ingredient> nonLOPIngredients = new List<Ingredient>();
    List<String> missingIngredients = new List<String>();
    List<Ingredient> LOPIngredients = new List<Ingredient>();
    String restriction = 'Lacto-Ovo-Pescatarian';
    //Logic for seperating
    for(String name_to_check in _stringIngredientNamesToCheck) {
      bool foundIngredient = false;
      for(Ingredient curr_ingredient in db.ingredients) {
        if(curr_ingredient.name.contains(name_to_check)) {
          foundIngredient = true;
          if(curr_ingredient.isHalal()) {
            LOPIngredients.add(curr_ingredient);
            break;
          } else {
            nonLOPIngredients.add(curr_ingredient);
            break;
          }
        }
      }
      if(foundIngredient == false) {
        missingIngredients.add(name_to_check);
      }
    }
    IntermediaryList intermediaryList = new IntermediaryList(LOPIngredients, nonLOPIngredients, missingIngredients, restriction);
    List<ListItem> outputList = intermediaryList.combineList();
    return outputList;
  }

List<ListItem> setKosher(List<String> _stringIngredientNamesToCheck) {
    List<Ingredient> nonKosherIngredients = new List<Ingredient>();
    List<String> missingIngredients = new List<String>();
    List<Ingredient> kosherIngredients = new List<Ingredient>();
    String restriction = 'Kosher';
    //Logic for seperating
    for(String name_to_check in _stringIngredientNamesToCheck) {
      bool foundIngredient = false;
      for(Ingredient curr_ingredient in db.ingredients) {
        if(curr_ingredient.name.contains(name_to_check)) {
          foundIngredient = true;
          if(curr_ingredient.isHalal()) {
            kosherIngredients.add(curr_ingredient);
            break;
          } else {
            nonKosherIngredients.add(curr_ingredient);
            break;
          }
        }
      }
      if(foundIngredient == false) {
        missingIngredients.add(name_to_check);
      }
    }
    IntermediaryList intermediaryList = new IntermediaryList(kosherIngredients, nonKosherIngredients, missingIngredients, restriction);
    List<ListItem> outputList = intermediaryList.combineList();
    return outputList;
  }