class Ingredient{
  String code;
  String name;
  String description;
  String origin;
  String function;
  String dailyIntake;
  String sideEffects;
  String dietaryRestrictions;
  int halal;

  Ingredient(this.code, this.name, this.description, this.halal);

  Ingredient.fromJson(Map<String, dynamic> json){
    code = json['Code'];
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

/* Todo
  bool isVegetarian() {

  }
*/

}