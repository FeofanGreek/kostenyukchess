import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:chess_/selectfirst.dart';
import 'package:chess_/servicefunctions.dart';
import 'package:chess_/socketchat.dart';
import 'package:chess_/utils/dialogscreen.dart';
import 'package:chess_/utils/gamenotif.dart';
import 'package:chess_/utils/inputcode.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:path_provider/path_provider.dart';
import 'main.dart';

String username ='';
String email = '';
String phone = '';
String fio = '';
String userToken = '';
String partner = '';
String partnerToken ='';
String color = '';
int id = 0;
int way = 0; //0 - обычный запуск, 1 - в игру, 3 - процесс игры
List mysubscribes = [];

//переменные для накопления статистики
List games = [];
String crashGame = '';
String crashMove = '';



//настроили обработку событий при поступлении пушей
pushInstall(var context)async{
  //установили пуши и получисли токен
  await Firebase.initializeApp().then((v){
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    ///обработчик в открытом приложении
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      //проверяем наличие приглашений
      checkArives(context, email);
      ///запустить диалог принять не принять
      /*if(message.data['status'] == 1){
        way = 1;
        partner = message.data['partner'];
        partnerToken = message.data['partnerToken'];
        color = message.data['color'];
        Navigator.pushReplacement (context,
            CupertinoPageRoute(builder: (context) => gamePage(title: "Игра", nick: partner, token: partnerToken,)));
      }else if(message.data['status'] == 3){
        gameList.add({"fen" : message.data['fen']});
      }*/

    });
    ///обработчик когда приложение выключено
    FirebaseMessaging.onBackgroundMessage((message)=> firebaseMessagingBackgroundHandler(message));

  });
  return true;
}

//взяли токен в первый раз
getToken(context, String nick, String emailreg)async{
  await Firebase.initializeApp().then((v) {
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    _firebaseMessaging.getToken().then((token) async {
      assert(token != null);
      //print('+++++++');
      //print(token);
      //пишем токен в бд
      await http.post(
            Uri.parse('https://chess.koldashev.ru/ChessAPI.php'),
            headers: {"Accept": "application/json"},
            body: jsonEncode(<String, dynamic>{
              "nick" : nick,
              "token" : token,
              "phone" : phone,
              "email" : emailreg,
              "fio" : fio,
              "subject": "newuser"
            })
        ).then((response) async {
          print(response.body);
          var jsonR = response.body;
          var parsedJson = json.decode(jsonR);
          if(parsedJson['status'] == 'error'){
            dialogScreen(context, parsedJson['message']);
          }else{
            dialogScreen(context, parsedJson['message']);
            id = parsedJson['id'];
              //записали в файл номер пользователя, номер региона, имя региона
              final Directory directory = await getApplicationDocumentsDirectory();
              final File file = File('${directory.path}/profile.txt');
              var profile = jsonEncode(<String, dynamic>{
                "nick" : nick,
                "token" : token,
                "phone" : phone,
                "email" : emailreg,
                "fio" : fio,
                "id" : parsedJson['id']
              });
              await file.writeAsString(profile).then((v){
                const twentyMillis = Duration(seconds:2);
                Timer(twentyMillis, () =>
                    Navigator.pushReplacement(context,
                    CupertinoPageRoute(builder: (context) =>
                        const firstSelectPage(title: 'Выбор'))));

            });

          }
        });
    });
  });
}

//восстановление доступа
restoreAccess(context, String emailreg)async{
  await http.post(
      Uri.parse('https://chess.koldashev.ru/ChessAPI.php'),
      headers: {"Accept": "application/json"},
      body: jsonEncode(<String, dynamic>{
        "nick" : username,
        "phone" : phone,
        "email" : emailreg,
        "fio" : fio,
        "subject": "restoreAccess"
      })
  ).then((response) async {
    //print(response.body);
    var jsonR = response.body;
    var parsedJson = json.decode(jsonR);
    if(parsedJson['status'] == 'error'){
      dialogScreen(context, parsedJson['message']);
    }else{
      inputcode(context, parsedJson['message'], parsedJson['email'], parsedJson['phone'], parsedJson['nick'], parsedJson['fio'], parsedJson['restorecode'], parsedJson['id']);
    }
    });
}

//удачное восстановление доступа
successRestoreAccess(context, String email, String phone, String nick, String fio, String code, String id)async{
  await Firebase.initializeApp().then((v) {
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    _firebaseMessaging.getToken().then((token) async {
      assert(token != null);
      //print('+++++++');
      //print(token);
      //пишем токен в бд
      await http.post(
          Uri.parse('https://chess.koldashev.ru/ChessAPI.php'),
          headers: {"Accept": "application/json"},
          body: jsonEncode(<String, dynamic>{
            "token" : token,
            "email" : email,
            "subject": "successRestoreAccess"
          })
      ).then((response) async {
        print(response.body);
        //записали в файл номер пользователя, номер региона, имя региона
        final Directory directory = await getApplicationDocumentsDirectory();
        final File file = File('${directory.path}/profile.txt');
        var profile = jsonEncode(<String, dynamic>{
          "nick" : username,
          "token" : token,
          "phone" : phone,
          "email" : email,
          "fio" : fio,
          "id" : id
        });
        await file.writeAsString(profile);
        Navigator.pushReplacement (context,
            CupertinoPageRoute(builder: (context) => firstSelectPage(title: 'Выбор')));
      });
    });
  });
}

//отправляем приглашение или отказ или что то еще
sendArrive(String token, int status, String partner, String partnerToken, String color)async{
  await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: {"Content-Type": "application/json", "Authorization":"key=AAAAmlmyhlQ:APA91bFADxFaR20YXSehRNvP9TXlOdPTDXvcSe3hqU2OxnLp1vdD0nOaOysSRZddaWR8GtX2nIMi1oXirp0MTrsGDWjOJ8VefH9tsG0QEgeWn79GfXtT3mM7ZPdlG7xkZkyjq64f3DNq"},
      body: jsonEncode(<String, dynamic>{
        "to" : token,
        "notification" : {"title" : "Игрок $username предложил партию" , "body" : "Перейти в приложение", "sound" : "default", "badge" : "1"},
        "priority" : "high",
        "data" : {"click_action" : "FLUTTER_NOTIFICATION_CLICK", "id" : "1", "status" : status, "partner" : partner, "partnerToken" : partnerToken, "color" : color}
      })
  ).then((response) async {
    //print(response.body);

  });
}

String? validateEmail(String? value) {
  String pattern =
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?)*$";
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(value!))
    return 'Введен не корректный адрес электронной почты';
  else
    return null;
}

//подписаться
doSubscribe(int owner, int arrival, String tokenToPush)async{
  await http.post(
      Uri.parse('https://chess.koldashev.ru/ChessAPI.php'),
      headers: {"Accept": "application/json"},
      body: jsonEncode(<String, dynamic>{
        "owner" : owner,
        "arrival" : arrival,
        "subject": "subscribe"
      })
  ).then((response) async {
    //отправим пуш
    sendSubscribePush(tokenToPush, "Поздравляем $arrival! На вас подписался $owner", 'Новая подписка');
  });
}

//отписаться
//подписаться
unSubscribe(int owner, int arrival, String tokenToPush, List mysubscribe, List toMeSubscribe)async{
  for(int i= 0; i < mysubscribe.length; i++){
    mysubscribe[i] == arrival ? mysubscribe.removeAt(i): null;
  }
  for(int i= 0; i < toMeSubscribe.length; i++){
    toMeSubscribe[i] == owner ? toMeSubscribe.removeAt(i): null;

  }
  print(toMeSubscribe);
  print(mysubscribe);
  print(arrival);
  print(owner);
  await http.post(
      Uri.parse('https://chess.koldashev.ru/ChessAPI.php'),
      headers: {"Accept": "application/json"},
      body: jsonEncode(<String, dynamic>{
        "owner" : owner,
        "arrival" : arrival,
        "mysubscribes" : mysubscribe.toString(),
        "toMeSubscribe": toMeSubscribe.toString(),
        "subject": "unsubscribe"
      })
  ).then((response) async {
    print(response.body);
    //отправим пуш
    sendSubscribePush(tokenToPush, "$owner отменил подписку на вас", 'Подписка отменена');
  });
}

//ищем подписан на нас или нет или нет
subscribeStatus(List _id){
  bool subscribe = false;
  for(int i=0; i < _id.length; i++){

    _id[i] == id ? subscribe = true : null;
  }
  return subscribe;
}

//ищем подписан я или нет или нет
subscribeMyStatus(id){
  bool subscribe = false;
  for(int i=0; i < mysubscribes.length; i++){

    mysubscribes[i] == id ? subscribe = true : null;
  }
  return subscribe;
}


//приглашаем
arrive(BuildContext context, String owner, String arrival, String token, String player1, String player2)async{
  await http.post(
      Uri.parse('https://chess.koldashev.ru/ChessAPI.php'),
      headers: {"Accept": "application/json"},
      body: jsonEncode(<String, dynamic>{
        "owner" : owner,
        "arrival" : arrival,
        "subject": "arrive"
      })
  ).then((response) async {
    //print(response.body);
    var jsonR = response.body;
    var parsedJson = json.decode(jsonR);
    if(parsedJson['status'] == 'error'){
      dialogScreen(context, parsedJson['message']);
    }else{
      dialogScreen(context, parsedJson['message']);
      sendArrive(token, 1, username, userToken, 'black'); //1 = приглашение
      const twentyMillis = const Duration(seconds:2);
      Timer(twentyMillis, () => Navigator.pushReplacement (context,
          CupertinoPageRoute(builder: (context) => ChatPage(owner:owner , arrived: arrival, token: token, player1: player1, player2: player2, status: 1))));
    }
  });
}
//отменяем приглашение
cancelArrive(context, String owner, String arrival, String token )async{
  await http.post(
      Uri.parse('https://chess.koldashev.ru/ChessAPI.php'),
      headers: {"Accept": "application/json"},
      body: jsonEncode(<String, dynamic>{
        "owner" : owner,
        "arrival" : arrival,
        "subject": "cancelarrive"
      })
  ).then((response) async {
    print(response.body);

    var jsonR = response.body;
    var parsedJson = json.decode(jsonR);
    if(parsedJson['status'] == 'error'){
      const twentyMillis = const Duration(seconds:2);
      Timer(twentyMillis, () => Navigator.pushReplacement(context,
          CupertinoPageRoute(builder: (context) => firstSelectPage(title: 'Выбор'))));
    }else{
      sendArrive(token, 1, username, userToken, 'black'); //1 = приглашение

      const twentyMillis = const Duration(seconds:2);
      Timer(twentyMillis, () => Navigator.pushReplacement(context,
          CupertinoPageRoute(builder: (context) => firstSelectPage(title: 'Выбор'))));

    }
  });
}



//проверка наличия приглашений
checkArives(context, String email)async{
  await http.post(
      Uri.parse('https://chess.koldashev.ru/ChessAPI.php'),
      headers: {"Accept": "application/json"},
      body: jsonEncode(<String, dynamic>{
        "email" : email,
        "subject": "checkarrive"
      })
  ).then((response) async {
    print(response.body);
    var jsonR = response.body;
    var parsedJson = json.decode(jsonR);
    if(parsedJson['status'] == 'error'){
      //редиректимся на экран выбора
      const twentyMillis = const Duration(seconds:2);
      Timer(twentyMillis, () => Navigator.push(context,
          CupertinoPageRoute(builder: (context) => firstSelectPage(title: 'Выбор'))));
    }else{
      print('$id ${parsedJson['arrived']}' );
      gameProceedScreen(context, parsedJson['message'], id == parsedJson['major'] ? parsedJson['arrived'] : parsedJson['owner'], id == parsedJson['arrived'] ? parsedJson['owner'] : parsedJson['arrived'], parsedJson['token'], parsedJson['player1'], parsedJson['player2'], int.parse(parsedJson['major']));
    }
  });
}

List typesGames =  [{
  "type": "advancedPawn",
  "title": "Продвинутая пешка",
  "description": "Тактика связанная с превращением пешки или угрозой превращения пешки."
},
{
"type": "advantage",
"title": "Преимущество",
"description": "Используйте свой шанс получить решающее преимущество. (от 200 до 600 сантипешек)"
},
{
"type": "anastasiaMate",
"title": "Мат Анастасии",
"description": "Конь и ладья (или ферзь) матуют короля противника между краем доски и другой фигурой противника."
},
{
"type": "arabianMate",
"title": "Арабский мат",
"description": "Конь и ладья матуют вражеского короля в углу доски."
},
{
"type": "attackingF2F7",
"title": "Атака f2 или f7",
"description": "Атака, направленная на пешки f2 или f7, например, в дебюте жареной печени."
},
{
"type": "attraction",
"title": "Завлечение",
"description": "Размен или жертва, вынуждающая или подталкивающая фигуру противника занять поле, после чего становится возможен последующий тактический приём."
},
{
"type": "backRankMate",
"title": "Мат на последней горизонтали",
"description": "Матование короля на его горизонтали, когда он заблокирован своими же фигурами."
},
{
"type": "bishopEndgame",
"title": "Слоновый эндшпиль",
"description": "Эндшпиль, где присутствуют лишь слоны и пешки."
},
{
"type": "bodenMate",
"title": "Мат Бодена",
"description": "Два слона на скрещённых диагоналях ставят мат вражескому королю, окружённому собственными фигурами."
},
{
"type": "castling",
"title": "Рокировка",
"description": "Помещение короля в надёжное место и вывод в бой ладьи."
},
{
"type": "capturingDefender",
"title": "Уничтожение защитника",
"description": "Взятие или размен фигуры, защищающей другую фигуру, с последующим взятием фигуры, оставшейся без защиты."
},
{
"type": "crushing",
"title": "Разгром",
"description": "Используйте зевок противника для получения сокрушительного преимущества. (600 и более сантипешек)"
},
{
"type": "doubleBishopMate",
"title": "Мат двумя слонами",
"description": "Два слона атакующей стороны ставят мат на смежных диагоналях королю противника, окружённому своими же фигурами."
},
{
"type": "dovetailMate",
"title": "Мат «ласточкин хвост»",
"description": "Мат ферзём стоящему рядом королю противника, единственные два поля отхода которого занимают его же фигуры."
},
{
"type": "equality",
"title": "Уравнение",
"description": "Отыграйтесь из проигранной позиции: сведите партию на ничью или получите позиционное равенство. (менее 200 сантипешек)"
},
{
"type": "kingsideAttack",
"title": "Атака на королевском фланге",
"description": "Атака на рокированного в короткую сторону короля противника."
},
{
"type": "clearance",
"title": "Освобождение линии или поля",
"description": "Ход, обычно с темпом, освобождающий поле, линию или диагональ с целью реализации тактической идеи."
},
{
"type": "defensiveMove",
"title": "Защитный ход",
"description": "Точный ход или последовательность ходов, которые необходимы во избежание потери материала или другого преимущества."
},
{
"type": "deflection",
"title": "Отвлечение",
"description": "Ход, отвлекающий фигуру противника от важной задачи, например, от защиты ключевого поля."
},
{
"type": "discoveredAttack",
"title": "Вскрытое нападение",
"description": "Ход фигурой, которая закрывает линию атаки дальнобойной фигуры. Например, ход конём, вскрывающий линию для стоящей за ним ладьи."
},
{
"type": "doubleCheck",
"title": "Двойной шах",
"description": "Шах двумя фигурами одновременно при помощи вскрытого нападения. Нельзя срубить обе атакующие фигуры и нельзя закрыться от них, поэтому король может только уйти от шаха."
},
{
"type": "endgame",
"title": "Эндшпиль",
"description": "Тактика в последней стадии игры."
},
{
"type": "enPassant",
"title": "Взятие на проходе",
"description": "Тактика с применением правила «взятие на проходе», где пешка может взять пешку противника, сделавшую первоначальный ход с перемещением на два поля, при котором пересекаемое поле находится под боем пешки, которая может взять пешку противника."
},
{
"type": "exposedKing",
"title": "Голый король",
"description": "Незащищённый или слабо защищённый король часто становится жертвой матовой атаки."
},
{
"type": "fork",
"title": "Вилка",
"description": "Ход, при котором под удар попадают две фигуры противника."
},
{
"type": "hangingPiece",
"title": "Незащищённая фигура",
"description": "Тактика, при которой фигура соперника не защищена или недостаточно защищена и может быть взята."
},
{
"type": "hookMate",
"title": "Хук-мат",
"description": "Мат ладьёй и конём, защищённым пешкой, при том, что одна из пешек противника занимает единственное доступное поле для отхода его короля."
},
{
"type": "interference",
"title": "Перекрытие",
"description": "Ход, перекрывающий линию взаимодействия дальнобойных фигур противника, в результате которого одна или обе фигуры становятся беззащитными. Например, конь встаёт на защищённое поле между двумя ладьями."
},
{
"type": "intermezzo",
"title": "Промежуточный ход",
"description": "Вместо того, чтобы сделать ожидаемый ход, сначала делается другой ход, представляющий непосредственную угрозу, на которую противник должен ответить. Также известен как «Zwischenzug» или «Intermezzo»."
},
{
"type": "knightEndgame",
"title": "Коневой эндшпиль",
"description": "Эндшпиль, в котором на доске остались только кони и пешки."
},
{
"type": "long",
"title": "Трёхходовая задача",
"description": "Три хода до победы."
},
{
"type": "master",
"title": "Партии мастеров",
"description": "Задачи из партий с участием титулованных игроков."
},
{
"type": "masterVsMaster",
"title": "Партии двух мастеров",
"description": "Задачи из партий с участием двух титулованных игроков."
},
{
"type": "mate",
"title": "Мат",
"description": "Закончите игру красиво."
},
{
"type": "mateIn1",
"title": "Мат в 1 ход",
"description": "Поставьте мат в один ход."
},
{
"type": "mateIn2",
"title": "Мат в два хода",
"description": "Поставьте мат в два хода."
},
{
"type": "mateIn3",
"title": "Мат в 3 хода",
"description": "Поставьте мат в три хода."
},
{
"type": "mateIn4",
"title": "Мат в 4 хода",
"description": "Поставьте мат за четыре хода."
},
{
"type": "mateIn5",
"title": "Мат в 5 или более",
"description": "Найдите последовательность ходов, ведущую к мату."
},
{
"type": "middlegame",
"title": "Миттельшпиль",
"description": "Тактика во второй стадии игры."
},
{
"type": "oneMove",
"title": "Одноходовая задача",
"description": "Задача, где нужно сделать только один выигрывающий ход."
},
{
"type": "opening",
"title": "Дебют",
"description": "Тактика в первой стадии игры."
},
{
"type": "pawnEndgame",
"title": "Пешечный эндшпиль",
"description": "Эндшпиль с пешками."
},
{
"type": "pin",
"title": "Связка",
"description": "Тактика, использующая связку, когда фигура не может сделать ход, иначе под атаку попадёт стоящая за ней более ценная фигура."
},
{
"type": "promotion",
"title": "Превращение",
"description": "Ход при котором пешка ходит на последнюю горизонталь и заменяется по выбору игрока на любую другую фигуру того же цвета, кроме короля."
},
{
"type": "queenEndgame",
"title": "Ферзевый эндшпиль",
"description": "Эндшпиль с ферзями и пешками."
},
{
"type": "queenRookEndgame",
"title": "Ферзево-ладейный эндшпиль",
"description": "Эндшпиль с ферзями, ладьями и пешками."
},
{
"type": "queensideAttack",
"title": "Атака на ферзевом фланге",
"description": "Атака короля, рокировавшегося в длинную сторону."
},
{
"type": "quietMove",
"title": "Тихий ход",
"description": "Ход без шаха или взятия, который тем не менее подготавливает неизбежную угрозу."
},
{
"type": "rookEndgame",
"title": "Ладейный эндшпиль",
"description": "Эндшпиль с ладьями и пешками."
},
{
"type": "sacrifice",
"title": "Жертва",
"description": "Тактика, при которой происходит отдача какого-либо материала для получения преимущества, объявления мата или сведения игры вничью."
},
{
"type": "short",
"title": "Двухходовая задача",
"description": "Два хода до победы."
},
{
"type": "skewer",
"title": "Линейный удар",
"description": "Разновидность связки, но в этом случае наоборот, более ценная фигура оказывается на линии атаки перед менее ценной или равноценной фигурой."
},
{
"type": "smotheredMate",
"title": "Спёртый мат",
"description": "Мат конём королю, который не может уйти от мата, потому что окружён (спёрт) своими же собственными фигурами."
},
{
"type": "superGM",
"title": "Партии супергроссмейстеров",
"description": "Задачи из партий, сыгранных лучшими шахматистами в мире."
},
{
"type": "trappedPiece",
"title": "Ловля фигуры",
"description": "Фигура не может уйти от нападения, потому что не имеет свободных полей для отхода, или эти поля тоже находятся под нападением."
},
{
"type": "underPromotion",
"title": "Слабое превращение",
"description": "Превращение пешки не в ферзя, а в коня, слона или ладью."
},
{
"type": "veryLong",
"title": "Многоходовая задача",
"description": "Четыре или более ходов для победы."
},
{
"type": "xRayAttack",
"title": "Рентген",
"description": "Ситуация, когда на линии нападения или защиты дальнобойной фигуры стоит фигура противника."
},
{
"type": "zugzwang",
"title": "Цугцванг",
"description": "Противник вынужден сделать один из немногих возможных ходов, но любой ход ведёт к ухудшению его положения."
},
/*{
"type": "healthyMix",
"title": "Сборная солянка",
"description": "Всего понемногу. Вы не знаете, чего ожидать, так что будьте готовы ко всему! Прямо как в настоящей партии."
},*/
];
