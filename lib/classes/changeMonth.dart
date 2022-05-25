import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PickMonth extends ChangeNotifier {
  
  // inizializziamo intanto il mese
  int month=DateTime.now().month;
  int year=DateTime.now().year;

  // restituisve semplicemente il mese
  int getMonth(){
    return month;
  }

  int getYear(){
    return year;
  }

  void increaseMonth(){
    // se il mese è quello corrente non si può aumentare
    if(month!=DateTime.now().month){
      // controllo che non sia dicembre
      if(month==12){
        year=year+1;
        month=1;
      }else{
        month = month+1;
      }
    }else{
      null;
    }
    notifyListeners();
  }

  void decreaseMonth(){
    if(month==1){
      // se è gennaio torno a dicembre
      month=12;
      year=year-1;
    }else{
      month=month-1;
    }
    notifyListeners();
  }
}