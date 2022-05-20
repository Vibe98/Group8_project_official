import 'package:charts_flutter/flutter.dart';
import 'package:fitbitter/fitbitter.dart';
import 'package:flutter/material.dart';
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
          weekdate.calendar == false
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
                          
                    },
                    monthViewSettings: DateRangePickerMonthViewSettings(
                        enableSwipeSelection: false),
                  ),
                ),
        ]),
        // se difference è diverso da 0 allora visualizzare i dati relativi alla settimana scelta.

        Consumer<VerifyCredentials>(builder: ((context, value, child) => 
          FutureBuilder(
                  future: _fetchweekdata(
                      weekdate.dateend,
                      value.credentials[username].userID),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState){

                      case ConnectionState.none:
                        return CircularProgressIndicator();
                      case ConnectionState.waiting:
                        if(weekdate.calendar) {
                           if (snapshot.hasData) {
                          final fitbitmap = snapshot.data as Map<String, dynamic>;
                          final fitbitstep = fitbitmap['steps'] as List<FitbitActivityTimeseriesData>;
                          // steps
                          List<WeekStepChart> liststepcharts = [];
                          for (int i=0; i<fitbitstep.length; i++){
                            liststepcharts.add( WeekStepChart((fitbitstep[i].dateOfMonitoring), i+1, fitbitstep[i].value, ColorUtil.fromDartColor(Colors.green)));
                          }

                          // calories
                          final fitbitcalo = fitbitmap['calories'] as List<FitbitActivityTimeseriesData>;
                          print(fitbitcalo);
                          List<WeekStepChart> listcaloriescharts = [];
                          for (int i=0; i<fitbitcalo.length; i++){
                            listcaloriescharts.add( WeekStepChart((fitbitcalo[i].dateOfMonitoring), i+1, fitbitcalo[i].value, ColorUtil.fromDartColor(Colors.green)));
                          }
                          return Column(children: [
                            WeekStepChartGraph(
                            data: liststepcharts,
                            category: 'steps'),
                            WeekStepChartGraph(
                              data: listcaloriescharts,
                              category: 'calories',)]); 
                        } else {
                          List<WeekStepChart> listcharts = [];
                          return CircularProgressIndicator();
                        }} else {
                             return CircularProgressIndicator();};
                      case ConnectionState.active:
                      case ConnectionState.done :
                        if (snapshot.hasData) {
                          final fitbitmap = snapshot.data as Map<String, dynamic>;
                          final fitbitstep = fitbitmap['steps'] as List<FitbitActivityTimeseriesData>;
                          
                          // steps
                          List<WeekStepChart> liststepcharts = [];
                          for (int i=0; i<fitbitstep.length; i++){
                            liststepcharts.add( WeekStepChart((fitbitstep[i].dateOfMonitoring), i+1, fitbitstep[i].value, ColorUtil.fromDartColor(Colors.green)));
                          }

                          // calories
                          final fitbitcalo = fitbitmap['calories'] as List<FitbitActivityTimeseriesData>;
                          
                          List<WeekStepChart> listcaloriescharts = [];
                          for (int i=0; i<fitbitcalo.length; i++){
                            listcaloriescharts.add( WeekStepChart((fitbitcalo[i].dateOfMonitoring), i+1, fitbitcalo[i].value, ColorUtil.fromDartColor(Colors.green)));
                          }

                          // minutes fairly active
                          final fitbitminfai = fitbitmap['minfai'] as List<FitbitActivityTimeseriesData>;
                          List<WeekStepChart> listminfai = [];
                          for (int i=0; i<fitbitcalo.length; i++){
                            listminfai.add( WeekStepChart((fitbitminfai[i].dateOfMonitoring), i+1, fitbitminfai[i].value, ColorUtil.fromDartColor(Colors.orange)));
                          }

                          // // minutes very active
                          final fitbitminver = fitbitmap['minver'] as List<FitbitActivityTimeseriesData>;
                          List<WeekStepChart> listminve = [];
                          for (int i=0; i<fitbitcalo.length; i++){
                            listminve.add( WeekStepChart((fitbitminver[i].dateOfMonitoring), i+1, fitbitminver[i].value, ColorUtil.fromDartColor(Colors.deepOrange)));
                          }
                          
                          return Column(children: [
                            WeekStepChartGraph(
                            data: liststepcharts,
                            category: 'STEPS'),
                            WeekStepChartGraph(
                            data: listcaloriescharts,
                            category: 'CALORIES',),
                            WeekMinChartGraph(data1: listminve, category1: 'Minutes very active', data2: listminfai, category2: 'Minutes fairly active')
                            ]);
                          
                           
                        } else {
                          List<WeekStepChart> listcharts = [];
                          return CircularProgressIndicator();
                        }}
                  }
                  )))
               
           
      ]),
    );});
    
  }
}

Future<Map<String, dynamic>>  _fetchweekdata(weekdata, userID)async{
  // steps
  FitbitActivityTimeseriesDataManager fitbitActivityTimeseriesDataManagersteps = FitbitActivityTimeseriesDataManager(
    clientID: '238C5P',
    clientSecret: '8b6a58492553191918d2cce62a2052c6',
    type: 'steps',
  );
  FitbitActivityTimeseriesAPIURL fitbitActivityApiUrlsteps = FitbitActivityTimeseriesAPIURL.weekWithResource(
    baseDate: weekdata,
    userID: userID,
    resource: 'steps',
  );
  final fitbitsteps = await fitbitActivityTimeseriesDataManagersteps
      .fetch(fitbitActivityApiUrlsteps) as List<FitbitActivityTimeseriesData>;
  print(fitbitsteps.length);
  
  // calories  
  FitbitActivityTimeseriesDataManager fitbitActivityTimeseriesDataManagercalories = FitbitActivityTimeseriesDataManager(
    clientID: '238C5P',
    clientSecret: '8b6a58492553191918d2cce62a2052c6',
    type: 'activityCalories',
  );
  FitbitActivityTimeseriesAPIURL fitbitActivityApiUrlcalories = FitbitActivityTimeseriesAPIURL.weekWithResource(
    baseDate: weekdata,
    userID: userID,
    resource: 'activityCalories',
  );
  final fitbitcalories = await fitbitActivityTimeseriesDataManagercalories
      .fetch(fitbitActivityApiUrlcalories) as List<FitbitActivityTimeseriesData>;

 
  
  // minutesfairlyactive
  FitbitActivityTimeseriesDataManager fitbitActivityTimeseriesDataManagermin1 = FitbitActivityTimeseriesDataManager(
    clientID: '238C5P',
    clientSecret: '8b6a58492553191918d2cce62a2052c6',
    type: 'minutesFairlyActive',
  );
  FitbitActivityTimeseriesAPIURL fitbitActivityApiUrlmin1 = FitbitActivityTimeseriesAPIURL.weekWithResource(
    baseDate: weekdata,
    userID: userID,
    resource: 'minutesFairlyActive',
  );
  final fitbitmin1 = await fitbitActivityTimeseriesDataManagermin1
      .fetch(fitbitActivityApiUrlmin1) as List<FitbitActivityTimeseriesData>;


  // minutesVeryActive
  FitbitActivityTimeseriesDataManager fitbitActivityTimeseriesDataManagermin2 = FitbitActivityTimeseriesDataManager(
    clientID: '238C5P',
    clientSecret: '8b6a58492553191918d2cce62a2052c6',
    type: 'minutesVeryActive',
  );
  FitbitActivityTimeseriesAPIURL fitbitActivityApiUrlmin2 = FitbitActivityTimeseriesAPIURL.weekWithResource(
    baseDate: weekdata,
    userID: userID,
    resource: 'minutesVeryActive',
  );
  final fitbitmin2 = await fitbitActivityTimeseriesDataManagermin2
      .fetch(fitbitActivityApiUrlmin2) as List<FitbitActivityTimeseriesData>;
  
  Map<String, dynamic> fitmapdata = {};
  fitmapdata['steps'] = fitbitsteps;
  fitmapdata['calories'] = fitbitcalories;
  fitmapdata['minfai'] = fitbitmin1;
  fitmapdata['minver'] = fitbitmin2;
  return fitmapdata;
}