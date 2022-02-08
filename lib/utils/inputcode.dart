import 'package:flutter/material.dart';

import '../constants.dart';
import 'dialogscreen.dart';



inputcode(var context, String message, String email, String phone, String nick, String fio, String code, String id){
  TextEditingController _controllerCode = TextEditingController(text: '');
  return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Color(0xFF1D2830).withOpacity(0.2),
      builder: (context) {
        return AlertDialog(
            backgroundColor: Colors.transparent,
            contentPadding: EdgeInsets.fromLTRB(0, 0, 0 , 0),
            insetPadding: EdgeInsets.all(0),
            elevation: 0.0,
            content:Container(
              color: Colors.transparent,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              alignment: Alignment.center,
              child: Container(
                  width: 250,
                  height: 250,
                  margin: EdgeInsets.fromLTRB(20,20,20,20),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                      width: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(16.5),
                    color: Colors.grey[50],
                  ),
                  padding: EdgeInsets.fromLTRB(20,20,20,20),
                  child:  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[

                        Text(message, textAlign: TextAlign.center,
                          //style: appBarHeader,
                        ),
                        SizedBox(height: 10,),
                        Container(
                            margin: const EdgeInsets.fromLTRB(16,5,16,0),
                            padding: const EdgeInsets.fromLTRB(0,0,0,0),
                            alignment: Alignment.topCenter,
                            width: MediaQuery.of(context).size.width - 40,
                            child:TextFormField(
                              keyboardType: TextInputType.number,
                              //onTap: _requestFocus4,
                              cursorColor: Colors.black,
                              //focusNode: myFocusNode4,
                              textAlign: TextAlign.left,
                              enabled: true,
                              style: TextStyle(fontSize: 16, color: Colors.black),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(
                                    left: 15, top: 10, bottom: 10
                                ),

                                hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
                                hintText: "Код",
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
                              //onChanged: (_){},
                              onEditingComplete: (){
                                //setState(() {
                                  //email = _controllerEmail.text;
                                //});
                              },
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              controller: _controllerCode,
                              //validator: validateEmail,
                            )),
                        Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.bottomCenter,
                          margin: EdgeInsets.fromLTRB(0,10,0,0),
                          child: TextButton(
                            onPressed:(){
                              if(_controllerCode.text == code){
                                successRestoreAccess(context, email, phone, nick, fio, code, id);
                                //Navigator.of(context).pop();
                              }else{
                                dialogScreen(context, 'Введен не верный код!');
                              }

                            } ,
                            child: Text('OK', style: TextStyle(fontSize: 16, color: Colors.white), textAlign: TextAlign.center,),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blue,
                              minimumSize: Size(MediaQuery.of(context).size.width, 20),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Colors.blue,
                                    width: 1,
                                    style: BorderStyle.solid
                                ),
                                borderRadius: BorderRadius.circular(0.0),
                              ),
                            ),
                          ),
                        ),

                      ])

              ),
            )
        );
      });

}