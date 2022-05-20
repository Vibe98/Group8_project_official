import 'package:flutter/material.dart';
import 'package:login_flow/classes/weekchart.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class WeekData extends ChangeNotifier{

  static DateTime date1 = DateTime.now();
  static DateTime date2 = DateTime.now();
  static int day1 = date1.weekday % 7;
  static int day2 = date2.weekday % 7;
  static int firstDayOfWeek = DateTime.sunday % 7;
  static int endDayOfWeek = (firstDayOfWeek - 1) % 7;
  
  DateTime datestart =
        date1.add(Duration(days: (firstDayOfWeek - day1)));
  DateTime dateend =
        date2.add(Duration(days: (endDayOfWeek - day2)));
  bool calendar = false;

  void changeWeek(DateTime date1, DateTime date2){
    this.datestart = date1;
    this.dateend = date2;
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
}

