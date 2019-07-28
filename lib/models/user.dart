class User {

  String _userID;
  String _firstName;
  String _lastName;
  String _username;
  String _password;
  String _dietaryRestriction;
  String _language;

  User(this._username, this._firstName
   , this._lastName, this._password, this._dietaryRestriction, this._language);

  User.mapfromDatabase(dynamic obj) {
    print(obj);
    this._userID = obj["userID"];
    this._firstName = obj["firstName"];
    this._lastName = obj["lastName"];
    this._username = obj["username"];
    this._password = obj["password"];
    this._dietaryRestriction = obj["dietaryRestriction"];
    this._language = obj["language"];
  }

  User.map(dynamic obj) {
    print(obj);
    this._userID = obj["_id"];
    this._firstName = obj["firstName"];
    this._lastName = obj["lastName"];
    this._username = obj["email"];
    this._password = obj["password"];
    this._dietaryRestriction = obj["dietaryRestriction"];
    this._language = obj["language"];
  }
  String get id => _userID;
  String get firstName => _firstName;
  String get lastName => _lastName;
  String get username => _username;
  String get password => _password;
  String get dietaryRestriction => _dietaryRestriction;
  String get language => _language;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = _userID;
    map["firstName"] = _firstName;
    map["lastName"] = _lastName;
    map["email"] = _username;
    map["password"] = _password;
    map["dietaryRestriction"] = _dietaryRestriction;
    map["language"] = _language;

    return map;
  }

  void setFirstName(String firstName){
    _firstName = firstName;
  }

  void setLastName(String lastName){
    _lastName = lastName;
  }

  void setUsername(String userame){
    _username = username;
  }

  void setPassword(String password){
    _password = password;
  }

  void setDiet(String dietaryRestriction){
    _dietaryRestriction = dietaryRestriction;
  }

  void setLanguage(String language){
    _language = language;
  }

  Map<String, dynamic> toDatabase() {
    var map = new Map<String, dynamic>();
    map["id"] = _userID;
    map["firstName"] = _firstName;
    map["lastName"] = _lastName;
    map["username"] = _username;
    map["password"] = _password;
    map["dietaryRestriction"] = _dietaryRestriction;
    map["language"] = _language;

    return map;
  }
}