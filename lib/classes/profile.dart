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
  String? question;


  @override 
  Profile(String name, String surname, String username, String password, String email, String question){
    this.name = name;
    this.surname = surname;
    this.password = password;
    this.username = username;
    this.email = email;
    this.question = question;
  } 
  // creo una classe utente con le informazioni richieste nella login page. 
 
}