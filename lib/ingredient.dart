class Ingredient{
  String name;
  String description;
  String origin;
  String function;
  String dailyIntake;
  String sideEffects;
  String dietaryRestrictions;
  int halal;
  int vegetarian;
  int vegetarianNoMilk;
  int vegetarianNoEgg;
  int vegetarianNoMilkNoEgg;
  int vegan;
  int lactoOvoPescatarian;
  int kosher;

<<<<<<< HEAD
  Ingredient(this.name, this.description, this.halal);
=======
  //Double check this constructor - is this.halal needed?
  Ingredient(this.code, this.name, this.description, this.halal);
>>>>>>> 47b22ca488628e57391d9a8d11065c56e467e430

  Ingredient.fromJson(Map<String, dynamic> json){
    name = json['Name'];
    description = json['Description'];
    origin = json['Origin'];
    function = json['Function & Characteristics'];
    dailyIntake = json['Acceptable Daily Intake'];
    sideEffects = json['Side Effects'];
    dietaryRestrictions = json['Dietary Restrictions'];
    halal = json['Halal'];
    vegetarian = json['Vegetarian'];
    vegetarianNoMilk = json['Vegetarian (No Milk)'];
    vegetarianNoEgg = json['Vegetarian (No Egg)'];
    vegetarianNoMilkNoEgg = json['Vegetarian (No Egg, No Milk)'];
    vegan = json['Vegan'];
    lactoOvoPescatarian = json['Lacto-Ovo-Pescatarian'];
    kosher = json['Kosher'];
  }

  bool isHalal() {
    return this.halal == 1 ? true : false;
  }
  //To do: Adjust function to put under maybe

  bool isVegetarian() {
    return this.vegetarian == 1 ? true : false;
  }

  bool isVegetarianNoMilk() {
    return this.vegetarianNoMilk == 1 ? true : false;
  }

  bool isVegetarianNoEgg() {
    return this.vegetarianNoEgg == 1 ? true : false;
  }

  bool isVegetarianNoMilkNoEgg() {
    return this.vegetarianNoMilkNoEgg == 1 ? true : false;
  }

  bool isVegan() {
    return this.vegan == 1 ? true : false;
  }

  bool isLactoOvoPescatarian() {
    return this.lactoOvoPescatarian == 1 ? true : false;
  }

  bool isKosher() {
    return this.kosher == 1 ? true : false;
  }

}