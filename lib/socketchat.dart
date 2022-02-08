import 'dart:async';
import 'dart:convert';
import 'package:chess_/utils/dialogscreen.dart';
import 'package:chess_/utils/gamenotif.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:web_socket_channel/io.dart';
import 'chessboard/src/chess_board.dart';
import 'chessboard/src/chess_board_controller.dart';
import 'constants.dart';


var _timer = 500;

class ChatPage extends StatefulWidget{
  late final String owner;
  late final String arrived;
  late final String token;
  late final String player1;
  late final String player2;
  late final int status;


  ChatPage({
    required this.owner,
    required this.arrived,
    required this.token,
    required this.player1,
    required this.player2,
    required this.status
  });



  @override
  State<StatefulWidget> createState() {
    return ChatPageState();
  }
}

class ChatPageState extends State<ChatPage>{
bool partnerOnline = false;
  late ChessBoardController controller;
  final CountdownController _controllerTier1 = CountdownController(autoStart: false);
  final CountdownController _controllerTier2 = CountdownController(autoStart: false);
  TextEditingController msgtext = TextEditingController();
  List<String> gameMoves = [];
  var flipBoardOnMove = true;
  late IOWebSocketChannel channel; //channel varaible for websocket
  late bool connected; // boolean value to track connection status

  String myid = ''; //my id
  String recieverid = ""; //reciever id
// swap myid and recieverid value on another mobile to test send and recieve
  String auth = "chatapphdfgjd34534hjdfk"; //auth key


  @override
  void dispose() {
    super.dispose();
  }



  Future<bool> _onBackPressed() {
    return Future.value(false); //если есть предыдущая страница
  }




  @override
  void initState() {
    connected = false;
    msgtext.text = "";
    super.initState();
    controller = ChessBoardController();
    channelconnect();
    if(widget.status != id) {

      const twentyMillis = Duration(seconds: 3);
      Timer(twentyMillis, () =>
          sendmsg('ready', widget.owner,)); //шлем партнеру что мы вошли в чат
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressed,
        child:Scaffold(
        appBar: AppBar(
          title: Text(myid == "" ? "Игра с соперником" : "Поехали"),
          leading: GestureDetector(onTap: (){
            gameProceedScreen(context, 'Вы прекращаете игру?', widget.owner, widget.arrived, widget.token, widget.player1, widget.player2, widget.status);
          }, child:Icon(CupertinoIcons.chevron_left, size: 25, color: Colors.white)),
          actions: [
            CircularProgressIndicator()
          ],
          titleSpacing: 0,
        ),
        body: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children:[
                  Countdown(
                  controller: _controllerTier1,
                  seconds: _timer,
                  build: (_, double time) => Text(
                    //time.toString(),
                    '${_printDuration(Duration(milliseconds: (time*1000).toInt()), 1)}',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                      textAlign: TextAlign.left
                  ),
                  interval: Duration(milliseconds: 100),
                  onFinished: () {
                    dialogScreen(context, 'Время соперника закончилось');
                    cancelArrive(context, widget.owner, widget.arrived, widget.token);
                    //ScaffoldMessenger.of(context).showSnackBar(
                     // SnackBar(
                     //   content: Text('Timer is done!'),
                     // ),
                    //);
                  },
                ),
                    Text(
                      //time.toString(),
                        '${widget.player1}',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.left
                    ),
                ]),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: ChessBoard(
                    size: MediaQuery.of(context).size.width,
                    onMove: (moveNotation) {
                      if(controller.game.generate_fen().split(' ')[1] == (myid == "Color.WHITE" ? 'w' : 'b')){controller.game.undo();}else {
                        print(controller.game.generate_fen().split(' ')[1] ==
                            (myid == "Color.WHITE" ? 'b' : 'w'));
                        gameMoves.add(moveNotation);
                        controller.game.load(
                            controller.game.fen); //загружаем фен
                        sendmsg(controller.game.fen,
                            widget.owner); //шлем партнеру наш фен
                        _controllerTier2.onPause!(); //остановили таймер
                        _controllerTier1.onStart!();
                      }
                    },
                    onCheckMate: (winColor) {
                      dialogScreen(context, '${winColor} Поставлен мат!');
                      _controllerTier2.onPause!(); //остановили таймер
                      _controllerTier1.onPause!();
                      cancelArrive(context, widget.owner, widget.arrived, widget.token);
                    },
                    onDraw: () {
                    },
                    chessBoardController: controller,
                    whiteSideTowardsUser: myid == "Color.WHITE" ? true : false,
                    //enableUserMoves: controller.game.generate_fen().split(' ')[1] == (myid == "Color.WHITE" ? 'w' : 'b') ,
                    onCheck: (PieceColor color) {
                      dialogScreen(context, '${color} Поставлен шах!');
                    },

                  ),
                ),
               Row(
                 children: [
                 Countdown(
                  controller: _controllerTier2,
                  seconds: _timer,
                  build: (_, double time) => Text(
                    //time.toString(),
                    '${_printDuration(Duration(milliseconds: (time*1000).toInt()),2)}',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                      textAlign: TextAlign.left
                  ),
                  interval: Duration(milliseconds: 100),
                  onFinished: () {
                    dialogScreen(context, 'Ваше время закончилось');
                    cancelArrive(context, widget.owner, widget.arrived, widget.token);
                    //ScaffoldMessenger.of(context).showSnackBar(
                    //  SnackBar(
                    //    content: Text('Timer is done!'),
                    //  ),
                    //);
                  },
                ),
                   Text(
                     //time.toString(),
                       '${username}',
                       style: TextStyle(
                         fontSize: 16,
                       ),
                       textAlign: TextAlign.left
                   ),
                ]),
                myid == "" && widget.owner != id && partnerOnline == true ? Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.bottomCenter,
                  margin: EdgeInsets.fromLTRB(0,10,0,0),
                  child: TextButton(
                    onPressed:(){
                      dialog(context);
                    } ,
                    child: Text('Выбор фигуры', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF000000)),textAlign: TextAlign.center),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFFFFFFFF),
                      minimumSize: Size(MediaQuery.of(context).size.width, 20),

                    ),
                  ),
                ) : Container(child: Text('Ждем подключения второго игрока', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF000000)),textAlign: TextAlign.center),),
                //Text('кому шлем ${widget.arrived} кто зачинщик ${widget.status} ')
            ],)
        )
    ));
  }
  //send xod
  Future<void> sendmsg(String sendmsg, String id,) async {
    if(connected == true){
      String msg = "{'auth':'$auth','cmd':'send','userid':'$id', 'msgtext':'$sendmsg', 'canmove' : true}";
      channel.sink.add(msg); //send message to reciever channel
    }else{
      channelconnect();
      print("Websocket is not connected.");
    }
  }
  //byld connect
  channelconnect(){ //function to connect
    try{
      //channel = IOWebSocketChannel.connect("ws://185.251.90.147:6060/$myid", //127.0.0.1 //10.0.2.2
          channel = IOWebSocketChannel.connect("ws://185.251.90.147:6060/${widget.arrived}", //127.0.0.1 //10.0.2.2
          headers: {'Connection': 'upgrade', 'Upgrade': 'websocket'}); //channel IP : Port
      channel.stream.listen((message) {
        print(message);
        if(message == "connected"){
          connected = true;
          //setState(() { });
          print("Connection establised.");
        }else if(message == "send:success"){
          print("Message send success");
        }else if(message == "send:error"){
          print("Message send error");

        }else if (message.substring(0, 6) == "{'cmd'") {
          print("Message data");
          message = message.replaceAll(RegExp("'"), '"');
          var jsondata = json.decode(message);
          print(jsondata["msgtext"].split(' ')[0]);
if(jsondata["msgtext"] == 'ready') {
  setState(() {
    partnerOnline = true;
  });

}else if(jsondata["msgtext"].split(' ')[0]=='startfen'){

  //sendmsg('startfen ${controller.game.fen} color white time $_timer',widget.owner);
  var temp =jsondata["msgtext"].split(' ');
  myid = temp[1] == 'white' ? "Color.WHITE" : "Color.BLACK";
  _timer = int.parse(temp[5]);
  setState(() {

  });
  controller.game.load(temp[1].replaceAll('+', ' '));
  controller.refreshBoard();
}else {
  controller.game.load(jsondata["msgtext"]);
  controller.refreshBoard();
  _controllerTier2.onStart!(); //остановили таймер
  _controllerTier1.onPause!();
}
        }
      },
        onDone: () {
          //if WebSocket is disconnected
          print("Web socket is closed");
          connected = false;
        },
        onError: (error) {
          print(error.toString());
        },);
    }catch (_){
      print("error on connecting to websocket.");
    }
  }
  String _printDuration(Duration duration, timer) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    String twoDigitMicroSeconds = twoDigits(duration.inMilliseconds.remainder(1000));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds.$twoDigitMicroSeconds";
  }
  dialog(var context,){
    return showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.transparent,
        builder: (context) {
          return AlertDialog(
              backgroundColor: Colors.grey.withOpacity(0.5),
              contentPadding: EdgeInsets.fromLTRB(0, 0, 0 , 0),
              insetPadding: EdgeInsets.all(0),
              elevation: 0.0,
              content:Container(
                color: Colors.transparent,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                alignment: Alignment.center,
                child: Container(
                    width: 300,
                    //height: 250
                    height: 207,
                    margin: EdgeInsets.fromLTRB(20,20,20,20),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xFFFFFFFF),
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(16.5),
                      color: Color(0xFFFFFFFF),
                    ),
                    padding: EdgeInsets.fromLTRB(20,20,20,20),
                    child:  Column(
                        children: <Widget>[
                          Text("Ваши фигуры?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF333333)),textAlign: TextAlign.center),
                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:[
                          Container(
                            height: 40,
                            width: 100,
                            alignment: Alignment.bottomCenter,
                            margin: EdgeInsets.fromLTRB(0,10,0,0),
                            child: TextButton(
                              onPressed:(){
                                setState(() {
                                  myid = "Color.WHITE"; //my id
                                  recieverid = "Color.BLACK";
                                });
                                //channelconnect();
                                sendmsg('startfen ${controller.game.fen.replaceAll(' ', '+')} color white time $_timer',widget.owner);
                                Navigator.of(context).pop();
                              } ,
                              child: Text('Белые', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF000000)),textAlign: TextAlign.center),
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xFFFFFFFF),
                                minimumSize: Size(MediaQuery.of(context).size.width, 20),

                              ),
                            ),
                          ),
                          Container(
                            height: 40,
                            width: 100,
                            alignment: Alignment.bottomCenter,
                            margin: EdgeInsets.fromLTRB(0,10,0,0),
                            child: TextButton(
                              onPressed:(){
                                setState(() {
                                  myid = "Color.BLACK"; //my id
                                  recieverid = "Color.WHITE";
                                });
                                //channelconnect();
                                sendmsg('startfen ${controller.game.fen.replaceAll(' ', '+')} color black time $_timer',widget.owner);
                                Navigator.of(context).pop();
                              } ,
                              child: Text('Черные', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFFFFFFFF)),textAlign: TextAlign.center),
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xFF000000),
                                minimumSize: Size(MediaQuery.of(context).size.width, 20),

                              ),
                            ),
                          ),
                              ])
                        ])

                ),
              )
          );
        });

  }



}


