import 'package:edible/ingredient.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InformationPage extends StatelessWidget {
  Ingredient ingredient;

  InformationPage(Ingredient ingredient) {
    this.ingredient = ingredient;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(ingredient.name),
        ),
        body: ListView.builder(
          itemBuilder: (context, index) => Card(
              elevation: 8.0,
              color: Color.fromRGBO(64, 96, 64, .9),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 32.0, bottom: 32.0, left: 16.0, right: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(_getTitle(index),
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade200)),
                    Text(_getInformation(index),
                        style: TextStyle(color: Colors.grey.shade400)),
                  ],
                ),
              )),
          itemCount: 5,
        ));
  }

  _getTitle(int index) {
    switch (index) {
      case 0:
        {
          return 'Origin';
        }
        break;

      case 1:
        {
          return 'Function & Characteristics';
        }
        break;

      case 2:
        {
          return 'Acceptable Daily Intake';
        }
        break;

      case 3:
        {
          return 'Side Effects';
        }
        break;

      case 4:
        {
          return 'Dietary Restrictions';
        }
    }
  }

  _getInformation(int index) {
    switch (index) {
      case 0:
        {
          return ingredient.origin;
        }
        break;

      case 1:
        {
          return ingredient.function;
        }
        break;

      case 2:
        {
          return ingredient.dailyIntake;
        }
        break;

      case 3:
        {
          return ingredient.sideEffects;
        }
        break;

      case 4:
        {
          return ingredient.dietaryRestrictions;
        }
    }
  }
}
