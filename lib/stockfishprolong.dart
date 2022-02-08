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

class stockFishProlong extends StatefulWidget{
  stockFishProlong({
    required this.recivedFen,
    required this.side
});
  final String recivedFen;
  final bool side;

  @override
  State<StatefulWidget> createState() {
    return stockFishProlongState();
  }
}

class stockFishProlongState extends State<stockFishProlong>{



  String timeToStockFish = '0';
  late Stockfish stockfish;
  late StreamSubscription subscription; ///my add

  late ChessBoardController controller;
  //late CountdownController _controllerTier1 = CountdownController(autoStart: false);
  //late CountdownController _controllerTier2 = CountdownController(autoStart: false);
  List<String> gameMoves = [];
  var flipBoardOnMove = true;
  late TextEditingController _controllerFen;

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
    _controllerFen = TextEditingController(text: widget.recivedFen);
print(widget.recivedFen);
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
              title: const Text('Продолжение с компьютером'),
              actions: [],
            ),
            body: SingleChildScrollView(
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10,),
                  ///таймер для робота

                  ///таймер в игре для робота
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:[


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
                        //_controllerTier2.onPause!(); //остановили таймер
                        //_controllerTier1.onStart!();
                        //print(('position fen ${controller.game.fen} moves ${moveNotation}\nd\ngo movetime $timeToStockFish'));
                        stockfish.stdin = 'position fen ${controller.game.fen} moves ${moveNotation}\nd\ngo movetime 10';
                      },
                      onCheckMate: (winColor) {
                        if(stockfish.state.value != StockfishState.disposed) {
                          stockfish.stdin = 'stop';
                          stockfish.stdin = 'quit';
                          //_controllerTier1.onRestart!();
                          //_controllerTier2.onRestart!();
                          //_controllerTier1.onPause!();
                          //_controllerTier2.onPause!();
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
                          //_controllerTier1.onRestart!();
                          //_controllerTier2.onRestart!();
                          //_controllerTier1.onPause!();
                          //_controllerTier2.onPause!();
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
                      whiteSideTowardsUser: widget.side,
                      onCheck: (PieceColor color) {},

                    ),
                  ),

                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:[

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
                          //_controllerTier1.onRestart!();
                          //_controllerTier2.onRestart!();
                          //_controllerTier1.onPause!();
                          //_controllerTier2.onPause!();
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


TextButton(
  onPressed: () {
            !widget.side ? myid = "Color.WHITE" :  myid = "Color.BLACK"; //my id
            if(coundownValue == 0){
            selectedTimeVarian = 1;
            addtime = 0;
            addtimeFish = 0;
            coundownValue = 60;
            coundownValueFish = 60;
            }

            const twentyMillis = const Duration(seconds: 1);
        Timer(twentyMillis, (){
      if(widget.recivedFen.split(' ').length == 6 && widget.recivedFen.split(' ')[1].toLowerCase() == 'b'){
        //_controllerTier1.onRestart!();
        //_controllerTier2.onRestart!();
        //_controllerTier1.onPause!();
        //_controllerTier2.onPause!();
        controller.game.load(widget.recivedFen);
        controller.refreshBoard();
        stockfish.state.value == StockfishState.disposed ?stockfish = Stockfish() : null;
        _subscribe();

      }else if(widget.recivedFen.split(' ').length == 6 && widget.recivedFen.split(' ')[1].toLowerCase() == 'w'){
        //_controllerTier1.onRestart!();
        //_controllerTier2.onRestart!();
        //_controllerTier1.onPause!();
        //_controllerTier2.onPause!();
        controller.game.load(widget.recivedFen);
        controller.refreshBoard();
        stockfish.state.value == StockfishState.disposed ?  stockfish = Stockfish() : null;
        _subscribe();
        const twentyMillis = const Duration(seconds: 2);
        Timer(
            twentyMillis, () => stockfish.stdin = 'position fen ${widget.recivedFen} \nd\ngo movetime 10');

      }else{
        //_controllerTier1.onRestart!();
        //_controllerTier2.onRestart!();
        //_controllerTier1.onPause!();
        //_controllerTier2.onPause!();
        controller.game.load(widget.recivedFen);
        controller.refreshBoard();
        stockfish.state.value == StockfishState.disposed ?stockfish = Stockfish() : null;
        _subscribe();
        const twentyMillis = const Duration(seconds: 2);
        Timer(
            twentyMillis, () => stockfish.stdin = 'position fen ${widget.recivedFen} \nd\ngo movetime 10');
      }
    });},
  child: Text('Начать'),


)
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
        //_controllerTier2.onStart!(); //остановили таймер
        //_controllerTier1.onPause!();
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