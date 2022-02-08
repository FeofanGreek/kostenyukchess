import 'dart:async';
import 'dart:convert';
import 'package:chess/chess.dart' as Chess;
import 'package:chess_/analitics/replay.dart';
import 'package:chess_/chessboard/src/chess_board.dart';
import 'package:chess_/chessboard/src/chess_board_controller.dart';
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

int _countMoves = 0;

class errorCard extends StatefulWidget {
  const errorCard({Key? key, required this.title, required this.id, required this.game}) : super(key: key);

  final Map game;
  final String title;
  final int id;

  @override
  State<errorCard> createState() => _errorCardState();
}

class _errorCardState extends State<errorCard> {
  ChessBoardController _controller = ChessBoardController();



  movesView(List movies){
    List moveToScreen = [];
    for(int i=0; i < movies.length; i++){
      i % 2 != 0 ? moveToScreen.add(movies[i]):null;
    }
    return moveToScreen;
  }

  @override
  void initState(){
    super.initState();
    const twentyMillis = Duration(milliseconds: 100);
    Timer(twentyMillis, () => _controller.game.load(widget.game['game']['fen']));
    Timer(twentyMillis, () => _controller.refreshBoard());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          setState(() {
            FocusScope.of(context).requestFocus(new FocusNode());
          });
        }, child:Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(widget.title),
          actions: [],
        ),
        body: Container(
            child:Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children:[
                                              ChessBoard(
                                                size: MediaQuery.of(context).size.width,
                                                enableUserMoves: false,
                                                chessBoardController: _controller,
                                                whiteSideTowardsUser: widget.game['game']['fen'].split(' ')[1] == 'b' ? true : false,
                                                onCheckMate: (PieceColor color) {  },
                                                onMove: (String moveNotation) {  },
                                                onCheck: (PieceColor color) {  },
                                                onDraw: () {  },
                                              ),
                                              SizedBox(width: 20),

                                                        Text('${widget.game['datetime']}',style: TextStyle(fontSize: 12.0 , color: Colors.black, fontFamily: 'Open Sans'),textAlign: TextAlign.left,),
                                                        Expanded( child:Text('Ошибка на ${widget.game['movenumber']} ходу, пошел  ${widget.game['crashmove']}, должен был пойти ${widget.game['game']['moves'].split(' ')[int.parse(widget.game['movenumber'])]}',style: TextStyle(fontSize: 12.0 , color: Colors.black, fontFamily: 'Open Sans'),textAlign: TextAlign.left,)),
                                                        //Row(children: generatePieces(_parsedJsonPaysList[index]['game']['moves'].split(' '), _parsedJsonPaysList[index]['game']['fen'])),
                                                        Text('Правильное решение: ${widget.game['game']['moves']}',style: TextStyle(fontSize: 12.0 , color: Colors.black, fontFamily: 'Open Sans'),textAlign: TextAlign.left,),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                            children:[
                                                              Container(
                                                                alignment: Alignment.center,
                                                                child: TextButton(
                                                                  onPressed:(){
                                                                    //_controllers[index].game.move({"from" : "${_parsedJsonPaysList[index]['game']['moves'].split(' ')[_countMoves[index]].substring(0, 2)}", "to" : "${_parsedJsonPaysList[index]['game']['moves'].split(' ')[_countMoves[index]].substring(2, 4)}"});
                                                                    _countMoves > 0 ? _countMoves-- : null;
                                                                    _controller.game.undo_move();
                                                                    _controller.refreshBoard();
                                                                    //print(_controllers[index].game.ascii);
                                                                  } ,
                                                                  child: Icon(Icons.arrow_back_rounded, color: Colors.white, size: 25),
                                                                  style: ElevatedButton.styleFrom(
                                                                    primary: Colors.blue,
                                                                    minimumSize: Size(25, 25),
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(4.0),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                alignment: Alignment.center,
                                                                child: TextButton(
                                                                  onPressed:(){
                                                                    _controller.game.move({"from" : "${widget.game['game']['moves'].split(' ')[_countMoves].substring(0, 2)}", "to" : "${widget.game['game']['moves'].split(' ')[_countMoves].substring(2, 4)}"});
                                                                    _countMoves <  widget.game['game']['moves'].split(' ').length - 1 ? _countMoves++ : null;
                                                                    _controller.refreshBoard();
                                                                    //print(_controllers[index].game.ascii);

                                                                  } ,
                                                                  child: Icon(Icons.arrow_forward, color: Colors.white, size: 25),
                                                                  style: ElevatedButton.styleFrom(
                                                                    primary: Colors.blue,
                                                                    minimumSize: Size(25, 25),
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(4.0),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ]),
                                                        Text('Ваше решение: ${widget.game['san']}',style: TextStyle(fontSize: 12.0 , color: Colors.black, fontFamily: 'Open Sans'),textAlign: TextAlign.left,),

                                              Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children:[
                                                              Container(
                                                                alignment: Alignment.center,
                                                                child: TextButton(
                                                                  onPressed:(){
                                                                    //_controllers[index].game.move({"from" : "${_parsedJsonPaysList[index]['game']['moves'].split(' ')[_countMoves[index]].substring(0, 2)}", "to" : "${_parsedJsonPaysList[index]['game']['moves'].split(' ')[_countMoves[index]].substring(2, 4)}"});
                                                                    _countMoves > 0 ? _countMoves-- : null;
                                                                    _controller.game.undo_move();
                                                                    _controller.refreshBoard();
                                                                    //print(_controllers[index].game.ascii);
                                                                  } ,
                                                                  child: Icon(Icons.arrow_back_rounded, color: Colors.white, size: 25),
                                                                  style: ElevatedButton.styleFrom(
                                                                    primary: Colors.red,
                                                                    minimumSize: Size(25, 25),
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(4.0),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                alignment: Alignment.center,
                                                                child: TextButton(
                                                                  onPressed:(){
                                                                    print(widget.game['movenumber']);
                                                                    _countMoves == int.parse(widget.game['movenumber'])+1 ? _controller.game.move({"from" : "${widget.game['crashmove'].substring(0, 2)}", "to" : "${widget.game['crashmove'].substring(2, 4)}"}) : _controller.game.move({"from" : "${widget.game['game']['moves'].split(' ')[_countMoves].substring(0, 2)}", "to" : "${widget.game['game']['moves'].split(' ')[_countMoves].substring(2, 4)}"});
                                                                    _countMoves <  int.parse(widget.game['movenumber'])+1 ? _countMoves++ : null;
                                                                    _controller.refreshBoard();
                                                                    //print(_controllers[index].game.ascii);

                                                                  } ,
                                                                  child: Icon(Icons.arrow_forward, color: Colors.white, size: 25),
                                                                  style: ElevatedButton.styleFrom(
                                                                    primary: Colors.red,
                                                                    minimumSize: Size(25, 25),
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(4.0),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ]),
                                              GestureDetector(onTap:(){
                                                Navigator.push(context,
                                                    CupertinoPageRoute(builder: (context) => concreteGamePage(game: widget.game['game']['number'],)));
                                              },
                                                  child:Text('\nРешить заново',style: TextStyle(fontSize: 20.0 , color: Colors.blue, fontFamily: 'Open Sans'),textAlign: TextAlign.left,)),
SizedBox(height: 20,)
                                            ]
                                                  )



                                    ))


    );
  }

}