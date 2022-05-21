import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DayData extends ChangeNotifier{

  DateTime date = DateTime.now(); 
  bool calendar = false;

  void changeDay(DateTime newdate){
    this.date = newdate;
    notifyListeners();
  }

  void changeCalendar(){
    if(calendar){
      this.calendar = false;
    }else{
      this.calendar = true;
    }
    notifyListeners();
  }

  int computeDifference(){
    int difference = DateTime.now().difference(date).inDays;
    notifyListeners();
    return difference;
    
  }
  
}