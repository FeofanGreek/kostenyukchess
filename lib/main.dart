import 'package:chess_/signtest.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'constants.dart';
import 'game.dart';
import 'launchscreen.dart';

///RemoteMessage? initialMessage;

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  ///print("приложение выключено статус: ${message.data['status']}"); //сюда пихаем фен
  //print(message.notification!.title);
  //print(message.notification!.body);
  //gameList.add({"fen" : message.data['fen']});
  /*if(message.data['status'] == 1){
    way = 1;
    partner = message.data['partner'];
    partnerToken = message.data['partnerToken'];
    color = message.data['color'];
  }else if(message.data['status'] == 3){
    gameList.add({"fen" : message.data['fen']});
  }*/

}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
      title: 'Шахматы',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: launchScreen(),
      //home: SignInDemo()
      //  home:stockFish()
    );
  }
}


