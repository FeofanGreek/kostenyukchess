import 'dart:async';
import 'dart:convert';
import 'package:chess/chess.dart' as Chess;
import 'package:chess_/chessboard/src/chess_board.dart';
import 'package:chess_/chessboard/src/chess_board_controller.dart';
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

import 'errorcard.dart';

var _parsedJsonPaysList;
List _countMoves = [];

class viewErrorsPage extends StatefulWidget {
  const viewErrorsPage({Key? key, required this.title, required this.id}) : super(key: key);

  final String title;
  final int id;

  @override
  State<viewErrorsPage> createState() => _viewErrorsPageState();
}

class _viewErrorsPageState extends State<viewErrorsPage> {
List<ChessBoardController> _controllers = [];
  //обновление страницы после возврата
  @override
  FutureOr onGoBack(dynamic value) {
    getErrors();
  }

  getErrors()async{
    try{
      var response = await http.post(Uri.parse('https://chess.koldashev.ru/ChessAPI.php'),
          headers: {"Accept": "application/json"},
          body: jsonEncode(<String, dynamic>{
            "player" : widget.id,
            //"player" : 16,
            "subject": "getErrors"
          })
      );
      print(response.body);
      var jsonStaffList = response.body;
      _parsedJsonPaysList = json.decode(jsonStaffList);
      setState(() {

      });
    } catch (error) {
      print(error);
    }
  }

  movesView(List movies){
    List moveToScreen = [];
    for(int i=0; i < movies.length; i++){
      i % 2 != 0 ? moveToScreen.add(movies[i]):null;
    }
    return moveToScreen;
  }

  /*getPieces(index){
    List<Widget> gamePieces =[];
    for(int i =0; i < _parsedJsonPaysList[index]['game']['moves'].length; i++) {
      _controllers[index].game.move({
        "from": "${_parsedJsonPaysList[index]['game']['moves'].split(
            ' ')[i].substring(0, 2)}",
        "to": "${_parsedJsonPaysList[index]['game']['moves'].split(
            ' ')[i].substring(2, 4)}"
      });
      _controllers[index].refreshBoard();
      _controllers[index].game.get(
          "${_parsedJsonPaysList[index]['game']['moves'].split(
              ' ')[i].substring(0, 2)}")==null? Container() :
      _controllers[index].game.get(
          "${_parsedJsonPaysList[index]['game']['moves'].split(
              ' ')[i].substring(0, 2)}")!.type == 'p'? gamePieces.add(WhitePawn(size: 20)) : _controllers[index].game.get(
          "${_parsedJsonPaysList[index]['game']['moves'].split(
              ' ')[i].substring(0, 2)}")!.type == 'r' ? gamePieces.add(WhiteRook(size: 20)) :_controllers[index].game.get(
          "${_parsedJsonPaysList[index]['game']['moves'].split(
              ' ')[i].substring(0, 2)}")!.type == 'n' ? gamePieces.add(WhiteKnight(size: 20)) :_controllers[index].game.get(
          "${_parsedJsonPaysList[index]['game']['moves'].split(
              ' ')[i].substring(0, 2)}")!.type == 'b' ? gamePieces.add(WhiteBishop(size: 20)) : _controllers[index].game.get(
          "${_parsedJsonPaysList[index]['game']['moves'].split(
              ' ')[i].substring(0, 2)}")!.type == 'q' ? gamePieces.add(WhiteQueen(size: 20)) : _controllers[index].game.get(
          "${_parsedJsonPaysList[index]['game']['moves'].split(
              ' ')[i].substring(0, 2)}")!.type == 'k' ? gamePieces.add(WhiteKing(size: 20)) : Container();
    }
    return gamePieces;
  }*/


  /*generatePieces(List movesList, String fen){
    List<Widget> pieces = [];
    Chess.Chess chess = Chess.Chess();
    chess.load(fen);
    for(int i=0; i< movesList.length; i++) {
      //print('position: ' + chess.fen);
      //print(chess.ascii);
      //print(movesList[i].substring(2, 4));
      var pieceType = chess.get(movesList[i].substring(0, 2))!.type.name;
      var moves = chess.moves();
      //print(moves);
      //moves.shuffle();
      var move = moves[0];
      for(int ii=0; ii<moves.length; ii++){
        moves[ii].contains(movesList[i].substring(2, 4)) ? move = moves[ii] : null;
      }
      //print('move: $move');
      chess.move(move);
      //chess.move({movesList[i].substring(0, 2),movesList[i].substring(2, 4)} );

      //print('move: ${pieceType.toUpperCase()}${movesList[i].substring(2, 4)}');
    }
    return pieces;
  }*/

  @override
  void initState(){
    super.initState();
    getErrors();
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
        body: SingleChildScrollView(
            child:Column(
                children:[

                  _parsedJsonPaysList != null ? ListView.builder(
                    reverse: true,
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _parsedJsonPaysList.length,
                      itemBuilder: (BuildContext context, int index) {
                        loadGame(index);
                        _countMoves.add(0);
                        return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                                elevation: 4.0,
                                child: InkWell(
                                    onTap: (){},
                                    splashColor: Colors.blue,
                                    child: Container(
                                        padding: EdgeInsets.fromLTRB(10,10,10,10),

                                        //width: MediaQuery.of(context).size.width - 60,
                                        height: 200,
                                        decoration: BoxDecoration(color: Colors.white,),
                                        alignment: Alignment.center,
                                        child:Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children:[
                                                    ChessBoard(
                                                      size: 150,
                                                      enableUserMoves: false,
                                                      chessBoardController: _controllers[index],
                                                      whiteSideTowardsUser: _parsedJsonPaysList[index]['game']['fen'].split(' ')[1] == 'b' ? true : false,
                                                      onCheckMate: (PieceColor color) {  },
                                                      onMove: (String moveNotation) {  },
                                                      onCheck: (PieceColor color) {  },
                                                      onDraw: () {  },
                                                    ),
                                                    SizedBox(width: 20),
                                                    Container(
                                                        width: 170,
                                                        child:Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                      children:[
                                                        Text('№$index :: ${_parsedJsonPaysList[index]['datetime']}',style: TextStyle(fontSize: 12.0 , color: Colors.black, fontFamily: 'Open Sans'),textAlign: TextAlign.left,),
                                                        //Text('Список ходов в задаче: ${movesView(_parsedJsonPaysList[index]['game']['moves'].split(' '))}',style: TextStyle(fontSize: 12.0 , color: Colors.black, fontFamily: 'Open Sans'),textAlign: TextAlign.left,),
                                                        //Expanded( child:Text('Ошибка на ${_parsedJsonPaysList[index]['movenumber']} ходу, пошел  ${_parsedJsonPaysList[index]['crashmove']}, должен был пойти ${_parsedJsonPaysList[index]['game']['moves'].split(' ')[int.parse(_parsedJsonPaysList[index]['movenumber'])]}',style: TextStyle(fontSize: 12.0 , color: Colors.black, fontFamily: 'Open Sans'),textAlign: TextAlign.left,)),
                                                        //Row(children: generatePieces(_parsedJsonPaysList[index]['game']['moves'].split(' '), _parsedJsonPaysList[index]['game']['fen'])),
                                                        //Text('${_parsedJsonPaysList[index]['san']}',style: TextStyle(fontSize: 12.0 , color: Colors.black, fontFamily: 'Open Sans'),textAlign: TextAlign.left,),
                                                        Text('Правильное решение',style: TextStyle(fontSize: 12.0 , color: Colors.black, fontFamily: 'Open Sans'),textAlign: TextAlign.left,),
                                                        Row(
                                                          children:[
                                                        Container(
                                                          alignment: Alignment.center,
                                                          child: TextButton(
                                                            onPressed:(){
                                                              //_controllers[index].game.move({"from" : "${_parsedJsonPaysList[index]['game']['moves'].split(' ')[_countMoves[index]].substring(0, 2)}", "to" : "${_parsedJsonPaysList[index]['game']['moves'].split(' ')[_countMoves[index]].substring(2, 4)}"});
                                                              _countMoves[index] > 0 ? _countMoves[index]-- : null;
                                                              _controllers[index].game.undo_move();
                                                              _controllers[index].refreshBoard();
                                                              //print(_controllers[index].game.ascii);
                                                            } ,
                                                            child: Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
                                                            style: ElevatedButton.styleFrom(
                                                              primary: Colors.blue,
                                                              minimumSize: Size(20, 20),
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
                                                              _controllers[index].game.move({"from" : "${_parsedJsonPaysList[index]['game']['moves'].split(' ')[_countMoves[index]].substring(0, 2)}", "to" : "${_parsedJsonPaysList[index]['game']['moves'].split(' ')[_countMoves[index]].substring(2, 4)}"});
                                                              _countMoves[index] <  _parsedJsonPaysList[index]['game']['moves'].split(' ').length - 1 ? _countMoves[index]++ : null;
                                                              _controllers[index].refreshBoard();
                                                              //print(_controllers[index].game.ascii);

                                                            } ,
                                                            child: Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                                                            style: ElevatedButton.styleFrom(
                                                              primary: Colors.blue,
                                                              minimumSize: Size(20, 20),
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(4.0),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                            ]),
                                                        Text('Ваше решение',style: TextStyle(fontSize: 12.0 , color: Colors.black, fontFamily: 'Open Sans'),textAlign: TextAlign.left,),
                                                        Row(
                                                            children:[
                                                              Container(
                                                                alignment: Alignment.center,
                                                                child: TextButton(
                                                                  onPressed:(){
                                                                    //_controllers[index].game.move({"from" : "${_parsedJsonPaysList[index]['game']['moves'].split(' ')[_countMoves[index]].substring(0, 2)}", "to" : "${_parsedJsonPaysList[index]['game']['moves'].split(' ')[_countMoves[index]].substring(2, 4)}"});
                                                                    _countMoves[index] > 0 ? _countMoves[index]-- : null;
                                                                    _controllers[index].game.undo_move();
                                                                    _controllers[index].refreshBoard();
                                                                    //print(_controllers[index].game.ascii);
                                                                  } ,
                                                                  child: Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
                                                                  style: ElevatedButton.styleFrom(
                                                                    primary: Colors.red,
                                                                    minimumSize: Size(20, 20),
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
                                                                    print(_parsedJsonPaysList[index]['movenumber']);
                                                                    _countMoves[index] == int.parse(_parsedJsonPaysList[index]['movenumber'])+1 ? _controllers[index].game.move({"from" : "${_parsedJsonPaysList[index]['crashmove'].substring(0, 2)}", "to" : "${_parsedJsonPaysList[index]['crashmove'].substring(2, 4)}"}) : _controllers[index].game.move({"from" : "${_parsedJsonPaysList[index]['game']['moves'].split(' ')[_countMoves[index]].substring(0, 2)}", "to" : "${_parsedJsonPaysList[index]['game']['moves'].split(' ')[_countMoves[index]].substring(2, 4)}"});
                                                                    _countMoves[index] <  int.parse(_parsedJsonPaysList[index]['movenumber'])+1 ? _countMoves[index]++ : null;
                                                                    _controllers[index].refreshBoard();
                                                                    //print(_controllers[index].game.ascii);

                                                                  } ,
                                                                  child: Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                                                                  style: ElevatedButton.styleFrom(
                                                                    primary: Colors.red,
                                                                    minimumSize: Size(20, 20),
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(4.0),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ]),
                                                        GestureDetector(onTap:(){
                                                          Navigator.push(context,
                                                              CupertinoPageRoute(builder: (context) => errorCard(title: 'Разбор ошибки', game: _parsedJsonPaysList[index], id: 1,)));
                                                        },
                                                            child:Text('\nПодробнее >',style: TextStyle(fontSize: 12.0 , color: Colors.blue, fontFamily: 'Open Sans'),textAlign: TextAlign.left,)),
                                                      ]
                                                    )
                                                    )

                                            ]),


                                ))));
                      }):Container(),
                ])
        )

    ));
  }

  loadGame(int index){
    const twentyMillis = Duration(milliseconds: 100);
    _controllers.add(ChessBoardController());
    Timer(twentyMillis, () => _controllers[index].game.load(_parsedJsonPaysList[index]['game']['fen']));
    Timer(twentyMillis, () => _controllers[index].refreshBoard());
  }


}