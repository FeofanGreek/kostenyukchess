import 'package:chess_/games/randomgame.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_chess_board/src/board_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:async';
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';
import 'package:chess/chess.dart' as chess;

import 'board_model.dart';

String sqName = '';
String sqPiece = '';
var sqColor;
///список всех клеток на доске
var _whiteSquareList = ["a8","b8", "c8", "d8", "e8", "f8", "g8", "h8", "a7", "b7", "c7", "d7", "e7", "f7", "g7", "h7", "a6", "b6", "c6", "d6", "e6", "f6", "g6", "h6", "a5", "b5", "c5", "d5", "e5", "f5", "g5", "h5", "a4", "b4", "c4", "d4", "e4", "f4", "g4", "h4", "a3", "b3", "c3", "d3", "e3", "f3", "g3", "h3", "a2", "b2", "c2", "d2", "e2", "f2", "g2", "h2", "a1", "b1", "c1", "d1", "e1", "f1", "g1", "h1"];
List canMoves = [];


/// A single square on the chessboard
class BoardSquare extends StatelessWidget {
  /// The square name (a2, d3, e4, etc.)
  final squareName;

  BoardSquare({this.squareName});

  markContainer(label){
    bool mark = false;
    for(int i=0; i < canMoves.length; i++){
      label == canMoves[i] ? mark = true : null;
    }
    return mark;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<BoardModel>(builder: (context, _, model) {
      return Expanded(
        flex: 1,
        child: DragTarget(builder: (context, accepted, rejected) {
          return model.game.get(squareName) != null
              ? GestureDetector(
              onTap: ()async{
                ///отработаем доступные ходы по тап
                ///пробежимся по всей доске и составим массив доступных ходов
                if(sqName == squareName){
                  sqName = '';
                  canMoves = [];
                  model.refreshBoard();
                }///снимаем нажатие
                else if(sqName != '' && sqName != squareName ){
                  canMoves = [];
                  /// пробуем заводской вариант
                  chess.Color moveColor = model.game.turn;
                  if (sqPiece == "P" &&
                      ((sqName[1] == "7" &&
                          squareName[1] == "8" &&
                          sqColor  == chess.Color.WHITE) ||
                          (sqName[1] == "2" &&
                              squareName[1] == "1" &&
                              sqColor == chess.Color.BLACK))) {
                    var val = await _promotionDialog(context);
                    if (val != null) {
                      model.game.move(
                          {"from": sqName, "to": squareName, "promotion": val});
                    } else {
                      return;
                    }
                  } else{
                    model.game.move({"from": sqName, "to": squareName});
                  }
                  if (model.game.turn != moveColor) {
                    model.onMove(
                        sqPiece == "P" ? squareName : sqPiece + squareName);
                  }
                  model.refreshBoard(); /// Обновляем доску
                  sqName = '';
                }else {
                  sqName = squareName;
                  print(squareName);
                  sqPiece = model.game.get(squareName)!.type.toUpperCase();
                  sqColor = model.game.get(squareName)!.color;
                  canMoves = [];

                  for(int i =0; i < _whiteSquareList.length; i++) {
                    if(model.game.move({"from": sqName, "to": _whiteSquareList[i], "promotion": ''})) {
                      canMoves.add(_whiteSquareList[i]);
                      model.game.undo_move();
                    }
                  }
                  model.refreshBoard();
                }
                }, /// по тапу я знаю клетку
              child:Draggable(
                  child: Container(
                      decoration: BoxDecoration(
                      border: Border.all(
                        width: 3,
                          color: sqName == squareName ? Colors.blueGrey.withOpacity(0.8)  : markContainer(squareName) == true ? Colors.red.withOpacity(0.8) : Colors.transparent,
                      ),
                      borderRadius: BorderRadius.all(
                                      Radius.circular(5.0)),
                  ),
                      child: _getImageToDisplay(size: model.size / 8, model: model,)), ///фигура которую тащим
                  feedback: _getImageToDisplay(
                      size: (1.2 * (model.size / 8)), model: model),
                  onDragCompleted: () {
                    //canMoves = [];
                    sqName = '';
                  },
                onDragUpdate: (v){
                  sqName = squareName;
                  sqPiece = model.game.get(squareName)!.type.toUpperCase();
                  sqColor = model.game.get(squareName)!.color;
                  canMoves = [];
                  for(int i =0; i < _whiteSquareList.length; i++) {
                    if(model.game.move({"from": sqName, "to": _whiteSquareList[i], "promotion": ''})) {
                      canMoves.add(_whiteSquareList[i]);
                      model.game.undo_move();
                    }
                  }
                },
                  data: [
                    squareName,
                    model.game.get(squareName)!.type.toUpperCase(),
                    model.game.get(squareName)!.color,
                  ],
                ))
              : GestureDetector(
              onTap: ()async{
                ///отработаем доступные ходы по тап
                ///пробежимся по всей доске и составим массив доступных ходов
                if(sqName != '' && sqName != squareName ){
                  canMoves = [];
                  /// пробуем заводской вариант
                  // A way to check if move occurred.
                  chess.Color moveColor = model.game.turn;
                  if (sqPiece == "P" &&
                      ((sqName[1] == "7" &&
                          squareName[1] == "8" &&
                          sqColor  == chess.Color.WHITE) ||
                          (sqName[1] == "2" &&
                              squareName[1] == "1" &&
                              sqColor == chess.Color.BLACK))) {
                    var val = await _promotionDialog(context);
                    if (val != null) {
                      model.game.move(
                          {"from": sqName, "to": squareName, "promotion": val});
                      model.refreshBoard();
                    } else {
                      return;
                    }
                  } else{
                    model.game.move({"from": sqName, "to": squareName});
                  }
                  if (model.game.turn != moveColor) {
                    model.onMove(
                        sqPiece == "P" ? squareName : sqPiece + squareName);
                  }
                  model.refreshBoard(); /// Обновляем доску
                  sqName = '';
                }else {
                  sqName = squareName;
                  print(squareName);
                  model.game.get(squareName) != null ? sqPiece = model.game.get(squareName)!.type.toUpperCase() : null;
                  model.game.get(squareName) != null ? sqColor = model.game.get(squareName)!.color : null;
                  canMoves = [];
                  for(int i =0; i < _whiteSquareList.length; i++) {
                    if(model.game.move({"from": sqName, "to": _whiteSquareList[i], "promotion": ''})) {
                      canMoves.add(_whiteSquareList[i]);
                      model.game.undo_move();
                    }
                  }
                  model.refreshBoard();
                }
              }, /// по тапу я знаю клетку
          child:Container(
            color: Colors.transparent,
              child: Container(
                margin: const EdgeInsets.fromLTRB(16,16,16,16),
            width: 20,
            height: 20,
                decoration: BoxDecoration(
                  color: markContainer(squareName) == true ? Colors.green.withOpacity(0.8) : Colors.transparent,
                  borderRadius: BorderRadius.all(
                      Radius.circular(10.0)),
                ),
          )));
        },
        onWillAccept: (willAccept) {
          return model.enableUserMoves ? true : false;
        },
        onAccept: (List moveInfo) async {
          // A way to check if move occurred.
          //print(moveInfo[0]);//откуда
          from = moveInfo[0];/// !!!!!!!!!
          //print(squareName);//куда
          to = squareName;///!!!!!!!!!!!
          chess.Color moveColor = model.game.turn;
          if (moveInfo[1] == "P" &&
              ((moveInfo[0][1] == "7" &&
                      squareName[1] == "8" &&
                      moveInfo[2] == chess.Color.WHITE) ||
                  (moveInfo[0][1] == "2" &&
                      squareName[1] == "1" &&
                      moveInfo[2] == chess.Color.BLACK))) {
            var val = await _promotionDialog(context);
            if (val != null) {
              model.game.move(
                  {"from": moveInfo[0], "to": squareName, "promotion": val});
              model.refreshBoard();
            } else {
              return;
            }
          } else {
            model.game.move({"from": moveInfo[0], "to": squareName});
          }
          if (model.game.turn != moveColor) {
            model.onMove(
                moveInfo[1] == "P" ? squareName : moveInfo[1] + squareName);
          }

          model.refreshBoard();
        }),
      );
    });
  }

  /// Show dialog when pawn reaches last square Диалог смены фигуры при достижении пешкой края
  Future<String?> _promotionDialog(BuildContext context) async {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Во что превращаемся?'),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              InkWell(
                child: WhiteQueen(),
                onTap: () {
                  Navigator.of(context).pop("q");
                },
              ),
              InkWell(
                child: WhiteRook(),
                onTap: () {
                  Navigator.of(context).pop("r");
                },
              ),
              InkWell(
                child: WhiteBishop(),
                onTap: () {
                  Navigator.of(context).pop("b");
                },
              ),
              InkWell(
                child: WhiteKnight(),
                onTap: () {
                  Navigator.of(context).pop("n");
                },
              ),
            ],
          ),
        );
      },
    ).then((value) {
      return value;
    });
  }

  /// Get image to display on square
  Widget _getImageToDisplay({required double size, required BoardModel model}) {
    Widget imageToDisplay = Container(

    );

    if (model.game.get(squareName) == null) {
      return Container(

      );
    }

    String piece =
        (model.game.get(squareName)!.color == chess.Color.WHITE ? 'W' : 'B') +
            model.game.get(squareName)!.type.toUpperCase();

    switch (piece) {
      case "WP":
        imageToDisplay = WhitePawn(size: size); ///окрашиваем фигуру
        break;
      case "WR":
        imageToDisplay =WhiteRook(size: size);
        break;
      case "WN":
        imageToDisplay = WhiteKnight(size: size);
        break;
      case "WB":
        imageToDisplay = WhiteBishop(size: size);
        break;
      case "WQ":
        imageToDisplay = WhiteQueen(size: size);
        break;
      case "WK":
        imageToDisplay = WhiteKing(size: size);
        break;
      case "BP":
        imageToDisplay = BlackPawn(size: size);
        break;
      case "BR":
        imageToDisplay =  BlackRook(size: size);
        break;
      case "BN":
        imageToDisplay = BlackKnight(size: size);
        break;
      case "BB":
        imageToDisplay = BlackBishop(size: size);
        break;
      case "BQ":
        imageToDisplay = BlackQueen(size: size);
        break;
      case "BK":
        imageToDisplay = BlackKing(size: size);
        break;
      default:
        imageToDisplay = WhitePawn(size: size);
    }

    return imageToDisplay;
  }
}
