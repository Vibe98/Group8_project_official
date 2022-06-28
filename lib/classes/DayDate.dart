import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class DayData extends ChangeNotifier{

  DateTime date = DateTime.now(); 
  int day = DateTime.now().day;
  String month = DateFormat('MMMM').format(DateTime.now());
  bool sleep = false;
  int difference = DateTime.now().difference(DateTime.now()).inDays;

  void changeDay(DateTime newdate){
    date = newdate;
    day = newdate.day;
    month= DateFormat('MMMM').format(newdate);
    sleep = false;
    
    notifyListeners();
  }

  void changeSleep(){
    if(sleep){
      sleep = false;
    }else{
      sleep = true;
    }
    notifyListeners();
  }

  void computeDifference(){
    this.difference = DateTime.now().difference(date).inDays;
    notifyListeners();
        
  }

  
}

