import 'package:edible/loader.dart';
import 'package:flutter/material.dart';
import 'package:edible/information.dart';
import 'package:edible/restrictions.dart' as restrictions;
import 'package:edible/image_process.dart' as image_process;


//Rename to something better, better architecture possible?
class ResultsPage extends StatelessWidget {
  List<String> _stringIngredientNamesToCheck = new List<String>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: image_process.overall(),
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        if(snapshot.connectionState == ConnectionState.done){
          final title = 'Results';
          _stringIngredientNamesToCheck = snapshot.data;
          final List<restrictions.ListItem> items = restrictions.setKosher(_stringIngredientNamesToCheck);
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
                                  Text(item.ingredient.name,
                                      style: TextStyle(
                                          fontSize: 18,
                                          //fontWeight: FontWeight.bold,
                                          color: Colors.grey.shade200)),
                                  Text(item.ingredient.description,
                                      style: TextStyle(color: Colors.grey.shade400)),
                                ],
                              ),
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



