import 'dart:async';
import 'dart:io' as io;
import 'package:edible/ingredient.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:edible/utils/network_util.dart';

NetworkUtil _networkUtil = new NetworkUtil();

class FoodDatabaseHelper {
  static final FoodDatabaseHelper _instance = new FoodDatabaseHelper.internal();
  factory FoodDatabaseHelper() => _instance;

  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  FoodDatabaseHelper.internal();

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "i.db");
    var theDb = await openDatabase(path, version: 2, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        "CREATE TABLE Ingredient(id INTEGER PRIMARY KEY, Name TEXT, `Description` TEXT," +
            "Origin TEXT, functionCharacteristics TEXT, acceptableDailyIntake TEXT," +
            "sideEffects TEXT, dietaryRestrictions TEXT, Halal INT," +
            "Vegetarian INT, VegetarianNoMilk INT, VegetarianNoEgg INT," +
            "VegetarianNoMilkNoEgg INT, Vegan INT, LactoOvoPescatarian INT," +
            "Kosher INT)");
    print("Created tables");
  }

  // void createTable(Database db) async {
  //   await db.execute(
  //       "CREATE TABLE Ingredient(id INTEGER PRIMARY KEY, Name TEXT, `Description` TEXT," +
  //           "Origin TEXT, Function & Characteristics TEXT, Acceptable Daily Intake TEXT," +
  //           "Side Effects TEXT, Dietary Restrictions TEXT, Halal INT," +
  //           "Vegetarian INT, Vegetarian (No Milk) INT, Vegetarian (No Egg) INT," +
  //           "Vegetrian (No Milk, No Egg) INT, Vegan INT, Lacto-Ovo-Pescatarian INT," +
  //           "Kosher INT)");
  //   print('executed');
  // }

  Future<int> updateDB() async {
    var dbClient = await db;
    var url = 'https://cryptic-lake-93970.herokuapp.com/ingredients';
    var ingredientsJson = await _networkUtil.get(url);
    for(var ingredientJson in ingredientsJson){
      Map<String, dynamic> map = ingredientJson;
      print(map);
      dbClient.update('Ingredient', map);
    }
    print('table updated');
    return 1;
  }

  Future<int> getVersion() async {
    var dbClient = await db;
    return dbClient.getVersion();
  }

  Future<List<Ingredient>> getIngredients() async {
    var dbClient = await db;
    List<Ingredient> ingredientList = new List<Ingredient>();
    dbClient.query('Ingredient').then((res) {
      for (var ingredientJson in res) {
        ingredientList.add(Ingredient.fromDB(ingredientJson));
      }
    });
    return ingredientList;
  }

  void setVersion(int version) async{
    var dbClient = await db;
    dbClient.setVersion(version);
  }

  // Future<User> getUser() async{
  //   var dbClient = await db;
  //   var res = await dbClient.query("User");
  //   return User.mapfromDatabase(res[0]);
  // }

}
