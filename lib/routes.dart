import 'package:flutter/material.dart';
import 'package:edible/screens/home/home_screen.dart';
import 'package:edible/screens/login/login_screen2.dart';

final routes = {
  '/login': (BuildContext context) => new LoginScreen2(),
  '/home': (BuildContext context) => new HomeScreen(title: "Edible"),
};