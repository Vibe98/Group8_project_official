import 'package:fitbitter/fitbitter.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../classes/verify_cred.dart';
import '../classes/DayDate.dart';

class DayWidget extends StatelessWidget {
  final String username;

  DayWidget({required this.username});

  @override
  Widget build(BuildContext context) {
    return Consumer<DayData>(builder: (context, daydate, child) {
      return Center(
          child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          ElevatedButton(
              onPressed: () {
                daydate.changeCalendar();
              },
              child: Icon(Icons.calendar_month)),
          SizedBox(width: 50),
          daydate.calendar == false
              ? Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 55),
                  height: 150,
                  width: 150,
                  child: Container(
                    height: 50,
                    width: 80,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Center(
                      child: Text(
                          ' ${daydate.date.day.toString()} - ${daydate.date.month.toString()} - ${daydate.date.year.toString()}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17)),
                    ),
                  ))
              : Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: SfDateRangePicker(
                    view: DateRangePickerView.month,
                    minDate: DateTime(2022, 04, 01),
                    maxDate: DateTime.now(),
                    onSelectionChanged:
                        (DateRangePickerSelectionChangedArgs args) {
                      final dynamic value = args.value;
                      daydate.changeDay(value);
                      //int difference = daydate.computeDifference();
                    },
                  )),
        ]), // ROW

        Consumer<VerifyCredentials>(
          builder: ((context, value, child) => Column(children: [
                    Container(
                      height: 60,
                      width: 350,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 11),
                      margin: const EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueAccent),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Row(
                        children: [
                          Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Color.fromARGB(255, 153, 211, 155),
                                    width: 2,
                                  )),
                              child: Icon(MdiIcons.run,
                                  size: 30, color: Colors.green)),
                          SizedBox(width: 30),
                          Column(
                            children: [
                              Text('STEPS:',
                                  style: TextStyle(
                                      //color: Colors.blue,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 15)),
                              Text('DISTANCE:',
                                  style: TextStyle(
                                      //color: Colors.blue,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 15)),
                            ],
                          ),
                          //SizedBox(width: 30),
                          Column(
                            children: [
                              FutureBuilder(
                                  future: computeDayData(
                                      "steps",
                                      daydate.computeDifference(),
                                      value.credentials[username].userID),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      final StepsData = snapshot.data as List;
                                      print(StepsData);
                                      return Text(
                                          StepsData[0].value.toStringAsFixed(0),
                                          style: TextStyle(
                                              //color: Colors.blue,
                                              fontWeight: FontWeight.w500,
                                              fontStyle: FontStyle.normal,
                                              fontSize: 20));
                                    } else {
                                      return Text('');
                                    }
                                  }),
                              FutureBuilder(
                                  future: computeDayData(
                                      "distance",
                                      daydate.computeDifference(),
                                      value.credentials[username].userID),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      final DistanceData =
                                          snapshot.data as List;
                                      print(DistanceData);
                                      return Text(
                                          '${DistanceData[0].value.toStringAsFixed(2)} km',
                                          style: TextStyle(
                                              //color: Colors.blue,
                                              fontWeight: FontWeight.w500,
                                              fontStyle: FontStyle.normal,
                                              fontSize: 20));
                                    } else {
                                      return Text('');
                                    }
                                  }),
                            ],
                          ),
                        ],
                      ),
                    ),

                    //SizedBox(height: 1),
                    Container(
                      height: 60,
                      width: 350,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      margin: const EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueAccent),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Row(
                        children: [
                          Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Color.fromARGB(255, 216, 159, 105),
                                    width: 2,
                                  )),
                              child: Icon(MdiIcons.fire,
                                  size: 30,
                                  color: Color.fromARGB(255, 223, 124, 25))),
                          SizedBox(width: 30),
                          Text('CALORIES:',
                              style: TextStyle(
                                  //color: Colors.blue,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 20)),
                          SizedBox(width: 50),
                          FutureBuilder(
                              future: computeDayData(
                                  "activityCalories",
                                  daydate.computeDifference(),
                                  value.credentials[username].userID),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final caloriesData = snapshot.data as List;
                                  print(caloriesData);
                                  return Text(
                                      caloriesData[0].value.toStringAsFixed(0),
                                      style: TextStyle(
                                          //color: Colors.blue,
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle.normal,
                                          fontSize: 20));
                                } else {
                                  return Text('');
                                }
                              }),
                        ],
                      ),
                    ),
                    Container(
                      height: 60,
                      width: 350,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      margin: const EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueAccent),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Row(
                        children: [
                          Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Color.fromARGB(255, 127, 157, 209),
                                    width: 2,
                                  )),
                              child: Icon(MdiIcons.moonWaxingCrescent,
                                  size: 30,
                                  color: Color.fromARGB(255, 6, 12, 70))),
                          SizedBox(width: 30),
                          Text('SLEEP:',
                              style: TextStyle(
                                  //color: Colors.blue,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 20)),
                          SizedBox(width: 50),
                          FutureBuilder(
                              future: computeSleepData(daydate.computeDifference(),
                                  value.credentials[username].userID),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final SleepData = snapshot.data as List;
                                  print(SleepData);
                                  if (SleepData.isEmpty) {
                                    return Text('- - -');
                                  } else {
                                    DateTime? dt1 = SleepData[0].entryDateTime;
                                    DateTime? dt2 =
                                        SleepData.last.entryDateTime;
                                    Duration? diff = dt2!.difference(dt1!);

                                    final int hour = diff.inMinutes ~/ 60;
                                    final int minutes = diff.inMinutes % 60;
                                    final String finaldata =
                                        '${hour.toString().padLeft(2, "0")}:${minutes.toString().padLeft(2, "0")}';

                                    return Text(finaldata,
                                        style: TextStyle(
                                            //color: Colors.blue,
                                            fontWeight: FontWeight.w500,
                                            fontStyle: FontStyle.normal,
                                            fontSize: 20));
                                  }
                                } else {
                                  return Text('');
                                }
                              }),
                        ],
                      ),
                    ),

                    Container(
                      height: 60,
                      width: 350,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 11),
                      margin: const EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueAccent),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Row(children: [
                        Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Color.fromARGB(255, 216, 130, 178),
                                  width: 2,
                                )),
                            child: Icon(MdiIcons.human,
                                size: 30, color: Color.fromARGB(255, 113, 13, 100))),
                        SizedBox(width: 30),
                        Column(
                          children: [
                            Text('MINUTES VERY ACTIVE:',
                                style: TextStyle(
                                    //color: Colors.blue,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 15)),
                            Text('MINUTES FAIRLY ACTIVE:',
                                style: TextStyle(
                                    //color: Colors.blue,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 15)),
                          ],
                        ),
                        SizedBox(width: 30),
                        Column(
                          children: [
                            FutureBuilder(
                                future: computeDayData(
                                    "minutesVeryActive",
                                    daydate.computeDifference(),
                                    value.credentials[username].userID),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    final VeryActiveData =
                                        snapshot.data as List;
                                    print(VeryActiveData);
                                    return Text(
                                        VeryActiveData[0].value.toString(),
                                        style: TextStyle(
                                            //color: Colors.blue,
                                            fontWeight: FontWeight.w500,
                                            fontStyle: FontStyle.normal,
                                            fontSize: 20));
                                  } else {
                                    return Text('');
                                  }
                                }),
                            FutureBuilder(
                                future: computeDayData(
                                    "minutesFairlyActive",
                                    daydate.computeDifference(),
                                    value.credentials[username].userID),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    final FairlyActiveData =
                                        snapshot.data as List;
                                    print(FairlyActiveData);
                                    return Text(
                                        FairlyActiveData[0].value.toString(),
                                        style: TextStyle(
                                            //color: Colors.blue,
                                            fontWeight: FontWeight.w500,
                                            fontStyle: FontStyle.normal,
                                            fontSize: 20));
                                  } else {
                                    return Text('');
                                  }
                                }),
                          ],
                        ), // column
                      ]), // row
                    ), // container
                  ])
              // colonna generale

              ),
        ),
      ]));
    });
  }
}

Future<List?> computeDayData(
    String dataType, int difference, String userID) async {
  FitbitActivityTimeseriesDataManager fitbitActivityTimeseriesDataManager =
      FitbitActivityTimeseriesDataManager(
    clientID: '238C5P',
    clientSecret: '8b6a58492553191918d2cce62a2052c6',
    type: dataType,
  );

  final Data = await fitbitActivityTimeseriesDataManager
      .fetch(FitbitActivityTimeseriesAPIURL.dayWithResource(
    date: DateTime.now().subtract(Duration(days: difference)),
    userID: userID,
    resource: fitbitActivityTimeseriesDataManager.type,
  )) as List<FitbitActivityTimeseriesData>;
  return Data;
}

Future<List?> computeSleepData(int difference, String userID) async {
  FitbitSleepDataManager fitbitSleepDataManager = FitbitSleepDataManager(
    clientID: '238BZL',
    clientSecret: '34b956d540522d8e59ba18f63be21a91',
  );
  FitbitSleepAPIURL fitbitSleepAPIURL = FitbitSleepAPIURL.withUserIDAndDay(
    date: DateTime.now().subtract(Duration(days: difference)),
    userID: userID,
  );
  final fitbitSleepData = await fitbitSleepDataManager.fetch(fitbitSleepAPIURL)
      as List<FitbitSleepData>;

  return fitbitSleepData;
}
