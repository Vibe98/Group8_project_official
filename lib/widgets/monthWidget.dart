import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:login_flow/repository/databaserepository.dart';
import 'package:provider/provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import '../classes/changeMonth.dart';
import '../classes/fetchedData.dart';
import '../classes/monthChartGraph.dart';
import '../classes/myMonthData.dart';
import '../database/entities/mydata.dart';


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
                  
                  Consumer<DataBaseRepository>(
                    builder:(context, db, child) => 
                    FutureBuilder(
                      initialData: null,
                      future: db.findMonthDatas(pickmonth.month),
                      builder: (context, snapshot){
                        if(snapshot.hasData){
                          final monthData = snapshot.data as List<MyData?>;
                          
                          // riempio la variabile fetchedData.stepsData
                          List<myMonthData> stepsList = [];
                          for(var i=0;i<monthData.length;i++){
                            myMonthData steps = myMonthData(day: monthData[i]!.day.toString(), month: monthData[i]!.month.toString(), value: monthData[i]!.steps, barColor: charts.Color(r:0, b:0, g:100));
                            stepsList.add(steps);
                          }

                          FetchedData.stepsData.putIfAbsent(DateFormat('MMMM').format(DateTime(0, pickmonth.month)), () => stepsList);

                          // riempio la variabile fetchedData.caloriesData
                          List<myMonthData> calList = [];
                          for(var i=0;i<monthData.length;i++){
                            myMonthData calories = myMonthData(day: monthData[i]!.day.toString(), month: monthData[i]!.month.toString(), value: monthData[i]!.calories, barColor: charts.Color(r:0, b:0, g:100));
                            calList.add(calories);
                          }

                          FetchedData.caloriesData.putIfAbsent(DateFormat('MMMM').format(DateTime(0, pickmonth.month)), () => calList);

                          // riempio la variabile fetchedData.minutesFairlyActiveData
                          List<myMonthData> minFAList = [];
                          for(var i=0;i<monthData.length;i++){
                            myMonthData minFA = myMonthData(day: monthData[i]!.day.toString(), month: monthData[i]!.month.toString(), value: monthData[i]!.minutesfa, barColor: charts.Color(r:0, b:0, g:100));
                            minFAList.add(minFA);
                          }

                          FetchedData.minutesFairlyActiveData.putIfAbsent(DateFormat('MMMM').format(DateTime(0, pickmonth.month)), () => minFAList);

                          // riempio la variabile fetchedData.minutesVeryActiveData
                          List<myMonthData> minVAList = [];
                          for(var i=0;i<monthData.length;i++){
                            myMonthData minVA = myMonthData(day: monthData[i]!.day.toString(), month: monthData[i]!.month.toString(), value: monthData[i]!.minutesva, barColor: charts.Color(r:0, b:0, g:100));
                            minVAList.add(minVA);
                          }

                          FetchedData.minutesVeryActiveData.putIfAbsent(DateFormat('MMMM').format(DateTime(0, pickmonth.month)), () => minVAList);

                          return Column(
                            children: [
                              Text('${pickmonth.month}'),
                              Text('${FetchedData.stepsData[DateFormat('MMMM').format(DateTime(0,pickmonth.month))]![1].value}'),
    
                            MonthChartGraph(data: FetchedData.stepsData[DateFormat('MMMM').format(DateTime(0,pickmonth.month))]!, month: pickmonth.month, category: 'Steps',),
                            MonthChartGraph(data: FetchedData.caloriesData[DateFormat('MMMM').format(DateTime(0,pickmonth.month))]!, month: pickmonth.month, category: 'Calories',),
                            MonthMinChartGraph(data1: FetchedData.minutesVeryActiveData[DateFormat('MMMM').format(DateTime(0,pickmonth.month))]!, data2: FetchedData.minutesFairlyActiveData[DateFormat('MMMM').format(DateTime(0,pickmonth.month))]!, category1: 'Minutes Very Active', category2: 'Minutes Fairly Active'),
                            ],
                      );
                        }else{
                          return CircularProgressIndicator();
                        }}
                      
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
}
