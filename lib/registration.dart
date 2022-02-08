
import 'package:chess_/utils/dialogscreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'constants.dart';

class regPage extends StatefulWidget {
  const regPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<regPage> createState() => _regPageState();
}

class _regPageState extends State<regPage> {
  var maskFormatterPhone = MaskTextInputFormatter(mask: '+7 ### ###-##-##', filter: { "#": RegExp(r'[0-9]') });
  final TextEditingController _controllerNick = TextEditingController(text: '');
  final TextEditingController _controllerFio = TextEditingController(text: '');
  final TextEditingController _controllerEmail = TextEditingController(text: '');
  final TextEditingController _controllerPhone = TextEditingController(text: '');

  FocusNode myFocusNode1 = FocusNode();
  void _requestFocus1(){
    setState(() {
      FocusScope.of(context).requestFocus(myFocusNode1);
    });
  }

  FocusNode myFocusNode2 = FocusNode();
  void _requestFocus2(){
    setState(() {
      FocusScope.of(context).requestFocus(myFocusNode2);
    });
  }
  FocusNode myFocusNode3 = FocusNode();
  void _requestFocus3(){
    setState(() {
      FocusScope.of(context).requestFocus(myFocusNode3);
    });
  }
  FocusNode myFocusNode4 = FocusNode();
  void _requestFocus4(){
    setState(() {
      FocusScope.of(context).requestFocus(myFocusNode4);
    });
  }

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: GestureDetector(
        onTap: () {
          setState(() {
            FocusScope.of(context).requestFocus(new FocusNode());
          });
        }, child:SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.fromLTRB(16,16,16,16),
              padding: const EdgeInsets.fromLTRB(0,0,0,0),
              alignment: Alignment.topCenter,
              width: MediaQuery.of(context).size.width - 40,
              child:Text(
                  'Придумайте себе имя в играх и укажите как можно больше данных о себе, партнерам легче будет вас найти, а мы сможем восстановить вам доступ после переустановки приложения',
                  textAlign: TextAlign.left
              ),),
            Container(
                margin: const EdgeInsets.fromLTRB(16,16,16,0),
                padding: const EdgeInsets.fromLTRB(0,0,0,0),
                alignment: Alignment.topCenter,
                width: MediaQuery.of(context).size.width - 40,
                child:TextFormField(
                  onTap: _requestFocus1,
                  cursorColor: Colors.black,
                  focusNode: myFocusNode1,
                  textAlign: TextAlign.left,
                  enabled: true,
                  style: TextStyle(fontSize: 16, color: Colors.black),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(
                        left: 15, top: 18, bottom: 18
                    ),

                    hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
                    hintText: "Имя в игре",
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(3.0)),
                        borderSide: BorderSide(color: Colors.grey, width: 1)),
                    focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(3.0)),
                        borderSide: BorderSide(color: Colors.grey, width: 1)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(3.0),
                      borderSide: BorderSide(color: Colors.grey, width: 1),
                    ),
                  ),
                  onChanged: (_){setState(() {
                    username = _controllerNick.text;
                  });},
                  autovalidateMode: AutovalidateMode.always,
                  controller: _controllerNick,
                )),
            Container(
                margin: const EdgeInsets.fromLTRB(16,16,16,0),
                padding: const EdgeInsets.fromLTRB(0,0,0,0),
                alignment: Alignment.topCenter,
                width: MediaQuery.of(context).size.width - 40,
                child:TextFormField(
                  onTap: _requestFocus2,
                  cursorColor: Colors.black,
                  focusNode: myFocusNode2,
                  textAlign: TextAlign.left,
                  enabled: true,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(
                        left: 15, top: 18, bottom: 18
                    ),

                    hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
                    hintText: "Реальное имя",
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(3.0)),
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
                    fio = _controllerFio.text;
                  });},
                  autovalidateMode: AutovalidateMode.always,
                  controller: _controllerFio,
                )),
            Container(
                margin: const EdgeInsets.fromLTRB(16,16,16,0),
                padding: const EdgeInsets.fromLTRB(0,0,0,0),
                alignment: Alignment.topCenter,
                width: MediaQuery.of(context).size.width - 40,
                child:TextFormField(
                  keyboardType: TextInputType.phone,
                  inputFormatters: [maskFormatterPhone],
                  onTap: _requestFocus3,
                  cursorColor: Colors.black,
                  focusNode: myFocusNode3,
                  textAlign: TextAlign.left,
                  enabled: true,
                  style: TextStyle(fontSize: 16, color: Colors.black),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(
                        left: 15, top: 18, bottom: 18
                    ),

                    hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
                    hintText: "Номер телефона",
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(3.0)),
                        borderSide: BorderSide(color: Colors.grey, width: 1)),
                    focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(3.0)),
                        borderSide: BorderSide(color: Colors.grey, width: 1)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(3.0),
                      borderSide: const BorderSide(color: Colors.grey, width: 1),
                    ),
                  ),
                  onChanged: (_){setState(() {
                    phone = _controllerPhone.text;
                  });},
                  autovalidateMode: AutovalidateMode.always,
                  controller: _controllerPhone,
                )),
            Container(
                margin: const EdgeInsets.fromLTRB(16,16,16,0),
                padding: const EdgeInsets.fromLTRB(0,0,0,0),
                alignment: Alignment.topCenter,
                width: MediaQuery.of(context).size.width - 40,
                child:TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  onTap: _requestFocus4,
                  cursorColor: Colors.black,
                  focusNode: myFocusNode4,
                  textAlign: TextAlign.left,
                  enabled: true,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(
                        left: 15, top: 18, bottom: 18
                    ),

                    hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
                    hintText: "E-mail",
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(3.0)),
                        borderSide: BorderSide(color: Colors.grey, width: 1)),
                    focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(3.0)),
                        borderSide: BorderSide(color: Colors.grey, width: 1)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(3.0),
                      borderSide: const BorderSide(color: Colors.grey, width: 1),
                    ),
                  ),
                  //onChanged: (_){},
                  onEditingComplete: (){
                    setState(() {
                      email = _controllerEmail.text;
                    });
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _controllerEmail,
                  validator: validateEmail,
                )),


            Container(
              margin: const EdgeInsets.fromLTRB(16,16,16,0),
              padding: const EdgeInsets.fromLTRB(0,0,0,0),
              height: 50,
              width: MediaQuery.of(context).size.width - 40,
              alignment: Alignment.center,
              child: TextButton(
                onPressed:(){
                  if(_controllerNick.text == ''){
                    dialogScreen(context, 'Укажите ваш псевдоним в играх');
                  }else if(_controllerEmail.text == ''){
                    dialogScreen(context, 'Для восстановления доступа потребуется ваш E-mail!');
                  }else {
                    getToken(context, username, _controllerEmail.text);
                  }
                } ,
                child: const Text('Запомнить',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                  textAlign: TextAlign.center,) ,
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  minimumSize: Size(MediaQuery.of(context).size.width - 40, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(16,30,16,0),
              padding: const EdgeInsets.fromLTRB(0,0,0,0),
              alignment: Alignment.topCenter,
              width: MediaQuery.of(context).size.width - 40,
              child:const Text(
                  'Введите любые данные указанные ранее при регистрации и мы восстановим вам доступ к приложению, после ввода кода присланного на e-mail прежней регистрации',
                  textAlign: TextAlign.left
              ),),
            Container(
              margin: const EdgeInsets.fromLTRB(16,16,16,0),
              padding: const EdgeInsets.fromLTRB(0,0,0,0),
              height: 50,
              width: MediaQuery.of(context).size.width - 40,
              alignment: Alignment.center,
              child: TextButton(
                onPressed:(){
                  if(_controllerNick.text == '' && _controllerFio.text == '' && _controllerEmail.text == '' && _controllerPhone.text == ''){
                    dialogScreen(context, 'Для восстановления доступа нужны хоть какие то данные!');
                  }else{
                    restoreAccess(context,_controllerEmail.text);
                  }
                } ,
                child: const Text('Восстановить доступ',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                  textAlign: TextAlign.center,) ,
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  minimumSize: Size(MediaQuery.of(context).size.width - 40, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
              ),
            ),


          ],
        ),
      ),
      ),
    );
  }




}