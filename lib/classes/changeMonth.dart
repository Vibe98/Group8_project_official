import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PickMonth extends ChangeNotifier {
  
  
  int month=DateTime.now().month;
  int year=DateTime.now().year;

 
  int getMonth(){
    return month;
  }

  int getYear(){
    return year;
  }

  void increaseMonth(){
    
    if(month!=DateTime.now().month){
      
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
     
      month=12;
      year=year-1;
    }else{
      month=month-1;
    }
    notifyListeners();
  }
}