import 'package:fitbitter/fitbitter.dart';
import 'package:flutter/material.dart';
import 'package:login_flow/database/entities/mydata.dart';
import 'package:login_flow/repository/databaserepository.dart';
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
                      daydate.computeDifference();
                    },
                  )),
        ]), // ROW

        Consumer<VerifyCredentials>(
          builder: ((context, value, child) => Consumer<DataBaseRepository>(
                builder: ((context, db, child) => FutureBuilder(
                          initialData: null,
                          future: db.findDatas(
                              daydate.date.day, daydate.date.month),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final data = snapshot.data as MyData;
                              print(data);
                              return Column(children: [
                                Container(
                                  height: 60,
                                  width: 350,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 5),
                                  margin: const EdgeInsets.all(15.0),
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Colors.blueAccent),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Row(
                                    children: [
                                      Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Color.fromARGB(
                                                    255, 153, 211, 155),
                                                width: 2,
                                              )),
                                          child: Icon(MdiIcons.run,
                                              size: 30, color: Colors.green)),
                                      SizedBox(width: 60),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                      SizedBox(width: 75),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(data.steps!.round().toString(),
                                              style: TextStyle(
                                                  //color: Colors.blue,
                                                  fontWeight: FontWeight.w500,
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 15)),
                                          Text(
                                              '${data.distance!.toStringAsFixed(1)} km',
                                              style: TextStyle(
                                                  //color: Colors.blue,
                                                  fontWeight: FontWeight.w500,
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 15)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                Container(
                                  height: 60,
                                  width: 350,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 5),
                                  margin: const EdgeInsets.all(15.0),
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Colors.blueAccent),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Row(
                                    children: [
                                      Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Color.fromARGB(
                                                    255, 216, 159, 105),
                                                width: 2,
                                              )),
                                          child: Icon(MdiIcons.fire,
                                              size: 30,
                                              color: Color.fromARGB(
                                                  255, 223, 124, 25))),
                                      SizedBox(width: 35),
                                      Text('CALORIES:',
                                          style: TextStyle(
                                              //color: Colors.blue,
                                              fontWeight: FontWeight.w500,
                                              fontStyle: FontStyle.normal,
                                              fontSize: 20)),
                                      SizedBox(width: 40),
                                      Text('${data.calories!.toStringAsFixed(0)} kcal',
                                          style: TextStyle(
                                              //color: Colors.blue,
                                              fontWeight: FontWeight.w500,
                                              fontStyle: FontStyle.normal,
                                              fontSize: 20))
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 60,
                                  width: 350,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 5),
                                  margin: const EdgeInsets.all(15.0),
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Colors.blueAccent),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Row(
                                    children: [
                                      Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Color.fromARGB(
                                                    255, 127, 157, 209),
                                                width: 2,
                                              )),
                                          child: Icon(
                                              MdiIcons.moonWaxingCrescent,
                                              size: 30,
                                              color: Color.fromARGB(
                                                  255, 6, 12, 70))),
                                      SizedBox(width: 65),
                                      Text('SLEEP:',
                                          style: TextStyle(
                                              //color: Colors.blue,
                                              fontWeight: FontWeight.w500,
                                              fontStyle: FontStyle.normal,
                                              fontSize: 20)),
                                      SizedBox(width: 80),
                                      FutureBuilder(
                                          future: _computeSleepData(
                                              daydate.difference,
                                              value.Restituteuser(
                                                  username)['userID']),
                                          builder: (context, snapshot) {
                                            switch(snapshot.connectionState){
                                              case ConnectionState.none:
                                              case ConnectionState.waiting:
                                              print('waiting');
                                              return CircularProgressIndicator();
                                              case ConnectionState.done:
                                              case ConnectionState.active:

                                            
                                            if (snapshot.hasData) {
                                              final sleepdata =
                                                  snapshot.data as List;
                                              DateTime? dt1 = sleepdata[0]
                                                  .entryDateTime;
                                              DateTime? dt2 = sleepdata
                                                  .last.entryDateTime;

                                              Duration? diff =
                                                  dt2!.difference(dt1!);

                                              int result =
                                                  diff.inMinutes; // 2 mins

                                              int hour = result ~/ 60;
                                              int minutes = result % 60;
                                              print(daydate.day);
                                              print(daydate.month);
                                              if(hour>0){
                                              return Text('$hour : $minutes',
                                              style: TextStyle(
                                              //color: Colors.blue,
                                              fontWeight: FontWeight.w500,
                                              fontStyle: FontStyle.normal,
                                              fontSize: 20));
                                              } else{
                                                return Text('- - -',
                                              style: TextStyle(
                                              //color: Colors.blue,
                                              fontWeight: FontWeight.w500,
                                              fontStyle: FontStyle.normal,
                                              fontSize: 20));
                                              }
                                            } else {
                                              return Text('- - -',
                                              style: TextStyle(
                                              //color: Colors.blue,
                                              fontWeight: FontWeight.w500,
                                              fontStyle: FontStyle.normal,
                                              fontSize: 20));
                                            }}
                                          }) 
                                    ],
                                  ),
                                ),

                                Container(
                                  height: 60,
                                  width: 350,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 5),
                                  margin: const EdgeInsets.all(15.0),
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Colors.blueAccent),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Row(children: [
                                    Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Color.fromARGB(
                                                  255, 216, 130, 178),
                                              width: 2,
                                            )),
                                        child: Icon(MdiIcons.armFlex,
                                            size: 30,
                                            color: Color.fromARGB(
                                                255, 113, 13, 100))),
                                    SizedBox(width: 20),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                    SizedBox(width: 20),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(data.minutesfa.toString(),
                                            style: TextStyle(
                                                //color: Colors.blue,
                                                fontWeight: FontWeight.w500,
                                                fontStyle: FontStyle.normal,
                                                fontSize: 15)),
                                        Text(data.minutesva.toString(),
                                            style: TextStyle(
                                                //color: Colors.blue,
                                                fontWeight: FontWeight.w500,
                                                fontStyle: FontStyle.normal,
                                                fontSize: 15)),
                                      ],
                                    ),
                                  ]), // row
                                ), // container
                              ]);
                            } else {
                              return CircularProgressIndicator();
                            }
                          },
                        )
                    // colonna generale

                    ),
              )),
        )
      ]));
    });
  }
}

Future<List> _computeSleepData(int difference, String userID) async {
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
 return(fitbitSleepData);


}
