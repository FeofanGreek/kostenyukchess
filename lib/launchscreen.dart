import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:chess_/constants.dart';
import 'package:chess_/registration.dart';
import 'package:chess_/signtest.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'constants.dart';

class launchScreen extends StatefulWidget {

  @override
  _LaunchScreenState createState() => _LaunchScreenState();
}


class _LaunchScreenState extends State<launchScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  readProfile() async {
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File fileL = File('${directory.path}/profile.txt');
      var UfromFile = await fileL.readAsString();
      var nameUs = json.decode(UfromFile);
      username = nameUs['nick'];
      userToken = nameUs['token'];
      fio = nameUs['fio'];
      email = nameUs['email'];
      phone = nameUs['phone'];
      id = nameUs['id'];
      print(id);
      //настроили обработку событий при поступлении пушей
      pushInstall(context).then((v){
        //проверяем наличие приглашений
        checkArives(_scaffold.currentContext, email);

      });

    } catch (error) {
      print(error);
      //редиректимся на экран регистрации
      const twentyMillis = Duration(seconds:2);
      //Timer(twentyMillis, () => Navigator.pushReplacement (context,
      //    CupertinoPageRoute(builder: (context) => const regPage(title: 'Регистрация'))));
      Timer(twentyMillis, () => Navigator.pushReplacement (context,
          CupertinoPageRoute(builder: (context) => SignInDemo())));
    }
  }



  @override
  void initState() {
    super.initState();
    readProfile();
  }//initState
  GlobalKey _scaffold = GlobalKey();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return Scaffold(
      key: _scaffold,
      backgroundColor: Color(0xFFffffff),
      body:Container(
        height: MediaQuery.of(context).size.height, width: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Color.fromRGBO(229, 229, 229, 1),

            image: DecorationImage(
                image: AssetImage("images/chess-getty.jpeg"),
                fit:BoxFit.fitHeight, alignment: Alignment(0.0, 0.0)
          ),
        ),

        child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 50,),
              Center(
                child:Text('Шахматы\n', style: TextStyle(fontSize: 20.0, color: Colors.white, fontFamily: 'Open Sans',fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
              ),
              Center(
                child:Text('Версия: 1.0.0\n', style: TextStyle(fontSize: 15.0, color: Colors.white, fontFamily: 'Open Sans'),textAlign: TextAlign.center,),
              ),
              Center(
                child:Container(
                    width: 15.0,
                    height: 15.0,
                    margin: EdgeInsets.fromLTRB(10,0,0,0),
                    child:CircularProgressIndicator(strokeWidth: 2.0,
                      valueColor : AlwaysStoppedAnimation(Colors.red),)),
              ),
            ]),
      ),
    );
  }
}
