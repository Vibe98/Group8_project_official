import 'package:fitbitter/fitbitter.dart';
import 'package:flutter/material.dart';
import 'package:login_flow/database/entities/mydata.dart';
import 'package:login_flow/repository/databaserepository.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:login_flow/widgets/tomatochart.dart';
import '../classes/verify_cred.dart';
import '../classes/DayDate.dart';

class DayWidget extends StatelessWidget {
  final String username;

  DayWidget({required this.username});

  final DateRangePickerController _controller = DateRangePickerController();

  @override
  Widget build(BuildContext context) {
    return Consumer<DayData>(builder: (context, daydate, child) {
      return Center(
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                  height: 170,
                  width: 270,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.black,
                  ),
                  child: SfDateRangePicker(
                    selectionRadius: -1,
                    todayHighlightColor: Colors.orange,
                    controller: _controller,
                    view: DateRangePickerView.month,
                    minDate: DateTime(2022, 03, 01),
                    maxDate: DateTime.now(),
                    onSelectionChanged:
                        (DateRangePickerSelectionChangedArgs args) {
                      final dynamic value = args.value;

                      daydate.changeDay(value);
                      daydate.computeDifference();
                    },
                    monthViewSettings: DateRangePickerMonthViewSettings(
                        showTrailingAndLeadingDates: true,
                        viewHeaderStyle: DateRangePickerViewHeaderStyle(
                            textStyle: TextStyle(color: Colors.white)),
                        enableSwipeSelection: true),
                    headerStyle: DateRangePickerHeaderStyle(
                        textStyle: TextStyle(color: Colors.white)),
                    yearCellStyle: DateRangePickerYearCellStyle(
                      disabledDatesTextStyle: TextStyle(color: Colors.grey),
                      textStyle: TextStyle(color: Colors.white),
                      todayTextStyle: TextStyle(color: Colors.white),
                    ),
                    selectionColor: Colors.transparent,
                    selectionTextStyle: TextStyle(color: Colors.amber),
                    monthCellStyle: DateRangePickerMonthCellStyle(
                      trailingDatesTextStyle: TextStyle(color: Colors.grey),
                      leadingDatesTextStyle: TextStyle(color: Colors.grey),
                      disabledDatesTextStyle:
                          TextStyle(color: Color.fromARGB(255, 95, 91, 91)),
                      textStyle: TextStyle(color: Colors.white),
                      todayTextStyle: TextStyle(color: Colors.orange),
                    ),
                  )),
              Consumer<VerifyCredentials>(
                  builder: ((context, value, child) =>
                      Consumer<DataBaseRepository>(
                          builder: (context, db, child) => FutureBuilder(
                                initialData: null,
                                future: db.findDatas(
                                    daydate.date.day, daydate.date.month),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    final data = snapshot.data as MyData;
                                    return data.tomatos!
                                        ? SizedBox(
                                            width: 100,
                                            height: 120,
                                            child: Image.asset(
                                                'assets/images/pomodoro_felice.png',
                                                fit: BoxFit.cover,
                                                scale: 10),
                                          )
                                        : SizedBox(
                                            width: 100,
                                            height: 120,
                                            child: Image.asset(
                                                'assets/images/pomodoro_triste.png',
                                                fit: BoxFit.cover,
                                                scale: 10),
                                          );
                                  } else {
                                    return CircularProgressIndicator();
                                  }
                                },
                              ))))
            ],
          ),
          // ROW

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
                                  Card(
                                    elevation: 10,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    margin: const EdgeInsets.all(15.0),
                                    child: Container(
                                      height: 100,
                                      width: 380,
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                      height: 40,
                                                      width: 40,
                                                      decoration: BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          border: Border.all(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    153,
                                                                    211,
                                                                    155),
                                                            width: 2,
                                                          )),
                                                      child: Icon(MdiIcons.run,
                                                          size: 30,
                                                          color: Colors.green)),
                                                  SizedBox(
                                                    width: 30,
                                                  ),
                                                  RotatedBox(
                                                    quarterTurns: 1,
                                                    child: Container(
                                                      width: 50,
                                                      height: 200,
                                                      child: AspectRatio(
                                                        aspectRatio: 0.6,
                                                        child: TomatoChart(
                                                          data: data.steps!,
                                                          name: 'steps',
                                                          objective: 7000,
                                                          number: 1,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Icon(MdiIcons.flagCheckered)
                                                ]),
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Column(children: [
                                                    Text('STEPS:',
                                                        style: TextStyle(
                                                            //color: Colors.blue,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontStyle: FontStyle
                                                                .normal,
                                                            fontSize: 15)),
                                                    Text('DISTANCE:',
                                                        style: TextStyle(
                                                            //color: Colors.blue,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontStyle: FontStyle
                                                                .normal,
                                                            fontSize: 15)),
                                                  ]),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                          data.steps!
                                                              .round()
                                                              .toString(),
                                                          style: TextStyle(
                                                              //color: Colors.blue,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              fontSize: 15)),
                                                      Text(
                                                          '${data.distance!.toStringAsFixed(1)} km',
                                                          style: TextStyle(
                                                              //color: Colors.blue,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              fontSize: 15)),
                                                    ],
                                                  ),
                                                ])
                                          ]),
                                    ),
                                  ),

                                  Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      margin: const EdgeInsets.all(15.0),
                                      child: Container(
                                        height: 100,
                                        width: 390,
                                        child: Column(children: [
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                    height: 40,
                                                    width: 40,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                          color: Color.fromARGB(
                                                              255,
                                                              216,
                                                              159,
                                                              105),
                                                          width: 2,
                                                        )),
                                                    child: Icon(MdiIcons.fire,
                                                        size: 30,
                                                        color: Color.fromARGB(
                                                            255,
                                                            223,
                                                            124,
                                                            25))),
                                                SizedBox(width: 30),
                                                RotatedBox(
                                                  quarterTurns: 1,
                                                  child: Container(
                                                    height: 200,
                                                    width: 50,
                                                    child: AspectRatio(
                                                        aspectRatio: 0.8,
                                                        child: TomatoChart(
                                                          data: data.calories!,
                                                          name: 'calories',
                                                          objective: 2800,
                                                          number: 2,
                                                        )),
                                                  ),
                                                ),
                                                Icon(MdiIcons.flagCheckered),
                                              ]),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text('CALORIES:',
                                                    style: TextStyle(
                                                        //color: Colors.blue,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontSize: 20)),
                                                Text(
                                                    '${data.calories!.toStringAsFixed(0)} kcal',
                                                    style: TextStyle(
                                                        //color: Colors.blue,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontSize: 20))
                                              ])
                                        ]),
                                      )),
                                  Card(
                                      margin: const EdgeInsets.all(15.0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Container(
                                        height: 100,
                                        width: 380,
                                        child: Column(children: [
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                    height: 40,
                                                    width: 40,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                          color: Color.fromARGB(
                                                              255,
                                                              216,
                                                              130,
                                                              178),
                                                          width: 2,
                                                        )),
                                                    child: Icon(
                                                        MdiIcons.armFlex,
                                                        size: 30,
                                                        color: Color.fromARGB(
                                                            255,
                                                            113,
                                                            13,
                                                            100))),
                                                SizedBox(width: 30),
                                                RotatedBox(
                                                  quarterTurns: 1,
                                                  child: Container(
                                                    height: 200,
                                                    width: 50,
                                                    child: AspectRatio(
                                                      aspectRatio: 0.6,
                                                      child: TomatoChart(
                                                        data: data.minutesfa! +
                                                            data.minutesva!,
                                                        name: 'minutes',
                                                        objective: 40,
                                                        number: 3,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Icon(MdiIcons.flagCheckered)
                                              ]),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Column(
                                                  children: [
                                                    Text('MINUTES VERY ACTIVE:',
                                                        style: TextStyle(
                                                            //color: Colors.blue,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontStyle: FontStyle
                                                                .normal,
                                                            fontSize: 15)),
                                                    Text(
                                                        'MINUTES FAIRLY ACTIVE:',
                                                        style: TextStyle(
                                                            //color: Colors.blue,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontStyle: FontStyle
                                                                .normal,
                                                            fontSize: 15)),
                                                  ],
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                        data.minutesfa
                                                            .toString(),
                                                        style: TextStyle(
                                                            //color: Colors.blue,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontStyle: FontStyle
                                                                .normal,
                                                            fontSize: 15)),
                                                    Text(
                                                        data.minutesva
                                                            .toString(),
                                                        style: TextStyle(
                                                            //color: Colors.blue,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontStyle: FontStyle
                                                                .normal,
                                                            fontSize: 15)),
                                                  ],
                                                ),
                                              ])
                                        ]),
                                      )),

                                  // row
                                  Card(
                                      margin: const EdgeInsets.all(15.0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Container(
                                        height: 100,
                                        width: 380,
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Container(
                                                  alignment: Alignment.center,
                                                  height: 40,
                                                  width: 40,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        color: Color.fromARGB(
                                                            255, 127, 157, 209),
                                                        width: 2,
                                                      )),
                                                  child: Center(
                                                    child: IconButton(
                                                        alignment:
                                                            Alignment.center,
                                                        padding:
                                                            EdgeInsets.all(1),
                                                        onPressed: () {
                                                          daydate.changeSleep();
                                                        },
                                                        icon: const Icon(
                                                            MdiIcons
                                                                .moonWaxingCrescent,
                                                            size: 30,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    6,
                                                                    12,
                                                                    70))),
                                                  )),
                                              daydate.sleep == false
                                                  ? Text('Click to visualize',
                                                      style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255,
                                                              61,
                                                              119,
                                                              163),
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          fontSize: 20))
                                                  : Container(
                                                      width: 250,
                                                      child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            Text('SLEEP:',
                                                                style: TextStyle(
                                                                    //color: Colors.blue,
                                                                    fontWeight: FontWeight.w500,
                                                                    fontStyle: FontStyle.normal,
                                                                    fontSize: 20)),
                                                            FutureBuilder(
                                                                future: _computeSleepData(
                                                                    daydate
                                                                        .difference,
                                                                    value.Restituteuser(
                                                                            username)[
                                                                        'userID']),
                                                                builder: (context,
                                                                    snapshot) {
                                                                  switch (snapshot
                                                                      .connectionState) {
                                                                    case ConnectionState
                                                                        .none:
                                                                    case ConnectionState
                                                                        .waiting:
                                                                      print(
                                                                          'waiting');
                                                                      return CircularProgressIndicator();
                                                                    case ConnectionState
                                                                        .done:
                                                                    case ConnectionState
                                                                        .active:
                                                                      if (snapshot
                                                                          .hasData) {
                                                                        final sleepdata =
                                                                            snapshot.data
                                                                                as List;
                                                                        DateTime?
                                                                            dt1 =
                                                                            sleepdata[0].entryDateTime;
                                                                        DateTime?
                                                                            dt2 =
                                                                            sleepdata.last.entryDateTime;

                                                                        Duration?
                                                                            diff =
                                                                            dt2!.difference(dt1!);

                                                                        int result =
                                                                            diff.inMinutes; // 2 mins

                                                                        int hour =
                                                                            result ~/
                                                                                60;
                                                                        int minutes =
                                                                            result %
                                                                                60;
                                                                        print(daydate
                                                                            .day);
                                                                        print(daydate
                                                                            .month);
                                                                        if (hour >
                                                                            0) {
                                                                          return Text(
                                                                              '$hour : $minutes',
                                                                              style: TextStyle(
                                                                                  //color: Colors.blue,
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontStyle: FontStyle.normal,
                                                                                  fontSize: 20));
                                                                        } else {
                                                                          return Text(
                                                                              '- - -',
                                                                              style: TextStyle(
                                                                                  //color: Colors.blue,
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontStyle: FontStyle.normal,
                                                                                  fontSize: 20));
                                                                        }
                                                                      } else {
                                                                        return Text(
                                                                            '- - -',
                                                                            style: TextStyle(
                                                                                //color: Colors.blue,
                                                                                fontWeight: FontWeight.w500,
                                                                                fontStyle: FontStyle.normal,
                                                                                fontSize: 20));
                                                                      }
                                                                  }
                                                                })
                                                          ]),
                                                    )
                                            ]),
                                      )), // row

                                  // container
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
        ]),
      );
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
  return (fitbitSleepData);
}
