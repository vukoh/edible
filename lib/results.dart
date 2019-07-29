import 'package:edible/loader.dart';
import 'package:flutter/material.dart';
import 'package:edible/information.dart';
import 'package:edible/restrictions.dart' as restrictions;
import 'package:edible/image_process.dart' as image_process;
import 'package:edible/models/user.dart';


//Rename to something better, better architecture possible?
class ResultsPage extends StatelessWidget {
  List<String> _stringIngredientNamesToCheckTranslated = new List<String>();
  List<String> cleaned_english_ingredients = new List<String>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: image_process.overall(),
      builder: (BuildContext context, AsyncSnapshot<AwaitedInformation> snapshot) {
        if(snapshot.connectionState == ConnectionState.done){
          final title = 'Results';
          _stringIngredientNamesToCheckTranslated = snapshot.data._stringIngredientNamesToCheckTranslated;
          cleaned_english_ingredients = snapshot.data.cleaned_english_ingredients;
          final List<restrictions.ListItem> items = restrictions.checkandSet(_stringIngredientNamesToCheckTranslated, cleaned_english_ingredients, snapshot.data.user);
          return MaterialApp(
            title: title,
            home: Scaffold(
              backgroundColor: Color.fromRGBO(58, 86, 58, 1.0),
              appBar: AppBar(
                title: Text(title),
                backgroundColor: Color.fromRGBO(58, 86, 58, 1.0),
              ),
              body: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];

                  if (item is restrictions.HeadingItem) {
                    return InkWell(
                      child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(item.heading,
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey.shade200)),
                              ],
                            ));
                    /*
                    return InkWell(
                      child: Card(
                          elevation: 8.0,
                          color: Color.fromRGBO(64, 96, 64, .9),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 32.0, bottom: 32.0, left: 16.0, right: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(item.heading,
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey.shade200)),
                              ],
                            ),
                          )));
                  */
                  } else if (item is restrictions.MessageItem) {
                      return InkWell(
                        child: Card(
                            elevation: 8.0,
                            color: Color.fromRGBO(64, 96, 64, .9),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 32.0, bottom: 32.0, left: 16.0, right: 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(item.sender,
                                      style: TextStyle(
                                          fontSize: 18,
                                          //fontWeight: FontWeight.bold,
                                          color: Colors.grey.shade200)),
                                ],
                              ),
                            )));

                  } else if (item is restrictions.IngredientItem) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      InformationPage(item.ingredient)));
                        },
                        child: Card(
                            elevation: 8.0,
                            color: Color.fromRGBO(64, 96, 64, .9),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 32.0, bottom: 32.0, left: 16.0, right: 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(item.translated,
                                      style: TextStyle(
                                          fontSize: 18,
                                          //fontWeight: FontWeight.bold,
                                          color: Colors.grey.shade200)),
                                  Text(item.ingredient.description,
                                      style: TextStyle(color: Colors.grey.shade400)),
                                ],
                              ),
                            )));
                  } else if(item is restrictions.MissingItem) {
                    return InkWell(
                      child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 20.0, bottom: 20.0, left: 10.0, right: 10.0),
                      child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(item.missingitem,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontStyle: FontStyle.italic,
                                        color: Colors.grey.shade50)),
                              ],
                            )));
                  }
                },
              ),
            ),
          );
        } else {
            return new ColorLoader3();
        }
      }
    );
  }
}

class AwaitedInformation{
  User user;
  List<String> _stringIngredientNamesToCheckTranslated;
  List<String> cleaned_english_ingredients;
  AwaitedInformation(this.user, this._stringIngredientNamesToCheckTranslated, this.cleaned_english_ingredients);
}

