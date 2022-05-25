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
        Consumer<WeekData>(builder:((context, value, child) =>
                 Column(children: [
                            WeekStepChartGraph(
                            data: value.liststepcharts,
                            category: 'STEPS'),
                            WeekStepChartGraph(
                            data: value.listcaloriescharts,
                            category: 'CALORIES'),])))
        

               
           
      ]),
    );});
    
  }
}

/*
Future<Map<String, dynamic>>  _fetchweekdata(startdate, enddate, userID)async{
  // steps
  FitbitActivityTimeseriesDataManager fitbitActivityTimeseriesDataManagersteps = FitbitActivityTimeseriesDataManager(
    clientID: '238C5P',
    clientSecret: '8b6a58492553191918d2cce62a2052c6',
    type: 'steps',
  );
  FitbitActivityTimeseriesAPIURL fitbitActivityApiUrlsteps = FitbitActivityTimeseriesAPIURL.weekWithResource(
    baseDate: enddate,
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
    baseDate: enddate,
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
    baseDate: enddate,
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
    baseDate: enddate,
    userID: userID,
    resource: 'minutesVeryActive',
  );
  final fitbitmin2 = await fitbitActivityTimeseriesDataManagermin2
      .fetch(fitbitActivityApiUrlmin2) as List<FitbitActivityTimeseriesData>;
  
  // sleep
   FitbitSleepDataManager fitbitSleepDataManager = FitbitSleepDataManager(
        clientID: '238C5P',
        clientSecret: '8b6a58492553191918d2cce62a2052c6',
    );
  
  FitbitSleepAPIURL fitbitSleepAPIURL = FitbitSleepAPIURL.withUserIDAndDateRange(
                                    startDate: startdate,
                                    endDate: enddate,
                                    userID: userID,
                                  );

  final fitbitsleep = await fitbitSleepDataManager.fetch(fitbitSleepAPIURL) as Map<String, FitbitSleepData>;

  print(fitbitsleep);
  Map<String, dynamic> fitmapdata = {};
  fitmapdata['steps'] = fitbitsteps;
  fitmapdata['calories'] = fitbitcalories;
  fitmapdata['minfai'] = fitbitmin1;
  fitmapdata['minver'] = fitbitmin2;
  fitmapdata['sleep'] = fitbitsleep;
  return fitmapdata;
}*/