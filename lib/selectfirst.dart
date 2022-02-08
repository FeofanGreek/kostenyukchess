
import 'dart:io';
import 'package:chess_/partnerselect.dart';
import 'package:chess_/stockfish.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

import 'analitics/viewerrors.dart';
import 'constants.dart';
import 'games/randomgame.dart';
import 'games/stormgame.dart';
import 'games/strikegame.dart';
import 'games/themelist.dart';


class firstSelectPage extends StatefulWidget {
  const firstSelectPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<firstSelectPage> createState() => _partnerSelectPageState();
}

class _partnerSelectPageState extends State<firstSelectPage> {



  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            automaticallyImplyLeading : false,
          title: Text(widget.title),
          actions: [
            GestureDetector(
                onTap:()async{
                  await Share.share('check out my website https://example.com', subject: 'Look what I made!');
                },child:Container(
              width:30,
              height: 30,
              margin: const EdgeInsets.all(8.0),
              child: Icon(Icons.share, size: 25, color:Colors.white,),
            )),
            GestureDetector(onTap: (){
              exit(0);
            }, child:Container(
                width:30,
                height: 30,
                margin: const EdgeInsets.all(8.0),
                child: Icon(Icons.exit_to_app_rounded, color: Colors.white))),

          ],
        ),
        body: SingleChildScrollView(
            child:Column(
                children:[
                  fio != '' ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                      elevation: 4.0,
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context,
                              CupertinoPageRoute(builder: (context) => partnerSelectPage(title: 'Выберите партнера')));
                        },
                        splashColor: Colors.blue,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Icon(CupertinoIcons.group),
                              ),
                              Expanded(
                                flex: 3,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child:  Text('Игра с человеком',style: TextStyle(fontSize: 17.0 , color: Color(0xFF444444), fontFamily: 'Open Sans'),textAlign: TextAlign.left,),

                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ) : Container(),
                  fio != '' ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                      elevation: 4.0,
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context,
                              CupertinoPageRoute(builder: (context) => viewErrorsPage(title: 'Анализ ошибок', id: id), ));
                        },
                        splashColor: Colors.blue,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Icon(CupertinoIcons.graph_square),
                              ),
                              Expanded(
                                flex: 3,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child:  Text('Мои ошибки',style: TextStyle(fontSize: 17.0 , color: Color(0xFF444444), fontFamily: 'Open Sans'),textAlign: TextAlign.left,),

                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ) : Container(),
                  /*fio != '' ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                      elevation: 4.0,
                      child: InkWell(
                        onTap: (){},
                        splashColor: Colors.blue,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Icon(CupertinoIcons.chart_pie),
                              ),
                              Expanded(
                                flex: 3,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child:  Text('Ваша статистика',style: TextStyle(fontSize: 17.0 , color: Color(0xFF444444), fontFamily: 'Open Sans'),textAlign: TextAlign.left,),

                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ) : Container(),*/
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                      elevation: 4.0,
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context,
                              CupertinoPageRoute(builder: (context) => stockFish()));
                        },
                        splashColor: Colors.blue,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Icon(CupertinoIcons.desktopcomputer),
                              ),
                              Expanded(
                                flex: 3,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child:  Text('Игра против компьютера',style: TextStyle(fontSize: 17.0 , color: Color(0xFF444444), fontFamily: 'Open Sans'),textAlign: TextAlign.left,),

                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                      elevation: 4.0,
                      child: InkWell(
                        onTap: (){
                          games = [];
                          crashGame = '';
                          crashMove = '';
                          Navigator.push(context,
                              CupertinoPageRoute(builder: (context) => randomGamePage()));
                        },
                        splashColor: Colors.blue,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Container(
                                  height: 20, width: 20,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage("images/randomgame.png"),
                                        fit:BoxFit.fitHeight, alignment: Alignment(0.0, 0.0)
                                    ),
                                  ),)
                              ),
                              Expanded(
                                flex: 3,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child:  Text('Случайная задача',style: TextStyle(fontSize: 17.0 , color: Color(0xFF444444), fontFamily: 'Open Sans'),textAlign: TextAlign.left,),

                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                      elevation: 4.0,
                      child: InkWell(
                        onTap: (){
                          games = [];
                          crashGame = '';
                          crashMove = '';
                          Navigator.push(context,
                              CupertinoPageRoute(builder: (context) => themeSelectPage(title: 'Выбор темы задачи',)));
                        },
                        splashColor: Colors.blue,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Icon(CupertinoIcons.selection_pin_in_out),
                              ),
                              Expanded(
                                flex: 3,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child:  Text('Выбор темы задачи',style: TextStyle(fontSize: 17.0 , color: Color(0xFF444444), fontFamily: 'Open Sans'),textAlign: TextAlign.left,),

                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                      elevation: 4.0,
                      child: InkWell(
                        onTap: (){
                          games = [];
                          crashGame = '';
                          crashMove = '';
                          Navigator.push(context,
                              CupertinoPageRoute(builder: (context) => strikeGamePage()));
                        },
                        splashColor: Colors.blue,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Icon(CupertinoIcons.strikethrough),
                              ),
                              Expanded(
                                flex: 3,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child:  Text('Игра Страйк',style: TextStyle(fontSize: 17.0 , color: Color(0xFF444444), fontFamily: 'Open Sans'),textAlign: TextAlign.left,),

                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                      elevation: 4.0,
                      child: InkWell(
                        onTap: (){
                          games = [];
                          crashGame = '';
                          crashMove = '';
                          Navigator.push(context,
                              CupertinoPageRoute(builder: (context) => stormGamePage()));
                        },
                        splashColor: Colors.blue,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Icon(CupertinoIcons.tropicalstorm),
                              ),
                              Expanded(
                                flex: 3,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child:  Text('Игра Шторм',style: TextStyle(fontSize: 17.0 , color: Color(0xFF444444), fontFamily: 'Open Sans'),textAlign: TextAlign.left,),

                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ])
        )

    );
  }




}