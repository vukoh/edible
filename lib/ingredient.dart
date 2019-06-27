class Ingredient{
  String name;
  String description;

  Ingredient(this.name, this.description);

  Ingredient.fromJson(Map<String, dynamic> json){
    name = json['Name'];
    description = json['Description'];
  }
}