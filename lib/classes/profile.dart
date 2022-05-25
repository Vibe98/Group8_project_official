import 'dart:io';

import 'package:flutter/cupertino.dart';

class Profile{

  String? name;
  String? surname;
  String? username;
  String? password;
  String? email;
  bool complete = false;
  String userID = '';


  @override 
  Profile(String name, String surname, String username, String password, String email){
    this.name = name;
    this.surname = surname;
    this.password = password;
    this.username = username;
    this.email = email;
  }
  // creo una classe utente con le informazioni richieste nella login page. 
 
}