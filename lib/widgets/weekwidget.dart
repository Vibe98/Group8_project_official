import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:login_flow/database/entities/mydata.dart';
import 'package:login_flow/repository/databaserepository.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../classes/weekchart.dart';
import '../classes/weekdata.dart';

class WeekWidget extends StatelessWidget {
  final String username;
  WeekWidget({required this.username});

  final DateRangePickerController _controller = DateRangePickerController();
  

  @override
  Widget build(BuildContext context) {
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
                
                height: 170,
                width: 300,
                decoration: BoxDecoration(
                 
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.black),
                child: SfDateRangePicker(
                  
                  controller: _controller,
                  
                  rangeSelectionColor: Colors.amber,
                  view: DateRangePickerView.month,
                  selectionMode: DateRangePickerSelectionMode.range,
                  monthViewSettings: const DateRangePickerMonthViewSettings(
                        showTrailingAndLeadingDates: true,
                        viewHeaderStyle: DateRangePickerViewHeaderStyle(
                            textStyle: TextStyle(color: Colors.white)),
                        enableSwipeSelection: true),
                    headerStyle: const DateRangePickerHeaderStyle(
                        textStyle: TextStyle(color: Colors.white)),
                    yearCellStyle: const DateRangePickerYearCellStyle(
                      disabledDatesTextStyle: TextStyle(color: Colors.grey),
                      textStyle: TextStyle(color: Colors.white),
                      todayTextStyle: TextStyle(color: Colors.white),
                    ),
                    selectionColor: Colors.transparent,
                    selectionTextStyle: const TextStyle(color: Colors.amber),
                    monthCellStyle: const DateRangePickerMonthCellStyle(
                      trailingDatesTextStyle: TextStyle(color: Colors.grey),
                      leadingDatesTextStyle: TextStyle(color: Colors.grey),
                      disabledDatesTextStyle:
                          TextStyle(color: Color.fromARGB(255, 95, 91, 91)),
                      textStyle: TextStyle(color: Colors.white),
                      todayTextStyle: TextStyle(color: Colors.orange),
                    ),
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
        weekdata[i]!.calories, charts.ColorUtil.fromDartColor(Colors.orange)));
    liststeps.add(WeekChart('${weekdata[i]!.day}/${weekdata[i]!.month}',
        weekdata[i]!.steps, charts.ColorUtil.fromDartColor(Colors.greenAccent)));
    listminutesva.add(WeekChart('${weekdata[i]!.day}/${weekdata[i]!.month}',
        weekdata[i]!.minutesva, charts.ColorUtil.fromDartColor(Colors.deepPurple)));
    listminutesfa.add(WeekChart('${weekdata[i]!.day}/${weekdata[i]!.month}',
        weekdata[i]!.minutesfa, charts.ColorUtil.fromDartColor(Colors.purple)));
  }

  List<List<WeekChart>> listreturned = [];

  listreturned.add(liststeps);
  listreturned.add(listcalories);
  listreturned.add(listminutesva);
  listreturned.add(listminutesfa);
  return listreturned;
}
