import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../database/entities/mydata.dart';
import '../utils/utils.dart';

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
         const TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.white)),
         DateTime(DateTime.now().year, data[dayId]!.month, data[dayId]!.day).difference(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)).inDays >= 0
          ? Padding(
            padding: const EdgeInsets.all(10.0),
            child: Image.asset(
                    'assets/images/germoglio1.png',
                    fit: BoxFit.cover, scale: 10, width: 100, height: 100),
          )
          :
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

