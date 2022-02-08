// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:convert' show json;

import 'package:chess_/registration.dart';
import 'package:chess_/selectfirst.dart';
import 'package:flutter/cupertino.dart';
import "package:http/http.dart" as http;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'constants.dart';


int counter = 0;
GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId
  // clientId: '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps.googleusercontent.com',
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);



class SignInDemo extends StatefulWidget {
  @override
  State createState() => SignInDemoState();
}

class SignInDemoState extends State<SignInDemo> {
  GoogleSignInAccount? _currentUser;
  String _contactText = '';

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        _handleGetContact(_currentUser!);
      }
    });
    _googleSignIn.signInSilently();
  }

  Future<void> _handleGetContact(GoogleSignInAccount user) async {
    setState(() {
      _contactText = "Загрузка информации о контакте...";
    });
    final http.Response response = await http.get(
      Uri.parse('https://people.googleapis.com/v1/people/me/connections'
          '?requestMask.includeField=person.names'),
      headers: await user.authHeaders,
    );
    if (response.statusCode != 200) {
      setState(() {
        _contactText = "People API gave a ${response.statusCode} "
            "response. Check logs for details.";
      });
      print('People API ${response.statusCode} response: ${response.body}');
      return;
    }
    final Map<String, dynamic> data = json.decode(response.body);
    final String? namedContact = _pickFirstNamedContact(data);
    setState(() {
      if (namedContact != null) {
        _contactText = "I see you know $namedContact!";
      } else {
        _contactText = "Отсутсвуют контактные данные для отображения.";
      }
    });
  }

  String? _pickFirstNamedContact(Map<String, dynamic> data) {
    final List<dynamic>? connections = data['connections'];
    final Map<String, dynamic>? contact = connections?.firstWhere(
          (dynamic contact) => contact['names'] != null,
      orElse: () => null,
    );
    if (contact != null) {
      final Map<String, dynamic>? name = contact['names'].firstWhere(
            (dynamic name) => name['displayName'] != null,
        orElse: () => null,
      );
      if (name != null) {
        return name['displayName'];
      }
    }
    return null;
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  Widget _buildBody() {
    GoogleSignInAccount? user = _currentUser;

    if (user != null) {
      print(counter);
      counter++;
      username = user.email.split('@')[0];
      fio = user.displayName!;
      email = user.email;
      phone = '';
      counter == 1 ? getToken(context, username, email) : null;
      return Container();
      /*return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ListTile(
            leading: GoogleUserCircleAvatar(
              identity: user,
            ),
            title: Text(user.displayName ?? ''),
            subtitle: Text(user.email),
          ),
          Text("Вход совершен успешно."),
          Text(_contactText),
          ElevatedButton(
            child: const Text('Выход'),
            onPressed: _handleSignOut,
          ),
          ElevatedButton(
            child: const Text('Обновить'),
            onPressed: () => _handleGetContact(user),
          ),
        ],
      );*/
    } else {
      return Column(
        //mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.fromLTRB(16,30,16,0),
            padding: const EdgeInsets.fromLTRB(0,0,0,0),
            alignment: Alignment.topLeft,
            //width: MediaQuery.of(context).size.width - 40,
            child:const Text(
                'Регистрация позволит вам:\n - Играть с партнером\n - Накапливать статистику тренировок\n - Следить за успехами других студентов\n - Получать персональные задания\n - Принимать приглашения в игру\n',
                textAlign: TextAlign.left
            ),),
          Container(
            margin: const EdgeInsets.fromLTRB(16,16,16,0),
            padding: const EdgeInsets.fromLTRB(0,0,0,0),
            height: 50,
            //width: MediaQuery.of(context).size.width - 40,
            alignment: Alignment.center,
            child: TextButton(
              onPressed:_handleSignIn ,
              child: const Text('Вход с Google',
                style: TextStyle(fontSize: 16, color: Colors.white),
                textAlign: TextAlign.center,) ,
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                minimumSize: Size(MediaQuery.of(context).size.width, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(16,16,16,0),
            padding: const EdgeInsets.fromLTRB(0,0,0,0),
            height: 50,
            //width: MediaQuery.of(context).size.width - 40,
            alignment: Alignment.center,
            child: TextButton(
              onPressed:(){},
              child: const Text('Вход с Apple',
                style: TextStyle(fontSize: 16, color: Colors.white),
                textAlign: TextAlign.center,) ,
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                minimumSize: Size(MediaQuery.of(context).size.width, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(16,16,16,0),
            padding: const EdgeInsets.fromLTRB(0,0,0,0),
            height: 50,
            //width: MediaQuery.of(context).size.width - 40,
            alignment: Alignment.center,
            child: TextButton(
              onPressed:(){
                Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => const regPage(title: 'Регистрация')));
              } ,
              child: const Text('Форма регистрации',
                style: TextStyle(fontSize: 16, color: Colors.white),
                textAlign: TextAlign.center,) ,
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                minimumSize: Size(MediaQuery.of(context).size.width, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
            ),
          ),

          Container(
            margin: const EdgeInsets.fromLTRB(16,16,16,0),
            padding: const EdgeInsets.fromLTRB(0,0,0,0),
            height: 50,
            //width: MediaQuery.of(context).size.width - 40,
            alignment: Alignment.center,
            child: TextButton(
              onPressed:(){
                username = 'Не зарегистрирован';
                userToken = '';
                fio = '';
                email = '';
                phone = '';
                id = 0;
                Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => const firstSelectPage(title: 'Выбор')));
              } ,
              child: const Text('Попробовать без регистрации',
                style: TextStyle(fontSize: 16, color: Colors.white),
                textAlign: TextAlign.center,) ,
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                minimumSize: Size(MediaQuery.of(context).size.width, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
            ),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Авторизация'),
        ),
        body: ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: _buildBody(),
        ));
  }
}