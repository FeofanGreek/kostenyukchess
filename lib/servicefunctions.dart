import 'dart:convert';

import 'package:http/http.dart' as http;

import 'constants.dart';

countDownTimerValue(value){
  print(value);
  if(value == 1.0){
    return 15;
  }
  else if(value == 2.0){
    return 30;
  }
  else if(value == 3.0){
    return 45;
  }
  else if(value == 4.0){
    return 60;
  }
  else if(value == 5.0){
    return 90;
  }
  else if(value == 6.0){
    return 120;
  }
  else if(value == 7.0){
    return 180;
  }
  else if(value == 8.0){
    return 240;
  }
  else if(value == 9.0){
    return 300;
  }
  else if(value == 10.0){
    return 360;
  }
  else if(value == 11.0){
    return 420;
  }
  else if(value == 12.0){
    return 480;
  }
  else if(value == 13.0){
    return 540;
  }
  else if(value == 14.0){
    return 600;
  }
  else if(value == 15.0){
    return 660;
  }
  else if(value == 16.0){
    return 720;
  }
  else if(value == 17.0){
    return 780;
  }
  else if(value == 18.0){
    return 840;
  }
  else if(value == 19.0){
    return 900;
  }
  else if(value == 20.0){
    return 960;
  }
  else if(value == 21.0){
    return 1020;
  }
  else if(value == 22.0){
    return 1080;
  }
  else if(value.round() == 23){
    return 1140;
  }
  else if(value == 24.0){
    return 1200;
  }
  else if(value == 25.0){
    return 1260;
  }
  else if(value == 26.0){
    return 1260;
  }
  else if(value == 27.0){
    return 1320;
  }
  else if(value == 28.0){
    return 1380;
  }
  else if(value == 29.0){
    return 1440;
  }
  else if(value == 30.0){
    return 1500;
  }
  else if(value == 31.0){
    return 1800;
  }
  else if(value == 32.0){
    return 2100;
  }
  else if(value == 33.0){
    return 2400;
  }
  else if(value == 34.0){
    return 2700;
  }
  else if(value == 35.0){
    return 3600;
  }
  else if(value == 36.0){
    return 4500;
  }
  else if(value == 37.0){
    return 5400;
  }
  else if(value == 38.0){
    return 6300;
  }
  else if(value == 39.0){
    return 7200;
  }
  else if(value == 40.0){
    return 8100;
  }
  else if(value == 41.0){
    return 9000;
  }
  else if(value == 42.0){
    return 9900;
  }
  else if(value == 43.0){
    return 10800;
  }
  return 0;
}

addTimeTimerValue(value){
  if(value == 1.0){
    return 1;
  }
  else if(value == 2.0){
    return 2;
  }
  else if(value == 3.0){
    return 3;
  }
  else if(value == 4.0){
    return 4;
  }
  else if(value == 5.0){
    return 5;
  }
  else if(value == 6.0){
    return 6;
  }
  else if(value == 7.0){
    return 7;
  }
  else if(value == 8.0){
    return 8;
  }
  else if(value == 9.0){
    return 9;
  }
  else if(value == 10.0){
    return 10;
  }
  else if(value == 11.0){
    return 11;
  }
  else if(value == 12.0){
    return 12;
  }
  else if(value == 13.0){
    return 13;
  }
  else if(value == 14){
    return 14;
  }
  else if(value.round() == 15){
    return 15;
  }
  else if(value == 16.0){
    return 20;
  }
  else if(value == 17.0){
    return 25;
  }
  else if(value == 18.0){
    return 30;
  }
  else if(value == 19.0){
    return 35;
  }
  else if(value == 20.0){
    return 40;
  }
  else if(value == 21.0){
    return 45;
  }
  else if(value == 22.0){
    return 60;
  }
  else if(value == 23.0){
    return 90;
  }
  else if(value == 24.0){
    return 120;
  }
  else if(value == 25.0){
    return 150;
  }
  else if(value == 26.0){
    return 180;
  }

  return 0;
}
List fensExample = [{"fen":"r1bqkbnr/pppp1ppp/2n5/1B2p3/4P3/5N2/PPPP1PPP/RNBQK2R b KQkq - 0 3","title":"Испанская партия (Ruy Lopez)"},
  {"fen":"r1bqkb1r/ppp2ppp/2n2n2/3pp1N1/2B1P3/8/PPPP1PPP/RNBQK2R w KQkq - 0 5","title":"Итальянская партия (Italian Game)"},
  {"fen":"r1bqkbnr/pp1ppppp/2n5/2p5/4P3/5N2/PPPP1PPP/RNBQKB1R w KQkq - 2 3","title":"Сицилианская защита (Sicilian Defence)"},
  {"fen":"rnbqkbnr/pppp1ppp/4p3/8/2P1P3/8/PP1P1PPP/RNBQKBNR b KQkq - 0 2","title":"Французская защита (French Defence)"},
  {"fen":"rnbqkbnr/pp1ppppp/2p5/8/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 0 2","title":"Защита Каро — Канн (Caro–Kann Defence)"},
  {"fen":"rnbqkbnr/ppp1pppp/3p4/8/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 0 2","title":"Защита Пирца — Уфимцева (Pirc Defence)"},
  {"fen":"rnbqkbnr/ppp1pppp/8/3p4/2PP4/8/PP2PPPP/RNBQKBNR b KQkq - 0 2","title":"Ферзевый гамбит (Queen's Gambit)"},
  {"fen":"rnbqkb1r/pppppp1p/5np1/8/2PP4/8/PP2PPPP/RNBQKBNR w KQkq - 0 3","title":"Индийские игры (Indian Defence)"}];


//запись тренировочной игры в БД
writeSkill( List games, String idCrashGame, String crashMove, int points, int movenumber, String san)async{
  await http.post(
      Uri.parse('https://chess.koldashev.ru/ChessAPI.php'),
      headers: {"Accept": "application/json"},
      body: jsonEncode(<String, dynamic>{
        "playerid" : id,
        "games": "$games",
        "crashgame":idCrashGame,
        "crashmove":crashMove,
        "points":points,
        "movenumber":movenumber,
        "san" : san,
        "subject":"treningskill"
      })
  ).then((response) async {
    print(response.body);
  });
}

//шлем пуш при подписке отписке
sendSubscribePush(String token, String message, String title)async{
  await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: {"Content-Type": "application/json", "Authorization":"key=AAAAmlmyhlQ:APA91bFADxFaR20YXSehRNvP9TXlOdPTDXvcSe3hqU2OxnLp1vdD0nOaOysSRZddaWR8GtX2nIMi1oXirp0MTrsGDWjOJ8VefH9tsG0QEgeWn79GfXtT3mM7ZPdlG7xkZkyjq64f3DNq"},
      body: jsonEncode(<String, dynamic>{
        "to" : token,
        "notification" : {"title" : message , "body" : "Перейти в приложение", "sound" : "default", "badge" : "1"},
        "priority" : "high",
      })
  ).then((response) async {

  });
}