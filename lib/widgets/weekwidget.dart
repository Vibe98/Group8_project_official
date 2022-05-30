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

class WeekWidget extends StatefulWidget {
  final String username;
  WeekWidget({required this.username});

  @override
  State<WeekWidget> createState() => _WeekWidgetState();
}


class _WeekWidgetState extends State<WeekWidget> {
  final DateRangePickerController _controller = DateRangePickerController();
 
  @override
  Widget build(BuildContext context) {
    List<WeekChart> liststeps =[];
    List<WeekChart> listcalories =[];
    List<WeekChart> listminutesva =[];
    List<WeekChart> listminutesfa =[];
    return Consumer<WeekData>(builder: (context, weekdate, child) {
      return Center(
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          ElevatedButton(
              onPressed: () {
                /*if (weekdate.calendar) {
                 weekdate.changeWeek(dat1, dat2); 
                } */
                weekdate.changeCalendar();
              },
              child: Icon(Icons.calendar_month)),
          SizedBox(width: 10),
          weekdate.calendar == true
              ?  Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 65),
                      height: 150,
                      width: 200,
                      child: Text('${weekdate.datestart.day.toString()}/${weekdate.datestart.month.toString()}/${weekdate.datestart.year.toString()} - ${weekdate.dateend.day.toString()}/${weekdate.dateend.month.toString()}/${weekdate.dateend.year.toString()}',))
                
              : Container(
                  height: 150,
                  width: 150,
                  child: SfDateRangePicker(
                    controller: _controller,
                    view: DateRangePickerView.month,
                    
                    selectionMode: DateRangePickerSelectionMode.range,
                    onSelectionChanged:
                        (DateRangePickerSelectionChangedArgs args) {
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
                      
                      weekdate.changeCalendar();
                      print(weekdate.calendar);
                      
                    },
                    monthViewSettings: DateRangePickerMonthViewSettings(
                        enableSwipeSelection: true),
                  ),
                ),
                
                
        ]),
        
                 Consumer<WeekData>(builder: ((context, value, child) => FutureBuilder(
                   
                  
                   future: fetchweekdata(context, value.datestart),//Provider.of<DataBaseRepository>(context, listen: false).findWeekData(value.datestart.day, value.datestart.month),
                   builder: (context, snapshot) {
                     switch(snapshot.connectionState){
                       case ConnectionState.none:
                       case ConnectionState.waiting:
                        return CircularProgressIndicator();
                       case ConnectionState.done:
                       case ConnectionState.active:
                     
                   if(snapshot.hasData){
                     final weeklist = snapshot.data as List<List<WeekChart>>;

                      List<WeekChart> liststeps = weeklist[0];
                      List<WeekChart> listcalories = weeklist[1];
                      List<WeekChart> listminutesva = weeklist[2];
                      List<WeekChart> listminutesfa = weeklist[3];
                    
                     
                    return  Column(children: [
                     //Text('${liststeps[1].y}')
                              WeekStepChartGraph(
                              data: liststeps,
                              category: 'STEPS'),
                              WeekCaloriesChartGraph(
                              data: listcalories,
                              category: 'CALORIES'),
                              WeekMinChartGraph(
                              data1: listminutesfa, 
                              data2: listminutesva,
                              category1: 'MIN. F. ACTIVE',
                              category2: 'MIN. V. ACTIVE',),]);
                    }
                    else{
                          return CircularProgressIndicator();
                        }}},
                 )))
        

               
           
      ]),
    );});
    
  }
}


Future<List<List<WeekChart>>> fetchweekdata (context, startdate)async{
  List<MyData?> weekdata = await Provider.of<DataBaseRepository>(context, listen:false).findWeekData(startdate.day, startdate.month);
  List<WeekChart> listcalories = [];
  List<WeekChart> liststeps = [];
  List<WeekChart>  listminutesva = [];
  List<WeekChart>  listminutesfa = [];

              
  for(int i=0; i<weekdata.length; i++){
    listcalories.add(WeekChart('${weekdata[i]!.day}/${weekdata[i]!.month}',weekdata[i]!.calories, ColorUtil.fromDartColor(Colors.orange)));
    liststeps.add(WeekChart('${weekdata[i]!.day}/${weekdata[i]!.month}',weekdata[i]!.steps, ColorUtil.fromDartColor(Colors.greenAccent)));
    listminutesva.add(WeekChart('${weekdata[i]!.day}/${weekdata[i]!.month}',weekdata[i]!.minutesva, ColorUtil.fromDartColor(Colors.deepPurple)));
    listminutesfa.add(WeekChart('${weekdata[i]!.day}/${weekdata[i]!.month}',weekdata[i]!.minutesfa, ColorUtil.fromDartColor(Colors.purple)));
    }
  
  
  List<List<WeekChart>> listreturned = [];

  listreturned.add(liststeps);
  listreturned.add(listcalories);
  listreturned.add(listminutesva);
  listreturned.add(listminutesfa);
  return listreturned; 
}
