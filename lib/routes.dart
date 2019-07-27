import 'package:flutter/material.dart';
import 'package:edible/screens/home/home_screen.dart';
import 'package:edible/screens/login/login_screen.dart';

final routes = {
  '/login': (BuildContext context) => new LoginScreen(),
  '/home': (BuildContext context) => new HomeScreen(title: 'Edible Home'),
};