import 'dart:io';

import 'package:flutter/cupertino.dart';

class Profile{

  String? name;
  String? surname;
  String? username;
  String? password;
  String? email;
  File? image;
  String userID = '';


  @override 
  Profile(String name, String surname, String username, String password, String email, File? image){
    this.name = name;
    this.surname = surname;
    this.password = password;
    this.username = username;
    this.email = email;
    this.image = image;
  }
  // creo una classe utente con le informazioni richieste nella login page. 
 
}