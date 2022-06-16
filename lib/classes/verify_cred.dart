import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:login_flow/classes/profile.dart';


class VerifyCredentials extends ChangeNotifier{

  // creo una mappa in cui associo ad ogni username la relativa password
  Map credentials = {};

  // aggiungo un account
  void addAccount(String username, String name, String surname, String password, String email){
    
    Profile user = Profile(name, surname, username, password, email);
    credentials[username] = user;
    print(user.email);
    notifyListeners();
  }

  void removeAccount(String username){
    
   
    credentials[username] = Profile('', '', '', '', '');
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
    map['userID'] = user.userID;
    return map;
    
  }

  void AssociateAuthorization(String username, String? userId){
    Profile user = credentials[username];
    if (userId != null){
      user.userID = userId;
      notifyListeners();
    }else{
      user.userID = '';
      notifyListeners();
    }
  }
  bool isAuthenticated(String username){
    Profile user = credentials[username];
    if(user.userID == ''){
      return false;
    }else{
      return true;
    }
   
  }

  void hascompleted(String username){
    Profile user = credentials[username];
    if(user.complete){
      user.complete = false;
    }else{
      user.complete = true;
    }
    notifyListeners();
  }

  bool iscompleted(String username){
    Profile user = credentials[username];
    if(user.complete){
      return true;
    }else{
      return false;
    }
  }

    
   
}