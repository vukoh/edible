class Ingredient{
  String code;
  String name;
  String description;
  int halal;

  Ingredient(this.code, this.name, this.description, this.halal);

  Ingredient.fromJson(Map<String, dynamic> json){
    code = json['Code'];
    name = json['Name'];
    description = json['Description'];
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