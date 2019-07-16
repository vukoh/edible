class Ingredient{
  String name;
  String description;
  String origin;
  String function;
  String dailyIntake;
  String sideEffects;
  String dietaryRestrictions;
  int halal;

  Ingredient(this.name, this.description, this.halal);

  Ingredient.fromJson(Map<String, dynamic> json){
    name = json['Name'];
    description = json['Description'];
    origin = json['Origin'];
    function = json['Function & Characteristics'];
    dailyIntake = json['Acceptable Daily Intake'];
    sideEffects = json['Side Effects'];
    dietaryRestrictions = json['Dietary Restrictions'];
    halal = json['Halal'];

  }

  bool isHalal() {
    return this.halal == 1 ? true : false;
  }
  //To do: Adjust function to put under maybe

/* Todo
  bool isVegetarian() {

  }
*/

}