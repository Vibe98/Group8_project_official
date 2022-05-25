import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:login_flow/classes/weekchart.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:login_flow/classes/mymonthdata.dart';
import 'package:login_flow/classes/fetchedData.dart';

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
  static DateTime dateinitial = date1.add(Duration(days: (firstDayOfWeek - day1)));
  static String monthselected = DateFormat('MMMM').format(dateinitial);
  List<myMonthData>? steplist = FetchedData.stepsData[monthselected];
  List<WeekStepChart> liststepcharts =  _steps(dateinitial);
  List<WeekStepChart> listcaloriescharts = _calories(dateinitial);
  List<WeekStepChart> listminfai = [];
  List<WeekStepChart> listminve = [];



  void changeWeek(DateTime date1, DateTime date2){
    this.datestart = date1;
    this.dateend = date2;
    this.liststepcharts = [];
    String monthselected = DateFormat('MMMM').format(date1);
    List<myMonthData>? steplist = FetchedData.stepsData[monthselected];
    this.liststepcharts = _steps(date1);
    List<myMonthData>? calorieslist = FetchedData.caloriesData[monthselected];
    this.listcaloriescharts = _calories(date1);
    
    
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

List<WeekStepChart> _steps(datestart){
  String monthselected = DateFormat('MMMM').format(datestart);
  List<myMonthData>? steplist = FetchedData.stepsData[monthselected];
  List<WeekStepChart> liststepcharts = [];
  for(int i = 0; i<steplist!.length; i++){
    print(steplist[i].day);
    if(steplist[i].day == datestart.day.toString()){
      int j = i ;
      int c = 0;
      while(j<=i+7){
        DateTime data = datestart.add(Duration(days:c));
        liststepcharts.add(WeekStepChart(data, c+1, steplist[j].value, ColorUtil.fromDartColor(Colors.orange)));
        j = j+1;
        c = c+1;
        }
    }
  }
  return liststepcharts;
  }


List<WeekStepChart> _calories(datestart){
  String monthselected = DateFormat('MMMM').format(datestart);
  List<myMonthData>? calorieslist = FetchedData.caloriesData[monthselected];
  List<WeekStepChart> listcaloriescharts = [];
  for(int i = 0; i<calorieslist!.length; i++){
    print(calorieslist[i].day);
    if(calorieslist[i].day == datestart.day.toString()){
      int j = i ;
      int c = 0;
      while(j<=i+7){
        DateTime data = datestart.add(Duration(days:c));
        listcaloriescharts.add(WeekStepChart(data, c+1, calorieslist[j].value, ColorUtil.fromDartColor(Colors.orange)));
        j = j+1;
        c = c+1;
        }
    }
  }
  return listcaloriescharts;
  }