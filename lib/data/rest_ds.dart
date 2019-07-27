import 'dart:async';
import 'dart:convert';

import 'package:edible/utils/network_util.dart';
import 'package:edible/models/user.dart';

class RestDatasource {
  NetworkUtil _netUtil = new NetworkUtil();
  static final BASE_URL = "https://cryptic-lake-93970.herokuapp.com";
  static final AUTH_URL = BASE_URL + "/auth";

  Future<User> login(String username, String password) async {
    Map<String, String> mapHeaders = {
      "Content-Type": "application/json"
    };
    
    var jwt = await _netUtil.post(AUTH_URL,
        headers: mapHeaders, body: jsonEncode({
          'email' : username,
          'password' : password
        }));
    String token = jwt["accessToken"];
    String id = jwt["id"];
    print(id);
    print(token);
    var LOGIN_URL = BASE_URL + '/users/' + id;
    print('here');
    // var queryParameters = {
    //   "param1": "one",
    //   "param2": "two",
    // };
    Map<String, String> getHeaders = {
      "Content-Type": "application/json",
      "Authorization": "Bearer " + token
    };
    return _netUtil.get(LOGIN_URL, headers: getHeaders
    ).then((dynamic res) {
      print(res.toString());
      if (res["error"] != null) throw new Exception(res["error_msg"]);
      return new User.map(res);
    });
  }
}
