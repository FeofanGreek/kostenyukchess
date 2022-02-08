import 'dart:async';
import 'dart:math';
import 'package:chess_/constants.dart';
import 'package:chess_/selectfirst.dart';
import 'package:chess_/servicefunctions.dart';
import 'package:chess_/utils/dialogscreen.dart';
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'chessboard/src/chess_board.dart';
import 'chessboard/src/chess_board_controller.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

import 'package:stockfish/stockfish.dart';




String myid = "";
double valueToSliderTimer = 0.0;
int coundownValue = 0;
double valueToSliderAddTime = 0.0;
int addtime = 0;
double valueToSliderTimerFish = 0.0;
int coundownValueFish = 0;
double valueToSliderAddTimeFish = 0.0;
int addtimeFish = 0;
bool diferentTimers = false;
bool diferentAddTime = false;
bool timeVariantConstructor = false;
int selectedTimeVarian = 0;


int chessBoradTypeSelect = 1;
bool initialisedStockFish = false;
String fen = '';

class stockFish extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return stockFishState();
  }
}

class stockFishState extends State<stockFish>{



  String timeToStockFish = '0';
  late Stockfish stockfish;
  late StreamSubscription subscription; ///my add

  late ChessBoardController controller;
  late CountdownController _controllerTier1 = CountdownController(autoStart: false);
  late CountdownController _controllerTier2 = CountdownController(autoStart: false);
  List<String> gameMoves = [];
  var flipBoardOnMove = true;
  TextEditingController _controllerFen = TextEditingController(text: '');

  FocusNode myFocusNode1 = FocusNode();
  void _requestFocus1(){
    setState(() {
      FocusScope.of(context).requestFocus(myFocusNode1);
    });
  }



  @override
  void initState() {
    super.initState();
    stockfish = Stockfish();
    controller = ChessBoardController();
  }

  @override
  void dispose() {
    !mounted ? subscription.cancel() : null;
    stockfish.dispose();
    super.dispose();
  }

  Future<bool> _onBackPressed() {
    return Future.value(false); //если есть предыдущая страница
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressed,
        child:Scaffold(
            appBar: AppBar(
              leading: GestureDetector(onTap: (){
                _controllerFen.text = "";
                Navigator.pushReplacement (context,
                    CupertinoPageRoute(builder: (context) => firstSelectPage(title: "Выбор" ,)));
              }, child:Icon(Icons.chevron_left, color: Colors.white, size: 35,)),
              title: const Text('Игра с компьютером'),
              actions: [],
            ),
            body: SingleChildScrollView(
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10,),
                  ///таймер для робота
                  myid == ''? timeVariantConstructor == false ? Column(
                      children:[
                        diferentTimers == true ? Text('Время на игру ${_printDuration(Duration(milliseconds: (coundownValueFish*1000).toInt(),), 1)}') : Container(),
                        diferentTimers == true ? Container(
                            width:MediaQuery.of(context).size.width,
                            margin: EdgeInsets.fromLTRB(10,0,10,0),
                            child:CupertinoSlider(min: 0, max: 43, divisions:43, value: valueToSliderTimerFish, onChanged: (value){setState(() {
                              valueToSliderTimerFish = value;
                              coundownValueFish = countDownTimerValue(value);
                            });})) : Container(),
                        diferentAddTime == true ? Text('Прибавка за ход ${_printDuration(Duration(milliseconds: (addtimeFish*1000).toInt(),),2)}') : Container(),
                        diferentAddTime == true ? Container(
                            width:MediaQuery.of(context).size.width,
                            margin: EdgeInsets.fromLTRB(10,0,10,0),
                            child:CupertinoSlider(min: 0, max: 26, divisions:26, value: valueToSliderAddTimeFish, onChanged: (value){setState(() {
                              valueToSliderAddTimeFish = value;
                              addtimeFish = addTimeTimerValue(value);
                            });})) : Container(),
                      ]
                  ) : Container() :
                  ///таймер в игре для робота
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:[

                        Countdown(
                          controller: _controllerTier1,
                          seconds: coundownValueFish ,
                          addtime: addtime,
                          build: (_, double time) => Text(
                              _printDuration(Duration(milliseconds: (time*1000).toInt()),1),
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.left
                          ),
                          interval: Duration(milliseconds: 100),
                          onFinished: () {
                            if(stockfish.state.value != StockfishState.disposed) {
                              stockfish.stdin = 'stop';
                              stockfish.stdin = 'quit';
                              _controllerTier1.onRestart!();
                              _controllerTier2.onRestart!();
                              _controllerTier1.onPause!();
                              _controllerTier2.onPause!();
                              valueToSliderTimer = 0.0;
                              coundownValue = 0;
                              valueToSliderAddTime = 0.0;
                              addtime = 0;
                              valueToSliderTimerFish = 0.0;
                              coundownValueFish = 0;
                              valueToSliderAddTimeFish = 0.0;
                              addtimeFish = 0;
                              fen = "";
                              myid ='';
                            }
                            setState(() {

                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Время закончилось!'),
                              ),
                            );
                          },
                        ),
                        Text('StockFish',style: TextStyle(
                          fontSize: 16,
                          //color: controller. ? Colors.red : Colors.green
                        ),)
                      ]),
                  ///доска
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: ChessBoard(
                      size: MediaQuery.of(context).size.width,
                        boardType: chessBoradTypeSelect == 1 ? BoardType.brown : chessBoradTypeSelect == 2 ? BoardType.darkBrown  : chessBoradTypeSelect == 3 ? BoardType.green : BoardType.orange,
                      onMove: (moveNotation) {
                        gameMoves.add(moveNotation);
                        //gameMoves.add(moveNotation);
                        //print(gameMoves);
                        //print(controller.game.board);
                        print(controller.game.getHistory()); // в принципе видно когда что то берем [exf4, g3], [e5, f4] и когда ставят шах [Bg4+, Ke3]
                        //print(controller.game.pgn());
                        controller.game.load(controller.game.fen); //загружаем фен
                        _controllerTier2.onPause!(); //остановили таймер
                        _controllerTier1.onStart!();
                        //print(('position fen ${controller.game.fen} moves ${moveNotation}\nd\ngo movetime $timeToStockFish'));
                        stockfish.stdin = 'position fen ${controller.game.fen} moves ${moveNotation}\nd\ngo movetime $timeToStockFish';
                      },
                      onCheckMate: (winColor) {
                        if(stockfish.state.value != StockfishState.disposed) {
                          stockfish.stdin = 'stop';
                          stockfish.stdin = 'quit';
                          _controllerTier1.onRestart!();
                          _controllerTier2.onRestart!();
                          _controllerTier1.onPause!();
                          _controllerTier2.onPause!();
                          valueToSliderTimer = 0.0;
                          coundownValue = 0;
                          valueToSliderAddTime = 0.0;
                          addtime = 0;
                          valueToSliderTimerFish = 0.0;
                          coundownValueFish = 0;
                          valueToSliderAddTimeFish = 0.0;
                          addtimeFish = 0;
                          //myid = "";
                          //fen = '';
                        }
                        //setState(() {
                        //});
                        dialogScreen(context, '${winColor} Поставлен мат!');
                      },
                      onDraw: () {
                        if(stockfish.state.value != StockfishState.disposed) {
                          stockfish.stdin = 'stop';
                          stockfish.stdin = 'quit';
                          _controllerTier1.onRestart!();
                          _controllerTier2.onRestart!();
                          _controllerTier1.onPause!();
                          _controllerTier2.onPause!();
                          valueToSliderTimer = 0.0;
                          coundownValue = 0;
                          valueToSliderAddTime = 0.0;
                          addtime = 0;
                          valueToSliderTimerFish = 0.0;
                          coundownValueFish = 0;
                          valueToSliderAddTimeFish = 0.0;
                          addtimeFish = 0;
                          //myid = "";
                          //fen = '';
                        }
                        //setState(() {
                        //});
                        dialogScreen(context, 'Ничья!');
                      },

                      chessBoardController: controller,
                      whiteSideTowardsUser: myid == "Color.WHITE" ? true : false,
                      //enableUserMoves: myid=='' ? false : controller.game.generate_fen().split(' ')[1] == (myid == "Color.WHITE" ? 'w' : 'b') ?  true : false ,
                      onCheck: (PieceColor color) {},

                    ),
                  ),
                  ///select type time
                  myid == '' ? Container(
                      width:MediaQuery.of(context).size.width,
                      margin: EdgeInsets.fromLTRB(10,0,10,0),
                      child:Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:[
                            Text('Конструктор'),
                            Switch(value: timeVariantConstructor, onChanged: (v){setState(() {
                              timeVariantConstructor = !timeVariantConstructor;
                            });}),

                            Text('Наборы'),
                          ]
                      )) : Container(),
                  ///таймер для игрока или для обоих
                  myid == '' ? timeVariantConstructor == false ? Column(
                      children:[

                        Text('Время на игру ${_printDuration(Duration(milliseconds: (coundownValue*1000).toInt(),), 1)}'),
                        Container(
                            width:MediaQuery.of(context).size.width,
                            margin: EdgeInsets.fromLTRB(10,0,10,0),
                            child:CupertinoSlider(min: 0, max: 43, divisions:43, value: valueToSliderTimer, onChanged: (value){setState(() {
                              valueToSliderTimer = value;
                              diferentTimers == false ? valueToSliderTimerFish = value : null;
                              coundownValue = countDownTimerValue(value);
                              diferentTimers == false ? coundownValueFish = countDownTimerValue(value) : null;
                            });})),
                        Text('Прибавка за ход ${_printDuration(Duration(milliseconds: (addtime*1000).toInt(),),2)}'),
                        Container(
                            width:MediaQuery.of(context).size.width,
                            margin: EdgeInsets.fromLTRB(10,0,10,0),
                            child:CupertinoSlider(min: 0, max: 26, divisions:26, value: valueToSliderAddTime, onChanged: (value){setState(() {
                              valueToSliderAddTime = value;
                              diferentAddTime == false ? valueToSliderAddTimeFish = value : null;
                              addtime = addTimeTimerValue(value);
                              diferentAddTime == false ? addtimeFish = addTimeTimerValue(value) : null;
                            });})),
                        Container(
                            width:MediaQuery.of(context).size.width,
                            margin: EdgeInsets.fromLTRB(20,0,20,0),
                            child:Row(
                                children:[

                                  GestureDetector(onTap: (){setState(() {
                                    diferentTimers= !diferentTimers;
                                  });},child:Container(child:Row(children:[Icon(diferentTimers == true ? Icons.check_box : Icons.check_box_outline_blank, color: Colors.blue,), Text('Разное время')]))),
                                  Spacer(),
                                  GestureDetector(onTap: (){setState(() {
                                    diferentAddTime = !diferentAddTime;
                                  });},child:Container(child:Row(children:[Icon(diferentAddTime == true ? Icons.check_box : Icons.check_box_outline_blank,color: Colors.blue), Text('Разная прибавка')]))),

                                ]
                            )),
                      ]
                  )
                  ///ready time bundle
                      : Container(
                      child: Wrap(
                          spacing: 5,
                          alignment: WrapAlignment.center,
                          crossAxisAlignment:WrapCrossAlignment.center,
                          children : [
                            GestureDetector(
                                onTap:(){
                                  setState(() {
                                    selectedTimeVarian = 1;
                                    addtime = 0;
                                    addtimeFish = 0;
                                    coundownValue = 60;
                                    coundownValueFish = 60;

                                  });
                                },
                                child:Container(
                                    width:MediaQuery.of(context).size.width /3 -15,
                                    height: 80,
                                    color: selectedTimeVarian == 1 ? Colors.lightBlue : Colors.white60,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.fromLTRB(5,5,5,5),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text('1 + 0',style: TextStyle(fontSize: 30.0 , color: Color(0xFF444444), fontFamily: 'Open Sans'),textAlign: TextAlign.center,),
                                        Text('Bullet', style: TextStyle(fontSize: 22.0 , color: Color(0xFF444444), fontFamily: 'Open Sans'),textAlign: TextAlign.center,)
                                      ],
                                    )
                                )),
                            GestureDetector(
                                onTap:(){
                                  setState(() {
                                    selectedTimeVarian = 2;
                                    addtime = 1;
                                    addtimeFish = 1;
                                    coundownValue = 120;
                                    coundownValueFish = 120;

                                  });
                                },
                                child:Container(
                                    width:MediaQuery.of(context).size.width /3 -15,
                                    height: 80,
                                    color: selectedTimeVarian == 2 ? Colors.lightBlue : Colors.white60,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.fromLTRB(5,5,5,5),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text('2 + 1',style: TextStyle(fontSize: 30.0 , color: Color(0xFF444444), fontFamily: 'Open Sans'),textAlign: TextAlign.center,),
                                        Text('Bullet', style: TextStyle(fontSize: 22.0 , color: Color(0xFF444444), fontFamily: 'Open Sans'),textAlign: TextAlign.center,)
                                      ],
                                    )
                                )),
                            GestureDetector(
                                onTap:(){
                                  setState(() {
                                    selectedTimeVarian = 3;
                                    addtime = 0;
                                    addtimeFish = 0;
                                    coundownValue = 180;
                                    coundownValueFish = 180;

                                  });
                                },
                                child:Container(
                                    width:MediaQuery.of(context).size.width /3 - 15,
                                    height: 80,
                                    color: selectedTimeVarian == 3 ? Colors.lightBlue : Colors.white60,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.fromLTRB(5,5,5,5),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text('3 + 0',style: TextStyle(fontSize: 30.0 , color: Color(0xFF444444), fontFamily: 'Open Sans'),textAlign: TextAlign.center,),
                                        Text('Bullet', style: TextStyle(fontSize: 22.0 , color: Color(0xFF444444), fontFamily: 'Open Sans'),textAlign: TextAlign.center,)
                                      ],
                                    )
                                )),
                            GestureDetector(
                                onTap:(){
                                  setState(() {
                                    selectedTimeVarian = 4;
                                    addtime = 2;
                                    addtimeFish = 2;
                                    coundownValue = 180;
                                    coundownValueFish = 180;

                                  });
                                },
                                child:Container(
                                    width:MediaQuery.of(context).size.width /3 -15,
                                    height: 80,
                                    color: selectedTimeVarian == 4 ? Colors.lightBlue : Colors.white60,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.fromLTRB(5,5,5,5),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text('3 + 2',style: TextStyle(fontSize: 30.0 , color: Color(0xFF444444), fontFamily: 'Open Sans'),textAlign: TextAlign.center,),
                                        Text('Blitz', style: TextStyle(fontSize: 22.0 , color: Color(0xFF444444), fontFamily: 'Open Sans'),textAlign: TextAlign.center,)
                                      ],
                                    )
                                )),
                            GestureDetector(
                                onTap:(){
                                  setState(() {
                                    selectedTimeVarian = 5;
                                    addtime = 0;
                                    addtimeFish = 0;
                                    coundownValue = 300;
                                    coundownValueFish = 300;

                                  });
                                },
                                child:Container(
                                    width:MediaQuery.of(context).size.width /3 -15,
                                    height: 80,
                                    color: selectedTimeVarian == 5 ? Colors.lightBlue : Colors.white60,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.fromLTRB(5,5,5,5),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text('5 + 0',style: TextStyle(fontSize: 30.0 , color: Color(0xFF444444), fontFamily: 'Open Sans'),textAlign: TextAlign.center,),
                                        Text('Blitz', style: TextStyle(fontSize: 22.0 , color: Color(0xFF444444), fontFamily: 'Open Sans'),textAlign: TextAlign.center,)
                                      ],
                                    )
                                )),
                            GestureDetector(
                                onTap:(){
                                  setState(() {
                                    selectedTimeVarian = 6;
                                    addtime = 3;
                                    addtimeFish = 3;
                                    coundownValue = 300;
                                    coundownValueFish = 300;

                                  });
                                },
                                child:Container(
                                    width:MediaQuery.of(context).size.width /3 - 15,
                                    height: 80,
                                    color: selectedTimeVarian == 6 ? Colors.lightBlue : Colors.white60,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.fromLTRB(5,5,5,5),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text('5 + 3',style: TextStyle(fontSize: 30.0 , color: Color(0xFF444444), fontFamily: 'Open Sans'),textAlign: TextAlign.center,),
                                        Text('Blitz', style: TextStyle(fontSize: 22.0 , color: Color(0xFF444444), fontFamily: 'Open Sans'),textAlign: TextAlign.center,)
                                      ],
                                    )
                                )),
                            GestureDetector(
                                onTap:(){
                                  setState(() {
                                    selectedTimeVarian = 7;
                                    addtime = 0;
                                    addtimeFish = 0;
                                    coundownValue = 600;
                                    coundownValueFish = 600;

                                  });
                                },
                                child:Container(
                                    width:MediaQuery.of(context).size.width /3 -15,
                                    height: 80,
                                    color: selectedTimeVarian == 7 ? Colors.lightBlue : Colors.white60,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.fromLTRB(5,5,5,5),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text('10 + 0',style: TextStyle(fontSize: 30.0 , color: Color(0xFF444444), fontFamily: 'Open Sans'),textAlign: TextAlign.center,),
                                        Text('Rapid', style: TextStyle(fontSize: 22.0 , color: Color(0xFF444444), fontFamily: 'Open Sans'),textAlign: TextAlign.center,)
                                      ],
                                    )
                                )),
                            GestureDetector(
                                onTap:(){
                                  setState(() {
                                    selectedTimeVarian = 8;
                                    addtime = 5;
                                    addtimeFish = 5;
                                    coundownValue = 600;
                                    coundownValueFish = 600;

                                  });
                                },
                                child:Container(
                                    width:MediaQuery.of(context).size.width /3 -15,
                                    height: 80,
                                    color: selectedTimeVarian == 8 ? Colors.lightBlue : Colors.white60,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.fromLTRB(5,5,5,5),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text('10 + 5',style: TextStyle(fontSize: 30.0 , color: Color(0xFF444444), fontFamily: 'Open Sans'),textAlign: TextAlign.center,),
                                        Text('Rapid', style: TextStyle(fontSize: 22.0 , color: Color(0xFF444444), fontFamily: 'Open Sans'),textAlign: TextAlign.center,)
                                      ],
                                    )
                                )),
                            GestureDetector(
                                onTap:(){
                                  setState(() {
                                    selectedTimeVarian = 9;
                                    addtime = 10;
                                    addtimeFish = 10;
                                    coundownValue = 900;
                                    coundownValueFish = 900;

                                  });
                                },
                                child:Container(
                                    width:MediaQuery.of(context).size.width /3 - 15,
                                    height: 80,
                                    color: selectedTimeVarian == 9 ? Colors.lightBlue : Colors.white60,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.fromLTRB(5,5,5,5),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text('15 + 10',style: TextStyle(fontSize: 30.0 , color: Color(0xFF444444), fontFamily: 'Open Sans'),textAlign: TextAlign.center,),
                                        Text('Rapid', style: TextStyle(fontSize: 22.0 , color: Color(0xFF444444), fontFamily: 'Open Sans'),textAlign: TextAlign.center,)
                                      ],
                                    )
                                )),
                            GestureDetector(
                                onTap:(){
                                  setState(() {
                                    selectedTimeVarian = 10;
                                    addtime = 0;
                                    addtimeFish = 0;
                                    coundownValue = 1800;
                                    coundownValueFish = 1800;

                                  });
                                },
                                child:Container(
                                    width:MediaQuery.of(context).size.width /3 -15,
                                    height: 80,
                                    color: selectedTimeVarian == 10 ? Colors.lightBlue : Colors.white60,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.fromLTRB(5,5,5,5),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text('30 + 0',style: TextStyle(fontSize: 30.0 , color: Color(0xFF444444), fontFamily: 'Open Sans'),textAlign: TextAlign.center,),
                                        Text('Classical', style: TextStyle(fontSize: 22.0 , color: Color(0xFF444444), fontFamily: 'Open Sans'),textAlign: TextAlign.center,)
                                      ],
                                    )
                                )),
                            GestureDetector(
                                onTap:(){
                                  setState(() {
                                    selectedTimeVarian = 11;
                                    addtime = 20;
                                    addtimeFish = 20;
                                    coundownValue = 1800;
                                    coundownValueFish = 1800;

                                  });
                                },
                                child:Container(
                                    width:MediaQuery.of(context).size.width /3 -15,
                                    height: 80,
                                    color: selectedTimeVarian == 11 ? Colors.lightBlue : Colors.white60,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.fromLTRB(5,5,5,5),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text('30 + 20',style: TextStyle(fontSize: 28.0 , color: Color(0xFF444444), fontFamily: 'Open Sans'),textAlign: TextAlign.center,),
                                        Text('Classical', style: TextStyle(fontSize: 22.0 , color: Color(0xFF444444), fontFamily: 'Open Sans'),textAlign: TextAlign.center,)
                                      ],
                                    )
                                )),
                          ]
                      )
                  )
                      :
                  ///таймер для игрока в игре
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:[
                        Countdown(
                          controller: _controllerTier2,
                          seconds: coundownValue ,
                          addtime: addtime,
                          build: (_, double time) => Text(
                            //time.toString(),
                              '${_printDuration(Duration(milliseconds: (time*1000).toInt()),1)}',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.left
                          ),
                          interval: Duration(milliseconds: 100),
                          onFinished: () {
                            if(stockfish.state.value != StockfishState.disposed) {
                              stockfish.stdin = 'stop';
                              stockfish.stdin = 'quit';
                              _controllerTier1.onRestart!();
                              _controllerTier2.onRestart!();
                              _controllerTier1.onPause!();
                              _controllerTier2.onPause!();
                              valueToSliderTimer = 0.0;
                              coundownValue = 0;
                              valueToSliderAddTime = 0.0;
                              addtime = 0;
                              valueToSliderTimerFish = 0.0;
                              coundownValueFish = 0;
                              valueToSliderAddTimeFish = 0.0;
                              addtimeFish = 0;
                              //myid = "";
                              //fen = '';
                            }
                            //setState(() {
                            //});
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Время закончилось!'),
                              ),
                            );
                          },
                        ),
                        Text('$username')
                      ]),
                  myid != "" ? Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.bottomCenter,
                    margin: EdgeInsets.fromLTRB(0,10,0,0),
                    child: TextButton(
                      onPressed:(){
                        if(stockfish.state.value != StockfishState.disposed) {
                          stockfish.stdin = 'stop';
                          stockfish.stdin = 'quit';
                          _controllerTier1.onRestart!();
                          _controllerTier2.onRestart!();
                          _controllerTier1.onPause!();
                          _controllerTier2.onPause!();
                          valueToSliderTimer = 0.0;
                          coundownValue = 0;
                          valueToSliderAddTime = 0.0;
                          addtime = 0;
                          valueToSliderTimerFish = 0.0;
                          coundownValueFish = 0;
                          valueToSliderAddTimeFish = 0.0;
                          addtimeFish = 0;
                          myid = "";
                          fen = '';
                        }
                        setState(() {

                        });
                      } ,
                      child: Text('Перезапустить игру', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF000000)),textAlign: TextAlign.center),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFFFFFFFF),
                        minimumSize: Size(MediaQuery.of(context).size.width, 20),

                      ),
                    ),
                  ) : Column(
                      children: <Widget>[

                        Container(
                            margin: const EdgeInsets.fromLTRB(16,16,16,0),
                            padding: const EdgeInsets.fromLTRB(0,0,0,0),
                            alignment: Alignment.topCenter,
                            width: MediaQuery.of(context).size.width,
                            child:
                                TextFormField(
                              maxLines: 3,
                              minLines: 1,
                              cursorColor: Colors.black,
                              focusNode: myFocusNode1,
                              textAlign: TextAlign.left,
                              enabled: true,
                              style: TextStyle(fontSize: 16, color: Colors.black),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(
                                    left: 10, top: 10, bottom: 10,
                                ),
                                suffixIcon:InkWell(onTap:(){
                                  _controllerFen.clear();
                                }, child:Container(width: 20, height: 20, child:Icon(CupertinoIcons.clear))),

                                hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
                                hintText: "Cтартовый FEN",
                                border: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(Radius.circular(3.0)),
                                    borderSide: BorderSide(color: Colors.grey, width: 1)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(3.0)),
                                    borderSide: BorderSide(color: Colors.grey, width: 1)),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(3.0),
                                  borderSide: BorderSide(color: Colors.grey, width: 1),
                                ),
                              ),

                              onChanged: (_){
                                setState(() {
                                  fen =_controllerFen.text;
                                });
                              },
                              autovalidateMode: AutovalidateMode.always,
                              controller: _controllerFen,
                            )),
                        DropdownButton<String>(
                          hint: Text('Готовые значения FEN'),
                          items: fensExample.map((value) {
                            return DropdownMenuItem<String>(
                              value: value['fen'],
                              child: Text(value['title']),
                            );
                          }).toList(),
                          onChanged: (value) {
                            fen = value!;
                            _controllerFen.text = value;
                          },
                        ),
                        SizedBox(height: 10,),
                        Text("Вид доски", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF333333)),textAlign: TextAlign.center),
                        Container(
                            margin: EdgeInsets.fromLTRB(30,10,30,0),
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:[
                            GestureDetector(onTap:(){
                              setState(() {
                                chessBoradTypeSelect = 1;
                              });
                            }, child:Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                image: DecorationImage(
                                    image: AssetImage("images/brown_board.png"),
                                    fit:BoxFit.fitHeight, alignment: Alignment(0.0, 0.0)
                                ),
                              ),
                            )),
                            GestureDetector(onTap:(){
                              setState(() {
                                chessBoradTypeSelect = 2;
                              });
                            }, child:Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                image: DecorationImage(
                                    image: AssetImage("images/dark_brown_board.png"),
                                    fit:BoxFit.fitHeight, alignment: Alignment(0.0, 0.0)
                                ),
                              ),
                            )),
                            GestureDetector(onTap:(){
                              setState(() {
                                chessBoradTypeSelect = 3;
                              });
                            }, child:Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                image: DecorationImage(
                                    image: AssetImage("images/green_board.png"),
                                    fit:BoxFit.fitHeight, alignment: Alignment(0.0, 0.0)
                                ),
                              ),
                            )),
                            GestureDetector(onTap:(){
                              setState(() {
                                chessBoradTypeSelect = 5;
                              });
                            }, child:Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                image: DecorationImage(
                                    image: AssetImage("images/orange_board.png"),
                                    fit:BoxFit.fitHeight, alignment: Alignment(0.0, 0.0)
                                ),
                              ),
                            )),
                          ]
                        )),
                        SizedBox(height: 10,),
                        Text("Ваши фигуры", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF333333)),textAlign: TextAlign.center),
                        SizedBox(height: 10,),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:[
                              Container(
                                height: 60,
                                width: 60,
                                alignment: Alignment.bottomCenter,
                                margin: EdgeInsets.fromLTRB(0,10,0,0),
                                child: TextButton(
                                  onPressed:(){
                                    setState(() {
                                      myid = "Color.WHITE"; //my id
                                      if(coundownValue == 0){
                                          selectedTimeVarian = 1;
                                          addtime = 0;
                                          addtimeFish = 0;
                                          coundownValue = 60;
                                          coundownValueFish = 60;
                                      }
                                    });

                                    const twentyMillis = const Duration(seconds: 1);
                                    Timer(twentyMillis, (){
                                      if(fen.split(' ').length == 6 && fen.split(' ')[1].toLowerCase() == 'w'){
                                        _controllerTier1.onRestart!();
                                        _controllerTier2.onRestart!();
                                        _controllerTier1.onPause!();
                                        _controllerTier2.onPause!();
                                        controller.game.load(_controllerFen.text != ''? _controllerFen.text : controller.game.fen);
                                        controller.refreshBoard();
                                        stockfish.state.value == StockfishState.disposed ?stockfish = Stockfish() : null;
                                        _subscribe();
                                      }else if(fen.split(' ').length == 6 && fen.split(' ')[1].toLowerCase() == 'b'){
                                        _controllerTier1.onRestart!();
                                        _controllerTier2.onRestart!();
                                        _controllerTier1.onPause!();
                                        _controllerTier2.onPause!();
                                        controller.game.load(_controllerFen.text != '' ? _controllerFen.text : controller.game.fen);
                                        controller.refreshBoard();
                                        stockfish.state.value == StockfishState.disposed ?  stockfish = Stockfish() : null;
                                        _subscribe();
                                        const twentyMillis = const Duration(seconds: 2);
                                        Timer(
                                            twentyMillis, () => stockfish.stdin = 'position fen ${_controllerFen.text != '' ? _controllerFen.text : controller.game.fen} \nd\ngo movetime $timeToStockFish');

                                      }else{
                                        _controllerTier1.onRestart!();
                                        _controllerTier2.onRestart!();
                                        _controllerTier1.onPause!();
                                        _controllerTier2.onPause!();
                                        controller.game.load(controller.game.fen);
                                        controller.refreshBoard();
                                        stockfish.state.value == StockfishState.disposed ?stockfish = Stockfish() : null;
                                        _subscribe();

                                      }
                                    });
                                  } ,
                                  child: WhiteKing(size: 40),
                                  style: ElevatedButton.styleFrom(
                                    primary: Color(0xFFFFFFFF),
                                    minimumSize: Size(60, 60),

                                  ),
                                ),
                              ),
                              //: Container(),
                              Container(
                                height: 60,
                                width: 80,
                                alignment: Alignment.bottomCenter,
                                margin: EdgeInsets.fromLTRB(0,10,0,0),
                                child: TextButton(
                                  onPressed:(){
                                    var rng = Random().nextInt(2);
                                    if(rng == 1) {
                                      setState(() {
                                        myid = "Color.BLACK"; //my id
                                        if(coundownValue == 0){
                                          selectedTimeVarian = 1;
                                          addtime = 0;
                                          addtimeFish = 0;
                                          coundownValue = 60;
                                          coundownValueFish = 60;
                                        }
                                      });
                                      const twentyMillis = const Duration(seconds: 1);
                                      Timer(twentyMillis, (){
                                        if(fen.split(' ').length == 6 && fen.split(' ')[1].toLowerCase() == 'b'){
                                          _controllerTier1.onRestart!();
                                          _controllerTier2.onRestart!();
                                          _controllerTier1.onPause!();
                                          _controllerTier2.onPause!();
                                          controller.game.load(_controllerFen.text != ''? _controllerFen.text : controller.game.fen);
                                          controller.refreshBoard();
                                          stockfish.state.value == StockfishState.disposed ?stockfish = Stockfish() : null;
                                          _subscribe();

                                        }else if(fen.split(' ').length == 6 && fen.split(' ')[1].toLowerCase() == 'w'){
                                          _controllerTier1.onRestart!();
                                          _controllerTier2.onRestart!();
                                          _controllerTier1.onPause!();
                                          _controllerTier2.onPause!();
                                          controller.game.load(_controllerFen.text != '' ? _controllerFen.text : controller.game.fen);
                                          controller.refreshBoard();
                                          stockfish.state.value == StockfishState.disposed ?  stockfish = Stockfish() : null;
                                          _subscribe();
                                          const twentyMillis = const Duration(seconds: 2);
                                          Timer(
                                              twentyMillis, () => stockfish.stdin = 'position fen ${_controllerFen.text != '' ? _controllerFen.text : controller.game.fen} \nd\ngo movetime $timeToStockFish');

                                        }else{
                                          _controllerTier1.onRestart!();
                                          _controllerTier2.onRestart!();
                                          _controllerTier1.onPause!();
                                          _controllerTier2.onPause!();
                                          controller.game.load(controller.game.fen);
                                          controller.refreshBoard();
                                          stockfish.state.value == StockfishState.disposed ? stockfish = Stockfish() : null;
                                          _subscribe();
                                          const twentyMillis = const Duration(seconds: 2);
                                          Timer(
                                              twentyMillis, () => stockfish.stdin = 'position fen ${controller.game.fen} \nd\ngo movetime $timeToStockFish');

                                        }
                                      });
                                    }else{
                                      setState(() {
                                        myid = "Color.WHITE"; //my id
                                        if(coundownValue == 0){
                                          selectedTimeVarian = 1;
                                          addtime = 0;
                                          addtimeFish = 0;
                                          coundownValue = 60;
                                          coundownValueFish = 60;
                                        }
                                      });
                                      const twentyMillis = const Duration(seconds: 1);
                                      Timer(twentyMillis, (){
                                        if(fen.split(' ').length == 6 && fen.split(' ')[1].toLowerCase() == 'w'){
                                          _controllerTier1.onRestart!();
                                          _controllerTier2.onRestart!();
                                          _controllerTier1.onPause!();
                                          _controllerTier2.onPause!();
                                          controller.game.load(_controllerFen.text != ''? _controllerFen.text : controller.game.fen);
                                          controller.refreshBoard();
                                          stockfish.state.value == StockfishState.disposed ?stockfish = Stockfish() : null;
                                          _subscribe();

                                        }else if(fen.split(' ').length == 6 && fen.split(' ')[1].toLowerCase() == 'b'){
                                          _controllerTier1.onRestart!();
                                          _controllerTier2.onRestart!();
                                          _controllerTier1.onPause!();
                                          _controllerTier2.onPause!();
                                          controller.game.load(_controllerFen.text != '' ? _controllerFen.text : controller.game.fen);
                                          controller.refreshBoard();
                                          stockfish.state.value == StockfishState.disposed ?  stockfish = Stockfish() : null;
                                          _subscribe();
                                          const twentyMillis = const Duration(seconds: 2);
                                          Timer(
                                              twentyMillis, () => stockfish.stdin = 'position fen ${_controllerFen.text != '' ? _controllerFen.text : controller.game.fen} \nd\ngo movetime $timeToStockFish');

                                        }else{
                                          _controllerTier1.onRestart!();
                                          _controllerTier2.onRestart!();
                                          _controllerTier1.onPause!();
                                          _controllerTier2.onPause!();
                                          controller.game.load(controller.game.fen);
                                          controller.refreshBoard();
                                          stockfish.state.value == StockfishState.disposed ?stockfish = Stockfish() : null;
                                          _subscribe();

                                        }
                                      });
                                    }


                                  } ,
                                  child: Text('RAND', style: TextStyle(fontSize: 17.0 , color: Color(0xFF000000), fontFamily: 'Open Sans'),),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.grey,
                                    minimumSize: Size(80, 60),

                                  ),
                                ),
                              ),
                              //fen.split(' ').length == 6 && fen.split(' ')[1].toLowerCase() == 'b' ?
                              Container(
                                height: 60,
                                width: 60,
                                alignment: Alignment.bottomCenter,
                                margin: EdgeInsets.fromLTRB(0,10,0,0),
                                child: TextButton(
                                  onPressed:(){
                                    setState(() {
                                      myid = "Color.BLACK"; //my id
                                      if(coundownValue == 0){
                                        selectedTimeVarian = 1;
                                        addtime = 0;
                                        addtimeFish = 0;
                                        coundownValue = 60;
                                        coundownValueFish = 60;
                                      }
                                    });
                                    const twentyMillis = const Duration(seconds: 1);
                                    Timer(twentyMillis, (){
                                      if(fen.split(' ').length == 6 && fen.split(' ')[1].toLowerCase() == 'b'){
                                        _controllerTier1.onRestart!();
                                        _controllerTier2.onRestart!();
                                        _controllerTier1.onPause!();
                                        _controllerTier2.onPause!();
                                        controller.game.load(_controllerFen.text != ''? _controllerFen.text : controller.game.fen);
                                        controller.refreshBoard();
                                        stockfish.state.value == StockfishState.disposed ?stockfish = Stockfish() : null;
                                        _subscribe();

                                      }else if(fen.split(' ').length == 6 && fen.split(' ')[1].toLowerCase() == 'w'){
                                        _controllerTier1.onRestart!();
                                        _controllerTier2.onRestart!();
                                        _controllerTier1.onPause!();
                                        _controllerTier2.onPause!();
                                        controller.game.load(_controllerFen.text != '' ? _controllerFen.text : controller.game.fen);
                                        controller.refreshBoard();
                                        stockfish.state.value == StockfishState.disposed ?  stockfish = Stockfish() : null;
                                        _subscribe();
                                        const twentyMillis = const Duration(seconds: 2);
                                        Timer(
                                            twentyMillis, () => stockfish.stdin = 'position fen ${_controllerFen.text != '' ? _controllerFen.text : controller.game.fen} \nd\ngo movetime $timeToStockFish');

                                      }else{
                                        _controllerTier1.onRestart!();
                                        _controllerTier2.onRestart!();
                                        _controllerTier1.onPause!();
                                        _controllerTier2.onPause!();
                                        controller.game.load(controller.game.fen);
                                        controller.refreshBoard();
                                        stockfish.state.value == StockfishState.disposed ?stockfish = Stockfish() : null;
                                        _subscribe();
                                        const twentyMillis = const Duration(seconds: 2);
                                        Timer(
                                            twentyMillis, () => stockfish.stdin = 'position fen ${controller.game.fen} \nd\ngo movetime $timeToStockFish');
                                      }
                                    });
                                  } ,
                                  child: BlackKing(size: 40),
                                  style: ElevatedButton.styleFrom(
                                    primary: Color(0xFFffffff),
                                    minimumSize: Size(60, 60),
                                  ),
                                ),
                              )
                              //: Container(),
                            ]),
                        SizedBox(height: 50,)
                      ])


                ],
              ),
            )));
  }

  void _subscribe() {
    subscription = stockfish.stdout.listen((line) {
      //print(line);
      if (line.startsWith('bestmove')) {
        //print('${line.split(' ')[1][0]}${line.split(' ')[1][1]}');
        controller.makeMove('${line.split(' ')[1][0]}${line.split(' ')[1][1]}', '${line.split(' ')[1][2]}${line.split(' ')[1][3]}');
        _controllerTier2.onStart!(); //остановили таймер
        _controllerTier1.onPause!();
        controller.refreshBoard();
      }
    });
  }


  String _printDuration(Duration duration, viewType) {
    timeToStockFish = duration.inSeconds.toString(); ///передаем время роботу стокфишу
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    String twoDigitMicroSeconds = twoDigits(duration.inMilliseconds.remainder(1000));
    ///return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds.$twoDigitMicroSeconds"; with microseconds
    if(viewType == 1) {
      return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    }else if(viewType == 2) {
      return "$twoDigitMinutes:$twoDigitSeconds";
    }
    return '';
  }




}