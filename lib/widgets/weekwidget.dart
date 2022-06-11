import 'package:charts_flutter/flutter.dart';
import 'package:fitbitter/fitbitter.dart';
import 'package:flutter/material.dart';
import 'package:login_flow/database/entities/mydata.dart';
import 'package:login_flow/repository/databaserepository.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../classes/verify_cred.dart';
import '../classes/weekchart.dart';
import '../classes/weekdata.dart';

class WeekWidget extends StatelessWidget {
  final String username;
  WeekWidget({required this.username});

  final DateRangePickerController _controller = DateRangePickerController();
  

  @override
  Widget build(BuildContext context) {
    List<WeekChart> liststeps = [];
    List<WeekChart> listcalories = [];
    List<WeekChart> listminutesva = [];
    List<WeekChart> listminutesfa = [];
    return Consumer<WeekData>(builder: (context, weekdate, child) {
      return Container(
        //Color.fromHex(code: code),
        child: Center(
          child: Column(children: [
            Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              child: Container(
                
                height: 150,
                width: 300,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.amber),
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.black),
                child: SfDateRangePicker(
                  
                  controller: _controller,
                  selectionColor: Colors.amber,
                  rangeSelectionColor: Colors.amber,
                  view: DateRangePickerView.month,
                  selectionMode: DateRangePickerSelectionMode.range,
                  
                  onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                    int firstDayOfWeek = DateTime.sunday % 7;
                    int endDayOfWeek = (firstDayOfWeek - 1) % 7;
                    endDayOfWeek =
                        endDayOfWeek < 0 ? 7 + endDayOfWeek : endDayOfWeek;
                    PickerDateRange ranges = args.value;
                    DateTime date1 = ranges.startDate!;
                    DateTime date2 = (ranges.endDate ?? ranges.startDate)!;
                    if (date1.isAfter(date2)) {
                      var date = date1;
                      date1 = date2;
                      date2 = date;
                    }
                    int day1 = date1.weekday % 7;
                    int day2 = date2.weekday % 7;
      
                    DateTime dat1 =
                        date1.add(Duration(days: (firstDayOfWeek - day1)));
                    DateTime dat2 =
                        date2.add(Duration(days: (endDayOfWeek - day2)));
      
                    _controller.selectedRange = PickerDateRange(dat1, dat2);
                    weekdate.changeWeek(dat1, dat2);
                  },
                  monthViewSettings: DateRangePickerMonthViewSettings(
                      enableSwipeSelection: true),
                ),
              ),),
            
            Consumer<WeekData>(
                builder: ((context, value, child) => FutureBuilder(
                      future: fetchweekdata(
                          context,
                          value
                              .datestart), //Provider.of<DataBaseRepository>(context, listen: false).findWeekData(value.datestart.day, value.datestart.month),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                          case ConnectionState.waiting:
                          
                            return CircularProgressIndicator();
                          case ConnectionState.active:
                          case ConnectionState.done:
                          
                            if (snapshot.hasData) {
                              final weeklist =
                                  snapshot.data as List<List<WeekChart>>;
      
                              List<WeekChart> liststeps = weeklist[0];
                              List<WeekChart> listcalories = weeklist[1];
                              List<WeekChart> listminutesva = weeklist[2];
                              List<WeekChart> listminutesfa = weeklist[3];
      
                              return Column(children: [
                                //Text('${liststeps[1].y}')
                                WeekStepChartGraph(
                                    data: liststeps, category: 'STEPS'),
                                WeekCaloriesChartGraph(
                                    data: listcalories, category: 'CALORIES'),
                                WeekMinChartGraph(
                                  data1: listminutesfa,
                                  data2: listminutesva,
                                  category1: 'MIN. F. ACTIVE',
                                  category2: 'MIN. V. ACTIVE',
                                ),
                              ]);
                            } else {
                              return CircularProgressIndicator();
                            }
                        }
                      },
                    )))
          ]),
        ),
      );
    });
  }
}

Future<List<List<WeekChart>>> fetchweekdata(context, startdate) async {
  List<MyData?> weekdata =
      await Provider.of<DataBaseRepository>(context, listen: false)
          .findWeekData(startdate.day, startdate.month);
  List<WeekChart> listcalories = [];
  List<WeekChart> liststeps = [];
  List<WeekChart> listminutesva = [];
  List<WeekChart> listminutesfa = [];

  for (int i = 0; i < weekdata.length; i++) {
    listcalories.add(WeekChart('${weekdata[i]!.day}/${weekdata[i]!.month}',
        weekdata[i]!.calories, ColorUtil.fromDartColor(Colors.orange)));
    liststeps.add(WeekChart('${weekdata[i]!.day}/${weekdata[i]!.month}',
        weekdata[i]!.steps, ColorUtil.fromDartColor(Colors.greenAccent)));
    listminutesva.add(WeekChart('${weekdata[i]!.day}/${weekdata[i]!.month}',
        weekdata[i]!.minutesva, ColorUtil.fromDartColor(Colors.deepPurple)));
    listminutesfa.add(WeekChart('${weekdata[i]!.day}/${weekdata[i]!.month}',
        weekdata[i]!.minutesfa, ColorUtil.fromDartColor(Colors.purple)));
  }

  List<List<WeekChart>> listreturned = [];

  listreturned.add(liststeps);
  listreturned.add(listcalories);
  listreturned.add(listminutesva);
  listreturned.add(listminutesfa);
  return listreturned;
}
