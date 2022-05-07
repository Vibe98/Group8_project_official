import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:login_flow/classes/profile.dart';

class VerifyCredentials extends ChangeNotifier{

  // creo una mappa in cui associo ad ogni username la relativa password
  Map credentials = {};

  // aggiungo un account
  void addAccount(String username, String name, String surname, String password, String email, File? image){
    
    Profile user = Profile(name, surname, username, password, email, image);
    credentials[username] = user;
    print(user.email);
    notifyListeners();
  }

  void modifyAccount(String username, String email, String name, String surname, String password){
    Profile user = credentials[username];
    
    user.name = name;
    user.surname = surname;
    user.email = email;
    user.password = password;
    notifyListeners();

  }

  Map Restituteuser(String username){
    Profile user = credentials[username];
    Map map = {};
    map['name'] = user.name;
    map['surname'] = user.surname;
    map['username'] = user.username;
    map['email'] = user.email;
    map['password'] = user.password;
    map['image'] = user.image;
    return map;
  }
}