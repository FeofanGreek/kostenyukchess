import 'package:flutter/material.dart';



dialogScreen(var context, String message){
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
                  //height: 250
                  height: 200,
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
                          height: 40,
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.bottomCenter,
                          margin: EdgeInsets.fromLTRB(0,10,0,0),
                          child: TextButton(
                            onPressed:(){
                              Navigator.of(context).pop();
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