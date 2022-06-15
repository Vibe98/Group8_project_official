//import 'dart:js_util';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:login_flow/classes/myMonthData.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DayData extends ChangeNotifier{

  DateTime date = DateTime.now(); 
  int day = DateTime.now().day;
  String month = DateFormat('MMMM').format(DateTime.now());
  bool sleep = false;
  int difference = DateTime.now().difference(DateTime.now()).inDays;

  

  /*num steps = 0;
  num calories = 0;
  num minutesFA = 0;
  num minutesVA = 0;*/

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

