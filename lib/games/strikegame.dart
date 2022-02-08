import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:chess_/chessboard/src/board_square.dart';
import 'package:chess_/chessboard/src/chess_board.dart';
import 'package:chess_/chessboard/src/chess_board_controller.dart';
import 'package:chess_/games/staterwidget.dart';
import 'package:chess_/partnerselect.dart';
import 'package:chess_/utils/dialogscreen.dart';
import 'package:chess_/utils/prolongdialog.dart';
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:chess/chess.dart' as chess;
import '../constants.dart';
import '../selectfirst.dart';
import '../servicefunctions.dart';


var from;
var to;

int levelup = 1100;
int leveldown = 1000;

List validMoves = [];
int _skillLevel = 0;
String title = '';
bool loadGameProcess = false;
int counter = 0;
bool side = true;

int countMoves = 0;
String moveStatus = '';
Map _SQUARES = {
  'a8':   0, 'b8':   1, 'c8':   2, 'd8':   3, 'e8':   4, 'f8':   5, 'g8':   6, 'h8':   7,
  'a7':  16, 'b7':  17, 'c7':  18, 'd7':  19, 'e7':  20, 'f7':  21, 'g7':  22, 'h7':  23,
  'a6':  32, 'b6':  33, 'c6':  34, 'd6':  35, 'e6':  36, 'f6':  37, 'g6':  38, 'h6':  39,
  'a5':  48, 'b5':  49, 'c5':  50, 'd5':  51, 'e5':  52, 'f5':  53, 'g5':  54, 'h5':  55,
  'a4':  64, 'b4':  65, 'c4':  66, 'd4':  67, 'e4':  68, 'f4':  69, 'g4':  70, 'h4':  71,
  'a3':  80, 'b3':  81, 'c3':  82, 'd3':  83, 'e3':  84, 'f3':  85, 'g3':  86, 'h3':  87,
  'a2':  96, 'b2':  97, 'c2':  98, 'd2':  99, 'e2': 100, 'f2': 101, 'g2': 102, 'h2': 103,
  'a1': 112, 'b1': 113, 'c1': 114, 'd1': 115, 'e1': 116, 'f1': 117, 'g1': 118, 'h1': 119
};

Map _SQUARES_BLACK = {
  'a8': 119, 'b8': 118, 'c8': 117, 'd8': 116, 'e8': 115, 'f8': 114, 'g8': 113, 'h8':   112,
  'a7':  103, 'b7':  102, 'c7':  101, 'd7':  100, 'e7': 99, 'f7': 98, 'g7': 97, 'h7':  96,
  'a6':  87, 'b6':  86, 'c6':  85, 'd6':  84, 'e6':  83, 'f6':  82, 'g6':  81, 'h6':  80,
  'a5':  71, 'b5':  70, 'c5':  69, 'd5':  68, 'e5':  67, 'f5':  66, 'g5':  65, 'h5':  64,
  'a4':  55, 'b4':  54, 'c4':  53, 'd4':  52, 'e4':  51, 'f4':  50, 'g4':  49, 'h4':  48,
  'a3':  39, 'b3':  38, 'c3':  37, 'd3':  36, 'e3':  35, 'f3':  34, 'g3':  33, 'h3':  32,
  'a2':  23, 'b2':  22, 'c2':  21, 'd2':  20, 'e2':  19, 'f2':  18, 'g2':  17, 'h2': 16,
  'a1':   7, 'b1':   6, 'c1':   5, 'd1':   4, 'e1':   3, 'f1':   2, 'g1':   1, 'h1': 0
};

var _whiteSquareList = ["a8","b8", "c8", "d8", "e8", "f8", "g8", "h8", "a7", "b7", "c7", "d7", "e7", "f7", "g7", "h7", "a6", "b6", "c6", "d6", "e6", "f6", "g6", "h6", "a5", "b5", "c5", "d5", "e5", "f5", "g5", "h5", "a4", "b4", "c4", "d4", "e4", "f4", "g4", "h4", "a3", "b3", "c3", "d3", "e3", "f3", "g3", "h3", "a2", "b2", "c2", "d2", "e2", "f2", "g2", "h2", "a1", "b1", "c1", "d1", "e1", "f1", "g1", "h1"];
double _top = 0.0;
double _left = 0.0;
class strikeGamePage extends StatefulWidget {
  //const randomGamePage({Key? key, required this.title, required this.token, required this.nick}) : super(key: key);

  //final String title;
  //final String token;
  //final String nick;

  @override
  State<strikeGamePage> createState() => strikeGamePageState();
}

class strikeGamePageState extends State<strikeGamePage> {


  late ChessBoardController controller;
  late final CountdownController _controllerStatus = CountdownController(
      autoStart: false);

  //загрузка рандомной игры
  checkArives() async {
    setState(() {
      _skillLevel = 0;
      title = '';
      canMoves = [];
      moveStatus = '';
      countMoves = 0;
      loadGameProcess = true;
    });
    print(leveldown);
    await http.post(
        Uri.parse('https://chess.koldashev.ru/ChessAPI.php'),
        headers: {"Accept": "application/json"},
        body: jsonEncode(<String, dynamic>{
          "levelup": levelup,
          "leveldown": leveldown,
          "subject": "strikegame"
        })
    ).then((response) async {
      //print(response.body);
      var jsonR = response.body;
      var parsedJson = json.decode(jsonR);
      //parsedJson = json.decode('{"number" : "28Qs2","fen" : "8/P3qpk1/6p1/1P6/K1Q4P/8/8/8 w - - 1 57","moves" : "c4c5 e7c5 a7a8q c5c4","skilllevel" : 2204,"title" : "crushing endgame queenEndgame short" }');
      //print(parsedJson);
      _skillLevel = parsedJson['skilllevel'];
      side = parsedJson['fen'].split(' ')[1] == 'b' ? true : false;
      validMoves = parsedJson['moves'].split(' ');
      print(validMoves);
      for (int i = 0; i < typesGames.length; i++) {
        parsedJson['title'].split(' ')[0] == typesGames[i]['type'] ?
        title = typesGames[i]['description'] : null;
      }
      loadGameProcess = false;

      ///write game to BD
      games.add(parsedJson['number']);
      crashGame = parsedJson['number'];
setState(() {

});

      const twentyMillis = Duration(seconds: 1);

      Timer(twentyMillis, () {
        controller.game.load(parsedJson['fen']);
        canMoves.add("${validMoves[countMoves].substring(0, 2)}");
        canMoves.add("${validMoves[countMoves].substring(2, 4)}");

        controller.game.move({
          "from": "${validMoves[countMoves].substring(0, 2)}",
          "to": "${validMoves[countMoves].substring(2, 4)}"
        });
        countMoves++;
        controller.refreshBoard();
        _controllerStatus.onStart!();
      });
    });
  }


  @override
  void initState() {
    super.initState();
    controller = ChessBoardController();
    checkArives();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Игра страйк'),
        automaticallyImplyLeading: false,
        leading: GestureDetector(
            onTap: () {
              fio != '' ? writeSkill(games, '', '', counter, 0, '') : null;
              counter = 0;
              canMoves = [];

              Navigator.pushReplacement(context,
                  CupertinoPageRoute(
                      builder: (context) => firstSelectPage(title: 'Выбор',)));
            },
            child: Icon(Icons.arrow_back)),
      ),
      body: SingleChildScrollView(
        child: Column(
            children: [
              SizedBox(height: 20,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                    children: [
                      Text(
                          'Сложность задачи: ',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.left
                      ),
                      Text(
                          '$_skillLevel',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.left
                      ),
                    ]),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'Суть задачи: ',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.left
                      ),
                      Expanded(child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.left
                      ),
                      ),
                    ]),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'Примечание: ',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.left
                      ),
                      Expanded(child: Text(
                          'Неверный ход обнуляет баллы и переводит в следующую партию',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.left
                      ),
                      ),
                    ]),
              ),
              Stack(
                  children: [

                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: ChessBoard(
                        size: MediaQuery
                            .of(context)
                            .size
                            .width,
                        onMove: (moveNotation) {
                          //print('====');
                          for (int i = 0; i < controller.game
                              .generate_moves()
                              .length; i++) {
                            //print(controller.game.generate_moves()[i].to);
                          }
                          //print(moveNotation);
                          //print(controller.game.history.first.move.toAlgebraic);
                          //print(controller.game.history.first.move.from);
                          //print(controller.game.history.first.move.to);
                          from = _SQUARES.keys.firstWhere(
                                  (k) =>
                              _SQUARES[k] == controller.game.history.last.move
                                  .from, orElse: () => null);
                          to = _SQUARES.keys.firstWhere(
                                  (k) =>
                              _SQUARES[k] == controller.game.history.last.move
                                  .to, orElse: () => null);
                          //print('$from$to');
                          if (validMoves[countMoves].substring(0, 4) ==
                              '$from$to') {
                            canMoves = [];
                            print('Правильный ход');
                            moveStatus = 'Правильный ход ';

                            ///отобразить в истории ходов
                            countMoves < validMoves.length - 1
                                ? countMoves++
                                : null;
                            canMoves.add("${validMoves[countMoves].substring(0,
                                2)}");
                            canMoves.add("${validMoves[countMoves].substring(2,
                                4)}");
                            //print({"from" : "${validMoves[countMoves].substring(0, 2)}", "to" : "${validMoves[countMoves].substring(2, 4)}"});
                            controller.game.move({
                              "from": "${validMoves[countMoves].substring(
                                  0, 2)}",
                              "to": "${validMoves[countMoves].substring(2, 4)}"
                            });
                            controller.refreshBoard();
                            //});
                            //sqName = '';
                            if (countMoves == validMoves.length - 1) {
                              print('Задача решена');

                              ///прибавить балл и перейти к следующей задаче
                              _skillLevel = 0;
                              title = '';
                              loadGameProcess = false;
                              side = true;
                              validMoves = [];
                              countMoves = 0;
                              moveStatus = '';
                              counter++;
                              levelup = levelup + 50;
                              leveldown = leveldown + 50;
                              dialogProlongScreen(context, 'Задача решена! Продолжить с компьютером?', side, controller.game.fen).then(
                                  (v){
                                    print(v);
                                    //dialogScreen(context, 'Задача решена!').then((v) {
                                    v == null ?  checkArives() : null;
                                   // });
                                  }
                              );
                              /*dialogScreen(context, 'Задача решена!').then((v) {
                                checkArives();
                              });*/
                            } else {
                              countMoves++;
                            }
                          }
                          else {
                            //controller.game.undo_move();
                            ///отобразить в истории ходов неверный и верный ход
                            print('Неверный ход $from$to');
                            canMoves = [];
                            moveStatus =
                            'Неверный ход, лучше было пойти ${validMoves[countMoves]}';
                            //canMoves.add("${validMoves[countMoves].substring(0, 2)}");
                            //canMoves.add("${validMoves[countMoves].substring(2, 4)}");
                            //print(canMoves);
                            //sqName = '';
                            //controller.refreshBoard();
                            _skillLevel = 0;
                            title = '';
                            loadGameProcess = false;
                            side = true;
                            validMoves = [];
                            countMoves = 0;
                            moveStatus = '';
                            levelup = levelup - 50;
                            leveldown = leveldown - 50;
                            fio != '' ? writeSkill(
                                games, crashGame, '$from$to', 0, countMoves,
                                controller.game.san_moves().toString()) : null;
                            games = [];
                            counter = 0;
                            dialogScreen(context, 'Ошибка!').then((v) {
                              checkArives();
                            });
                            //const twentyMillis = const Duration(seconds:2);
                            //new Timer(twentyMillis, () => checkArives());
                          }
                        },
                        onCheckMate: (winColor) {
                          //dialogScreen(context, '${winColor} Поставлен мат!');
                        },
                        onDraw: () {
                          //dialogScreen(context, 'Ничья!');
                        },
                        chessBoardController: controller,
                        whiteSideTowardsUser: side,
                        onCheck: (PieceColor color) {
                          //dialogScreen(context, 'Шах!');
                        },

                      ),
                    ),
                    AnimatedPositioned(
                      //width: selected ? 200.0 : 50.0,
                      //height: selected ? 50.0 : 200.0,
                      top: _top - MediaQuery
                          .of(context)
                          .size
                          .width / 8,
                      left: _left - MediaQuery
                          .of(context)
                          .size
                          .width / 8,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.fastOutSlowIn,
                      child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          //child: SizedBox( width: 10, height:10, child: Container(color: Colors.red)))
                          child: WhitePawn(size: MediaQuery
                              .of(context)
                              .size
                              .width / 8)),
                    ),

                  ]
              ),

              SizedBox(height: 20,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                    children: [
                      staterWidget(
                        controller: _controllerStatus,
                        build: (_, String value) =>
                            Text(
                                value,
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.left
                            ),
                      ),
                    ]),
              ),
              loadGameProcess == true ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    Text(
                        'Готовим задачу',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.left
                    ),

                  ]) :

              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                        '$counter',
                        style: TextStyle(
                          fontSize: 56,
                        ),
                        textAlign: TextAlign.left
                    ),
                    Text(
                        'Набрано баллов',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.left
                    ),

                  ]),
            ]),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

}
