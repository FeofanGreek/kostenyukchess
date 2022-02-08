import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../selectfirst.dart';
import '../socketchat.dart';



gameProceedScreen(var context, String message, String owner, String arrived, String token, String player1, String player2, int major){
  return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Color(0xFF1D2830).withOpacity(0.2),
      builder: (context) {
        return AlertDialog(
            backgroundColor: Colors.transparent,
            contentPadding: EdgeInsets.fromLTRB(0, 0, 0 , 0),
            insetPadding: EdgeInsets.all(0),
            elevation: 0.0,
            content:Container(
              color: Colors.transparent,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              alignment: Alignment.center,
              child: Container(
                  width: 250,
                  //height: 250
                  height: 200,
                  margin: EdgeInsets.fromLTRB(20,20,20,20),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                      width: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(16.5),
                    color: Colors.grey[50],
                  ),
                  padding: EdgeInsets.fromLTRB(20,20,20,20),
                  child:  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[

                        Text(message, textAlign: TextAlign.center,
                          //style: appBarHeader,
                        ),
                        SizedBox(height: 10,),
                        Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.bottomCenter,
                          margin: EdgeInsets.fromLTRB(0,10,0,0),
                          child: TextButton(
                            onPressed:(){
                              //Navigator.of(context).pop();
                              cancelArrive(context, owner, arrived, token,);
                                //редиректимся на экран выбора

                                //const twentyMillis = const Duration(seconds:2);
                                //Timer(twentyMillis, () => Navigator.pop(context,
                                //    CupertinoPageRoute(builder: (context) => firstSelectPage(title: 'Выбор'))));


                            } ,
                            child: Text('Отказаться', style:  TextStyle(fontSize: 16, color: Colors.white), textAlign: TextAlign.center,),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blue,
                              minimumSize: Size(MediaQuery.of(context).size.width, 20),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Colors.blue,
                                    width: 1,
                                    style: BorderStyle.solid
                                ),
                                borderRadius: BorderRadius.circular(0.0),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.bottomCenter,
                          margin: EdgeInsets.fromLTRB(0,10,0,0),
                          child: TextButton(
                            onPressed:(){
                              //Navigator.of(context).pop();
                              //Navigator.of(context,rootNavigator: true).pop();
                              ///TODO to game
                              //редиректимся на экран выбора
                              const twentyMillis = const Duration(seconds:2);
                              Timer(twentyMillis, () => Navigator.push(context,
                                  CupertinoPageRoute(builder: (context) => ChatPage(owner:arrived , arrived: owner, token: token, player1: player1, player2: player2, status: major,))));/// специально наоборот
                            } ,
                            child: Text('Играть', style: TextStyle(fontSize: 16, color: Colors.white), textAlign: TextAlign.center,),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blue,
                              minimumSize: Size(MediaQuery.of(context).size.width, 20),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Colors.blue,
                                    width: 1,
                                    style: BorderStyle.solid
                                ),
                                borderRadius: BorderRadius.circular(0.0),
                              ),
                            ),
                          ),
                        ),

                      ])

              ),
            )
        );
      });

}