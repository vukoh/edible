class User {
  String _username;
  String _password;
  String _dietaryRestriction;

  User(this._username, this._password, this._dietaryRestriction);

  User.map(dynamic obj) {
    this._username = obj["username"];
    this._password = obj["password"];
    this._dietaryRestriction = obj["dietaryRestriction"];
  }

  String get username => _username;
  String get password => _password;
  String get dietaryRestriction => _dietaryRestriction;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["username"] = _username;
    map["password"] = _password;
    map["dietaryRestriction"] = _dietaryRestriction;

    return map;
  }
}