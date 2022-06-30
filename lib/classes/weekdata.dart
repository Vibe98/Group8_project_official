import 'package:flutter/material.dart';

class WeekDate{

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
  DateTime? datestartold;
  DateTime? dateendold;
  


  void changeWeek(DateTime date1, DateTime date2){
    this.datestart = date1;
    this.dateend = date2;
    
  }

}

class WeekData extends ChangeNotifier{
  static WeekDate weekdate = WeekDate();
  static WeekDate gardendate = WeekDate();

  Map<String, WeekDate> pageWeek = {
    'WeekWidget': weekdate,
    'Garden': gardendate 
  };

  void changeWeek(String key, DateTime date1, DateTime date2){
    pageWeek[key]!.changeWeek(date1, date2);
    notifyListeners();
  }
}