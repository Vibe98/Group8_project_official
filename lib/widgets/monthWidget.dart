import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../classes/changeMonth.dart';
import '../classes/fetchedData.dart';
import '../classes/monthChartGraph.dart';


class MonthWidget extends StatelessWidget {

    final String username;

    MonthWidget({required this.username});

    @override 
    Widget build(BuildContext context){

      return Consumer<PickMonth>(
        builder: (context, pickmonth, child) => Center(
          child: ListView(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                          onPressed: () {
                            // one month back
                            if(DateTime.now().month-pickmonth.month<3){
                              pickmonth.decreaseMonth();
                            }else{
                              null;
                            }
                          },
                          icon: Icon(Icons.arrow_back_ios, color: Colors.blue)),
                      Container(
                          child: Center(
                            child: Text(
                                '${DateFormat('MMMM').format(DateTime(0, pickmonth.getMonth()))} ${pickmonth.getYear()}',
                                style: TextStyle(fontSize: 18),
                                textAlign: TextAlign.center),
                          ),
                          width: 200,
                          height: 50,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue),
                          )),
                      IconButton(
                          onPressed: () {
                            pickmonth.increaseMonth();
                          },
                          icon:
                              Icon(Icons.arrow_forward_ios, color: Colors.blue)),
                    ],
                  ),
                  
                  Column(
                    children: [
                    
                      MonthChartGraph(data: FetchedData.stepsData[DateFormat('MMMM').format(DateTime(0,pickmonth.month))]!, month: pickmonth.month, category: 'Steps',),
                      MonthChartGraph(data: FetchedData.caloriesData[DateFormat('MMMM').format(DateTime(0,pickmonth.month))]!, month: pickmonth.month, category: 'Calories',),
                      MonthMinChartGraph(data1: FetchedData.minutesVeryActiveData[DateFormat('MMMM').format(DateTime(0,pickmonth.month))]!, data2: FetchedData.minutesFairlyActiveData[DateFormat('MMMM').format(DateTime(0,pickmonth.month))]!, category1: 'Minutes Very Active', category2: 'Minutes Fairly Active'),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
}
