import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'analitics/viewerrors.dart';
import 'constants.dart';

var parsedJsonPaysList;
int _sortType = 0;

class partnerSelectPage extends StatefulWidget {
  const partnerSelectPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<partnerSelectPage> createState() => _partnerSelectPageState();
}

class _partnerSelectPageState extends State<partnerSelectPage> {
  TextEditingController _controllerSearch = TextEditingController(text: '');
  FocusNode myFocusNode1 = FocusNode();
  void _requestFocus1(){
    setState(() {
      FocusScope.of(context).requestFocus(myFocusNode1);
    });
  }

  //обновление страницы после возврата
  @override
  FutureOr onGoBack(dynamic value) {
    getPartenrs();
  }

  getPartenrs()async{
    try{
      var response = await http.post(Uri.parse('https://chess.koldashev.ru/ChessAPI.php'),
          headers: {"Accept": "application/json"},
          body: jsonEncode(<String, dynamic>{
            "subject": "getPartners"
          })
      );
      //print(response.body);
      var jsonStaffList = response.body;
      parsedJsonPaysList = json.decode(jsonStaffList);
      for(int i = 0; i < parsedJsonPaysList.length; i++){
        int.parse(parsedJsonPaysList[i]['id']) == id ? mysubscribes = json.decode(parsedJsonPaysList[i]['iamsubscribe']) : null;
      }
      print(parsedJsonPaysList);
      setState(() {

      });
    } catch (error) {
      print(error);
    }
  }

  @override
  void initState(){
    super.initState();
    getPartenrs();
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
          title: Container(
              margin: const EdgeInsets.fromLTRB(5,5,5,5),
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
                  suffixIcon: InkWell(onTap: (){
                    _controllerSearch.clear();
                    setState(() {});
                  }, child:Icon(Icons.clear, size: 25, color: Colors.grey,)),
                  prefixIcon: Icon(Icons.search, size: 25, color: Colors.grey,),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.only(
                      left: 15, top: 5, bottom: 5
                  ),
                  hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
                  hintText: "Поиск партнера",
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
                autovalidateMode: AutovalidateMode.always,
                controller: _controllerSearch,
              )),
          actions: [
            GestureDetector(
                onTap:()async{
                  await Share.share('check out my website https://example.com', subject: 'Look what I made!');
                },child:Container(
              width:30,
              height: 30,
              margin: const EdgeInsets.all(8.0),
              child: Icon(Icons.share, size: 25, color:Colors.white,),
            ))
          ],
        ),
        body: SingleChildScrollView(
            child:Column(
                children:[
            Container(
            margin: EdgeInsets.fromLTRB(30,20,30,10),
            child:Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:[

                      GestureDetector(onTap:(){
                        setState(() {
                          _sortType = 0;
                        });
                      }, child:Text('Весь список',style: TextStyle(fontSize: 12.0 , color: _sortType == 0 ? Colors.green : Colors.black, fontFamily: 'Open Sans'),textAlign: TextAlign.left,)),
                      GestureDetector(onTap:(){
                        setState(() {
                          _sortType = 1;
                        });
                      }, child:Text('Я подписан',style: TextStyle(fontSize: 12.0 , color: _sortType == 1 ? Colors.green : Colors.black, fontFamily: 'Open Sans'),textAlign: TextAlign.left,)),
                      GestureDetector(onTap:(){
                        setState(() {
                          _sortType = 2;
                        });
                      }, child:Text('На меня подписаны',style: TextStyle(fontSize: 12.0 , color: _sortType == 2 ? Colors.green : Colors.black, fontFamily: 'Open Sans'),textAlign: TextAlign.left,)),

                    ]
                  ),
            ),
                  parsedJsonPaysList != null ? ListView.builder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: parsedJsonPaysList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _sortType == 0 || (_sortType == 1 && subscribeMyStatus(int.parse(parsedJsonPaysList[index]['id']))) || (_sortType == 2 && subscribeStatus(json.decode(parsedJsonPaysList[index]['iamsubscribe'])))? parsedJsonPaysList[index]['email'] != email ? _controllerSearch.text == '' || parsedJsonPaysList[index]['nick'].toLowerCase().contains(_controllerSearch.text.toLowerCase()) || parsedJsonPaysList[index]['fio'].toLowerCase().contains(_controllerSearch.text.toLowerCase()) || parsedJsonPaysList[index]['phone'].toLowerCase().contains(_controllerSearch.text.toLowerCase()) || parsedJsonPaysList[index]['email'].toLowerCase().contains(_controllerSearch.text.toLowerCase()) ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                                elevation: 4.0,
                                child: InkWell(
                                    onTap: (){},
                                    splashColor: Colors.blue,
                                    child: Container(
                                            margin: EdgeInsets.fromLTRB(10,10,10,0),
                                            padding: EdgeInsets.fromLTRB(10,5,5,5),
                                            width: MediaQuery.of(context).size.width - 60,
                                            height: 130,
                                            decoration: BoxDecoration(color: Colors.white,),
                                            alignment: Alignment.centerLeft,
                                            child:
                                            Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children:[
                                                  Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children:[
                                                        Container(
                                                          width: MediaQuery.of(context).size.width/3*2-20,
                                                          child:Column(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text('${parsedJsonPaysList[index]['nick']}',style: TextStyle(fontSize: 17.0 , color: Color(0xFF444444), fontFamily: 'Open Sans'),textAlign: TextAlign.left,),
                                                                Text('${parsedJsonPaysList[index]['fio']}',style: TextStyle(fontSize: 12.0 , color: Colors.grey, fontFamily: 'Open Sans'),textAlign: TextAlign.left,),
                                                                Text('${parsedJsonPaysList[index]['phone']}',style: TextStyle(fontSize: 12.0 , color: Colors.grey, fontFamily: 'Open Sans'),textAlign: TextAlign.left,),
                                                                Text('${parsedJsonPaysList[index]['email']}',style: TextStyle(fontSize: 12.0 , color: Colors.grey, fontFamily: 'Open Sans'),textAlign: TextAlign.left,),
                                                              ]),
                                                        ),

                                                        parsedJsonPaysList[index]['arrived'] == '0' ? Expanded(child: GestureDetector(onTap: (){
                                                          parsedJsonPaysList[index]['arrived'] == '0' ? arrive(context, id.toString(), parsedJsonPaysList[index]['id'], parsedJsonPaysList[index]['token'], username, parsedJsonPaysList[index]['nick']).then(onGoBack) : id.toString() == parsedJsonPaysList[index]['arrived'] ? cancelArrive(context, id.toString(), parsedJsonPaysList[index]['id'], parsedJsonPaysList[index]['token']).then(onGoBack) : onGoBack;
                                                        }, child:Text('Ждет приглашения',style: TextStyle(fontSize: 12.0 , color: Colors.green, fontFamily: 'Open Sans'),textAlign: TextAlign.left,)))
                                                            : Expanded(child: Text('Приглашен или играет',style: TextStyle(fontSize: 12.0 , color: Colors.orange, fontFamily: 'Open Sans'),textAlign: TextAlign.left,)),
                                                      ]),
                                                  Expanded(child: Divider(color: Colors.grey, height: 1,)),
                                                  Row(
                                                    children:[
                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children:[
                                                          GestureDetector(onTap:(){
                                                            subscribeMyStatus(int.parse(parsedJsonPaysList[index]['id'])) ? Navigator.push(context,
                                                                CupertinoPageRoute(builder: (context) => viewErrorsPage(title: 'Анализ ошибок', id: int.parse(parsedJsonPaysList[index]['id']), ))) : null;
                                                          }, child:Text('Партии: ${parsedJsonPaysList[index]['games']} ${parsedJsonPaysList[index]['games'] > parsedJsonPaysList[index]['wins'] && subscribeMyStatus(int.parse(parsedJsonPaysList[index]['id'])) ? 'Смотреть ошибки':''}',style: TextStyle(fontSize: 12.0 , color: parsedJsonPaysList[index]['games'] > parsedJsonPaysList[index]['wins'] ? Colors.indigo : Colors.black, fontFamily: 'Open Sans'),textAlign: TextAlign.left,)),
                                                          Text('Победы: ${parsedJsonPaysList[index]['wins']}',style: TextStyle(fontSize: 12.0 , color: Colors.black, fontFamily: 'Open Sans'),textAlign: TextAlign.left,),
                                                          Text('Рейтинг: ${parsedJsonPaysList[index]['points']}',style: TextStyle(fontSize: 12.0 , color: Colors.black, fontFamily: 'Open Sans'),textAlign: TextAlign.left,),

                                                        ]
                                                      ),
                                                      Spacer(),
                                                      Column(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children:[
                                                            Text('Подписаны на него: ${json.decode(parsedJsonPaysList[index]['tomesubscribe']).length} чел.',style: TextStyle(fontSize: 12.0 , color: Colors.black, fontFamily: 'Open Sans'),textAlign: TextAlign.left,),
                                                            Text('Он подисан: ${json.decode(parsedJsonPaysList[index]['iamsubscribe']).length} чел.',style: TextStyle(fontSize: 12.0 , color: Colors.black, fontFamily: 'Open Sans'),textAlign: TextAlign.left,),
                                                            !subscribeMyStatus(int.parse(parsedJsonPaysList[index]['id'])) ? GestureDetector(onTap:(){doSubscribe(id, int.parse(parsedJsonPaysList[index]['id']), parsedJsonPaysList[index]['token']).then(onGoBack);}, child:Text('Подписаться',style: TextStyle(fontSize: 12.0 , color: Colors.green, fontFamily: 'Open Sans'),textAlign: TextAlign.left,)) : GestureDetector(onTap:(){unSubscribe(id, int.parse(parsedJsonPaysList[index]['id']), parsedJsonPaysList[index]['token'], mysubscribes, json.decode(parsedJsonPaysList[index]['tomesubscribe'])).then(onGoBack);}, child:Text('Отписаться',style: TextStyle(fontSize: 12.0 , color: Colors.red, fontFamily: 'Open Sans'),textAlign: TextAlign.left,)),
                                                            subscribeStatus(json.decode(parsedJsonPaysList[index]['iamsubscribe'])) ? Text('Подписан на вас',style: TextStyle(fontSize: 12.0 , color: Colors.yellow, fontFamily: 'Open Sans'),textAlign: TextAlign.left,) : Container(),
                                                          ]
                                                      ),
                                                    ]
                                                  )

                                                ])

                                    )))) : Container() : Container() : Container();
                      }):Container(
                    child:Text('В игре пока нет пользователей',style: TextStyle(fontSize: 17.0 , color: Color(0xFF444444), fontFamily: 'Open Sans'),textAlign: TextAlign.left,),

                  ),
                ])
        )

        ));
  }

}