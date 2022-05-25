//import 'dart:js_util';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:login_flow/classes/fetchedData.dart';
import 'package:login_flow/classes/myMonthData.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DayData extends ChangeNotifier{

  DateTime date = DateTime.now(); 
  int day = DateTime.now().day;
  String month = DateFormat('MMMM').format(DateTime.now());
  bool calendar = false;
  int difference = DateTime.now().difference(DateTime.now()).inDays;

  num?  steps = _computeStepsData(DateFormat('MMMM').format(DateTime.now()), DateTime.now().day);
  num?  calories = _computeCaloriesData(DateFormat('MMMM').format(DateTime.now()), DateTime.now().day);
  num?  minutesFA = _computeminutesFAData(DateFormat('MMMM').format(DateTime.now()), DateTime.now().day);
  num?  minutesVA = _computeminutesVAData(DateFormat('MMMM').format(DateTime.now()), DateTime.now().day); 

  /*num? steps = 0;
  num? calories = 0;
  num? minutesFA = 0;
  num? minutesVA = 0;*/

  void changeDay(DateTime newdate){
    date = newdate;
    day = newdate.day;
    month= DateFormat('MMMM').format(newdate);
    steps = _computeStepsData(month, day);
    calories = _computeCaloriesData(month, day);
    minutesFA = _computeminutesFAData(month, day);
    minutesVA = _computeminutesVAData(month, day);
    notifyListeners();
  }

  void changeCalendar(){
    if(calendar){
      calendar = false;
    }else{
      calendar = true;
    }
    notifyListeners();
  }

  void computeDifference(){
    this.difference = DateTime.now().difference(date).inDays;
    notifyListeners();
        
  }
  
}

num? _computeStepsData(String month, int day) {

  List<myMonthData>?  stepList = FetchedData.stepsData[month];
  num? steps = 0;
  for(int i = 0; i<stepList!.length; i++ ){
    if (stepList[i].day == day.toString()) {
      steps = stepList[i].value!;
    }
  }
  return steps;
  }

  num? _computeCaloriesData(String month, int day) {

  List<myMonthData>?  caloriesList = FetchedData.caloriesData[month];
  num? calories = 0;
  for(int i = 0; i<caloriesList!.length; i++ ){
    if (caloriesList[i].day == day.toString()) {
      calories = caloriesList[i].value!;
    }
  }
  return calories;
  }

  num? _computeminutesFAData(String month, int day) {

  List<myMonthData>?  minutesFAList = FetchedData.minutesFairlyActiveData[month];
  num? minutesFA = 0;
  for(int i = 0; i<minutesFAList!.length; i++ ){
    if (minutesFAList[i].day == day.toString()) {
      minutesFA = minutesFAList[i].value!;
    }
  }
  return minutesFA;
  }

  num? _computeminutesVAData(String month, int day) {

  List<myMonthData>?  minutesVAList = FetchedData.minutesVeryActiveData[month];
  num? minutesVA = 0;
  for(int i = 0; i<minutesVAList!.length; i++ ){
    if (minutesVAList[i].day == day.toString()) {
      minutesVA = minutesVAList[i].value!;
    }
  }
  return minutesVA;
  }