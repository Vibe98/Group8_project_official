import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../database/entities/mydata.dart';

class VisualizeDayTomato extends StatelessWidget {
  final int dayId;
  final List<MyData?> data;
  


  VisualizeDayTomato({required this.dayId, required this.data});
  


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        
        Text('${DateFormat('EEEE').format(DateTime.parse('${DateTime.now().year}-${modifyDate(data[dayId]!.month)}-${modifyDate(data[dayId]!.day)}'))} ${data[dayId]!.day}/${data[dayId]!.month}', style:
         TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.white)),
         data[dayId]!.tomatos!
          ? Image.asset(
                  'assets/images/pomodoro_felice.png',
                  fit: BoxFit.cover, scale: 10, width: 120, height: 150)
          : Image.asset(
                  'assets/images/pomodoro_triste.png',
                  fit: BoxFit.cover, scale: 10, width: 120, height: 150)
      ]);
  }
}

String modifyDate(int date){
    //modifica mese o giorno aggiungendo 0 se inizia con un numero minore di 10
    String newDate='';
    if(date<10){
      newDate = '0$date';
    }else{
      newDate = '$date';
    }

    return newDate;
  }