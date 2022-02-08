import 'dart:convert';
import 'package:chess_/partnerselect.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

List gameList = [];

class gamePage extends StatefulWidget {
  const gamePage({Key? key, required this.title, required this.token, required this.nick}) : super(key: key);

  final String title;
  final String token;
  final String nick;

  @override
  State<gamePage> createState() => _gamePageState();
}

class _gamePageState extends State<gamePage> {

  TextEditingController _controllerFen = TextEditingController(text: '');

  FocusNode myFocusNode2 = FocusNode();
  void _requestFocus2(){
    setState(() {
      FocusScope.of(context).requestFocus(myFocusNode2);
    });
  }

  @override
  void initState(){
    pushInstall();
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        automaticallyImplyLeading: false,
        leading: GestureDetector(
            onTap: () {
              Navigator.pushReplacement(context,
                  CupertinoPageRoute(builder: (context) => partnerSelectPage(title: 'Выбор партнера', )));
            },
            child: Icon(Icons.arrow_back)),
      ),
      body: Container(
        child: Column(
            children: [

              gameList.length > 0 ? ListView.builder(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: gameList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                        onTap: () {},
                        child: Container(
                          margin: EdgeInsets.fromLTRB(20,0,20,0),
                          padding: EdgeInsets.fromLTRB(10,5,5,5),
                          width: MediaQuery.of(context).size.width - 60,
                          height: 50,
                          decoration: BoxDecoration(color: Colors.white,),
                          alignment: Alignment.centerLeft,
                          child: Text('${gameList[index]['fen']}',style: TextStyle(fontSize: 17.0 , color: Color(0xFF444444), fontFamily: 'Open Sans'),textAlign: TextAlign.left,),
                        )
                    );
                  }):Container(),
              Container(
                  margin: const EdgeInsets.fromLTRB(16,25,16,0),
                  padding: const EdgeInsets.fromLTRB(0,0,0,0),
                  alignment: Alignment.topCenter,
                  width: MediaQuery.of(context).size.width - 40,
                  child:TextFormField(
                    onTap: _requestFocus2,
                    cursorColor: Colors.black,
                    focusNode: myFocusNode2,
                    textAlign: TextAlign.left,
                    enabled: true,
                    style: TextStyle(fontSize: 16, color: Colors.black),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(
                          left: 15, top: 18, bottom: 18
                      ),

                      hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
                      hintText: "Имя в игре",
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
                    onChanged: (_){setState(() {
                      username = _controllerFen.text;
                    });},
                    autovalidateMode: AutovalidateMode.always,
                    controller: _controllerFen,
                  )),
            ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){sendFen();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),


    );
  }

  @override
  void dispose() {
    super.dispose();
  }

//отправляем фен в чат партнеру или партнерам если поставить массив токенов
  sendFen()async{
    await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {"Content-Type": "application/json", "Authorization":"key=AAAAmlmyhlQ:APA91bFADxFaR20YXSehRNvP9TXlOdPTDXvcSe3hqU2OxnLp1vdD0nOaOysSRZddaWR8GtX2nIMi1oXirp0MTrsGDWjOJ8VefH9tsG0QEgeWn79GfXtT3mM7ZPdlG7xkZkyjq64f3DNq"},
        body: jsonEncode(<String, dynamic>{
          "to" : widget.token,
          "notification" : {"title" : "Игрок $username сделал ход" , "body" : "Перейти в приложение", "sound" : "default", "badge" : "1"},
          "priority" : "high",
          "data" : {"click_action" : "FLUTTER_NOTIFICATION_CLICK", "id" : "1", "status" : "fen", "fen" : _controllerFen.text, "answer" : userToken, "side" : "black", "time" : DateTime.now().toString()}
        })
    ).then((response) async {
      print(response.body);
      gameList.add({"fen" : _controllerFen.text});
      _controllerFen.clear();
      FocusScope.of(context).unfocus();
      setState(() {

      });
    });
  }


//настроили обработку событий при поступлении пушей
  pushInstall()async{

    ///обработчик в открытом приложении
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('message111111');
        gameList.add({"fen" : message.data['fen']});
      if (mounted) {
        setState(() {

        });
      }
    });


  }


}