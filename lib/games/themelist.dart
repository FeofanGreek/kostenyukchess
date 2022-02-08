
import 'dart:io';


import 'package:chess_/games/themegame.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../selectfirst.dart';




class themeSelectPage extends StatefulWidget {
  const themeSelectPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<themeSelectPage> createState() => _themeSelectPageState();
}

class _themeSelectPageState extends State<themeSelectPage> {



  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(context,
                    CupertinoPageRoute(builder: (context) => firstSelectPage(title: 'Выбор', )));
              },
              child: Icon(Icons.arrow_back)),
          title: Text(widget.title),
          actions: [],
        ),
        body: SingleChildScrollView(
            child:ListView.builder(
    physics: ScrollPhysics(),
    shrinkWrap: true,
    itemCount: typesGames.length,
    itemBuilder: (BuildContext context, int index) {
    return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                      elevation: 4.0,
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context,
                              CupertinoPageRoute(builder: (context) => themeGamePage(type: typesGames[index]['type'], title: typesGames[index]['title'],)));
                        },
                        splashColor: Colors.blue,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
      children:[
      Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Icon(CupertinoIcons.group),
                              ),
                              Expanded(
                                flex: 3,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child:  Text(typesGames[index]['title'],style: TextStyle(fontSize: 17.0 , color: Color(0xFF444444), fontFamily: 'Open Sans'),textAlign: TextAlign.left,),

                                ),
                              ),
                            ],
                          ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child:  Text(typesGames[index]['description'],style: TextStyle(fontSize: 17.0 , color: Color(0xFF444444), fontFamily: 'Open Sans'),textAlign: TextAlign.left,),

        ),
                        ])
                        ),
                      ),
                    ),
                  );}),


        )

    );
  }




}