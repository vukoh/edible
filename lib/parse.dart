library edible_parse;

List<String> clean(String translated_ingredients) {

  List<List<String>> ingredientsListToCheck = new List<List<String>>();

  ingredientsListToCheck.add(splitByComma(translated_ingredients));
  List<String> finalList = new List<String>();
  for (List<String> blockList in ingredientsListToCheck) {
    for (String ingredient in blockList) {
        finalList.add(ingredient);
    }
  }
  return removeSpacesAndNewLines(cleanBrackets(removeFullStop(removeWordIngredient(finalList))));
}
//Todo: Fix function so using back in camera doesn't crash app, add option to pick from library

List<String> splitByComma(String rawtext) {
  //print('Rawtext: ' + rawtext);
  List<String> returnedList = rawtext.split(",");
  //print('Split by comma: ');
  //print(returnedList);
  return returnedList;
}

List<String> removeWordIngredient(List<String> ingredients) {
  String firstIngredientLC = ingredients.first;
  //print('Removing word ingredients: ' + firstIngredientLC);
  if(firstIngredientLC.contains('Ingredients')) {
    String newFirstIngredient = firstIngredientLC.replaceFirst('Ingredients', '');
    ingredients[0] = newFirstIngredient;
    //print('Case 1: ' + newFirstIngredient);
    return ingredients;
  } else if (firstIngredientLC.contains('Ingredient')) {
      String newFirstIngredient = firstIngredientLC.replaceFirst('Ingredient', '');
      ingredients[0] = newFirstIngredient;
      //print('Case 2: ' + newFirstIngredient);
      return ingredients;
  } else {
    //print('Case 3: nothing found');
    return ingredients;
  }
}

List<String> removeFullStop(List<String> ingredients) {
  //print('Removing full stop: ');
  if(ingredients.last.endsWith('.')) {
    //print('Full stop found: ');
    String newLastIngredient = ingredients.last.replaceAll('.', '');
    ingredients.removeLast();
    ingredients.add(newLastIngredient);
    //print('New last: ' + ingredients.last);
  }
  return ingredients;
}

List<String> removeSpacesAndNewLines(List<String> ingredients) {
  for(var i = 0; i < ingredients.length; i++) {
    if(ingredients[i].contains('\n')) {
      ingredients[i] = ingredients[i].replaceAll('\n', ' ');
    }
    while(!ingredients[i].startsWith(new RegExp(r'[a-z]|[A-Z]|[0-9]'))) {
      ingredients[i] = ingredients[i].substring(1, ingredients[i].length);
    }
    if(ingredients[i].endsWith(' ')) {
      ingredients[i] = ingredients[i].substring(0, ingredients[i].length - 2);
    }
    if(ingredients[i].contains('  ')) {
      ingredients[i] = ingredients[i].replaceAll('  ', ' ');
    }
  }
  return ingredients;
}

List<String> cleanBrackets(List<String> ingredients) {
  //print('Removing brackets: ');
  for(int i = 0; i < ingredients.length; i++) {
    //print('Current ingredient: ' + ingredients[i]);
    if(ingredients[i].contains('(') && ingredients[i].contains(')')) {
      //print('Case 1: Both brackets found');
      continue;
    } else if(ingredients[i].contains('(')) {
        //print('Case 2: Open bracket found');
        List<String> newListOfWords = ingredients[i].split('(');
        //print('New split list: ');
        //print(newListOfWords);
        ingredients[i] = newListOfWords[0];
        ingredients.add(newListOfWords[1]);
    } else if(ingredients[i].contains(')')) {
        //print('Case 3: Closed bracket found');
        ingredients[i] = ingredients[i].replaceFirst(' )', "");
        ingredients[i] = ingredients[i].replaceFirst(')', "");
        //print('New ingredient: ' + ingredients[i]);
    }
  }
  return ingredients;
}