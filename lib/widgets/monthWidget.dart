import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:login_flow/repository/databaserepository.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';


import '../classes/changeMonth.dart';
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
          child: Container(
            color: Colors.grey,
            child: ListView(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Card(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          child: IconButton(
                              onPressed: () {
                                // one month back
                                if(pickmonth.month>3){
                                  pickmonth.decreaseMonth();
                                }else{
                                  null;
                                }
                              },
                              icon: Icon(Icons.arrow_back_ios, color: Colors.blue)),
                        ),
                        Card(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          child: Container(
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
                        ),
                        Card(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          child: IconButton(
                              onPressed: () {
                                pickmonth.increaseMonth();
                              },
                              icon:
                                  Icon(Icons.arrow_forward_ios, color: Colors.blue)),
                        ),
                      ],
                    ),
                     
                      FutureBuilder(
                        initialData: null,
                        future: fetchMonthData(context, pickmonth.month),
                        builder: (context, snapshot){
                          switch(snapshot.connectionState){
                         case ConnectionState.none:
                         case ConnectionState.waiting:
                          return CircularProgressIndicator();
                         case ConnectionState.done:
                         case ConnectionState.active:
                          if(snapshot.hasData){
                            final monthMap = snapshot.data as Map<String, List<List<myMonthData>>>;
                            List<List<myMonthData>> monthData = monthMap[DateFormat('MMMM').format(DateTime(0,pickmonth.month))]!;
                            List<myMonthData> stepsData = monthData[0];
                            List<myMonthData> calData = monthData[1];
                            List<myMonthData> minVAData = monthData[2];
                            List<myMonthData> minFAData = monthData[3];

                            return Column(
                              children: [
    
                              MonthStepsChartGraph(data: stepsData, month: pickmonth.month, category: 'Steps'),
                              MonthCaloriesChartGraph(data: calData, month: pickmonth.month, category: 'Calories'),
                              MonthMinChartGraph(data1: minVAData, data2: minFAData, category1: 'Minutes Very Active', category2: 'Minutes Fairly Active'),
                              ],
                        );
                          }else{
                            return CircularProgressIndicator();
                          }}}
                        
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }
}

Future<Map<String, List<List<myMonthData>>>> fetchMonthData(context, month) async {
List<MyData?> monthData = await Provider.of<DataBaseRepository>(context, listen:false).findMonthDatas(month);
print('ciao: ${monthData.length}');
List<myMonthData> stepsList = [];
List<myMonthData> calList = [];
List<myMonthData> minVAList = [];
List<myMonthData> minFAList = [];
for(var i=0;i<monthData.length;i++){
  myMonthData steps = myMonthData(day: monthData[i]!.day.toString(), month: monthData[i]!.month.toString(), value: monthData[i]!.steps, barColor: charts.ColorUtil.fromDartColor(Colors.greenAccent));
  stepsList.add(steps);
  myMonthData calories = myMonthData(day: monthData[i]!.day.toString(), month: monthData[i]!.month.toString(), value: monthData[i]!.calories, barColor: charts.ColorUtil.fromDartColor(Colors.orange));
  calList.add(calories);
  myMonthData minFA = myMonthData(day: monthData[i]!.day.toString(), month: monthData[i]!.month.toString(), value: monthData[i]!.minutesfa, barColor: charts.ColorUtil.fromDartColor(Colors.purple));
  minFAList.add(minFA);
  myMonthData minVA = myMonthData(day: monthData[i]!.day.toString(), month: monthData[i]!.month.toString(), value: monthData[i]!.minutesva, barColor: charts.ColorUtil.fromDartColor(Colors.deepPurple));
  minVAList.add(minVA);
}

List<List<myMonthData>> monthList = [];
monthList.add(stepsList);
monthList.add(calList);
monthList.add(minVAList);
monthList.add(minFAList);

Map<String, List<List<myMonthData>>> monthReturned = {};
monthReturned[DateFormat('MMMM').format(DateTime(0, month))] = monthList;

return monthReturned;

}