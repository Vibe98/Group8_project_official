import 'package:flutter/material.dart';
import 'package:tomagolds/classes/verify_cred.dart';
import 'package:tomagolds/database/entities/couponentity.dart';
import 'package:tomagolds/widgets/viusalizeDayTomato.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../classes/weekdata.dart';
import '../database/entities/mydata.dart';
import '../repository/databaserepository.dart';


class GardenPage extends StatelessWidget {
  GardenPage({Key? key, required this.username}) : super(key: key);

  final String username;
  static const route = '/garden';
  static const routename = 'GardenPage';
  final DateRangePickerController _controller = DateRangePickerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Consumer<VerifyCredentials>(
                  builder: (context, credentials, child) {
                return  Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/prato2.jpg"),
                  fit: BoxFit.cover),
            ),
            child: credentials.isAuthenticated(username) &&
                              credentials.iscompleted(username)
                          ? ListView(children: [
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back_rounded,
                            size: 30, color: Colors.white)),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      color: Colors.white.withOpacity(0.3),
                      child: Container(
                        height: 50,
                        width: 200,
                        child: const Center(
                          child: Text('Your Garden',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 30)),
                        ),
                      ),
                    ),
                    const Text('             '),
                  ],
                ),
                const SizedBox(height: 20),
                Consumer<WeekData>(
                    builder: ((context, value, child) => FutureBuilder(
                        future: Provider.of<DataBaseRepository>(context,
                                listen: false)
                            .findWeekData(
                                value.datestart.day,
                                value.datestart
                                    .month), 
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.none:
                            case ConnectionState.waiting:
                              return const CircularProgressIndicator();
                            case ConnectionState.active:
                            case ConnectionState.done:
                              if (snapshot.hasData) {
                                final weeklist = snapshot.data as List<MyData>;
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                            height: 170,
                                            width: 300,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color:
                                                    Colors.black.withOpacity(0.3)),
                                            child: Consumer<WeekData>(builder:
                                                (context, weekdate, child) {
                                              return Column(children: [
                                                    Container(
                                                      height: 170,
                                                      width: 250,
                                                      child: SfDateRangePicker(
                                                        controller: _controller,
                                                        rangeSelectionColor:
                                                            Colors.amber,
                                                        view: DateRangePickerView
                                                            .month,
                                                        selectionMode:
                                                            DateRangePickerSelectionMode
                                                                .range,
                                                        monthViewSettings: const DateRangePickerMonthViewSettings(
                                                            showTrailingAndLeadingDates:
                                                                true,
                                                            viewHeaderStyle:
                                                                DateRangePickerViewHeaderStyle(
                                                                    textStyle: TextStyle(
                                                                        color: Colors
                                                                            .white)),
                                                            enableSwipeSelection:
                                                                true),
                                                        headerStyle:
                                                            const DateRangePickerHeaderStyle(
                                                                textStyle: TextStyle(
                                                                    color: Colors
                                                                        .white)),
                                                        yearCellStyle:
                                                            const DateRangePickerYearCellStyle(
                                                          disabledDatesTextStyle:
                                                              TextStyle(
                                                                  color:
                                                                      Colors.grey),
                                                          textStyle: TextStyle(
                                                              color: Colors.white),
                                                          todayTextStyle: TextStyle(
                                                              color: Colors.white),
                                                        ),
                                                        selectionColor:
                                                            Colors.transparent,
                                                        selectionTextStyle:
                                                            const TextStyle(
                                                                color:
                                                                    Colors.amber),
                                                        monthCellStyle:
                                                            const DateRangePickerMonthCellStyle(
                                                          trailingDatesTextStyle:
                                                              TextStyle(
                                                                  color:
                                                                      Colors.grey),
                                                          leadingDatesTextStyle:
                                                              TextStyle(
                                                                  color:
                                                                      Colors.grey),
                                                          disabledDatesTextStyle:
                                                              TextStyle(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          95,
                                                                          91,
                                                                          91)),
                                                          textStyle: TextStyle(
                                                              color: Colors.white),
                                                          todayTextStyle: TextStyle(
                                                              color: Colors.orange),
                                                        ),
                                                        onSelectionChanged:
                                                            (DateRangePickerSelectionChangedArgs
                                                                args) {
                                                          int firstDayOfWeek =
                                                              DateTime.sunday % 7;
                                                          int endDayOfWeek =
                                                              (firstDayOfWeek - 1) %
                                                                  7;
                                                          endDayOfWeek =
                                                              endDayOfWeek < 0
                                                                  ? 7 + endDayOfWeek
                                                                  : endDayOfWeek;
                                                          PickerDateRange ranges =
                                                              args.value;
                                                          DateTime date1 =
                                                              ranges.startDate!;
                                                          DateTime date2 = (ranges
                                                                  .endDate ??
                                                              ranges.startDate)!;
                                                          if (date1
                                                              .isAfter(date2)) {
                                                            var date = date1;
                                                            date1 = date2;
                                                            date2 = date;
                                                          }
                                                          int day1 =
                                                              date1.weekday % 7;
                                                          int day2 =
                                                              date2.weekday % 7;

                                                          DateTime dat1 = date1.add(
                                                              Duration(
                                                                  days:
                                                                      (firstDayOfWeek -
                                                                          day1)));
                                                          DateTime dat2 = date2.add(
                                                              Duration(
                                                                  days:
                                                                      (endDayOfWeek -
                                                                          day2)));

                                                          _controller
                                                                  .selectedRange =
                                                              PickerDateRange(
                                                                  dat1, dat2);
                                                          weekdate.changeWeek(
                                                              dat1, dat2);
                                                        },
                                                      ),
                                                    ),
                                              ]);
                                            })),
                                            FutureBuilder(
                                        future: Provider.of<DataBaseRepository>(
                                                context,
                                                listen: false)
                                            .findCoupons(value.datestart.day,
                                                value.datestart.month),
                                        builder: (context, snapshot) {
                                          switch (snapshot.connectionState) {
                                            case ConnectionState.none:
                                            case ConnectionState.waiting:
                                              return const CircularProgressIndicator();
                                            case ConnectionState.active:
                                            case ConnectionState.done:
                                              if (snapshot.hasData) {
                                                final coupon = snapshot.data
                                                    as CouponEntity;
                                                if (coupon.present == true) {
                                                  Future.delayed(Duration.zero,
                                                      () async {
                                                    await _showChoiceDialog(
                                                        context,
                                                        value.datestart.day,
                                                        value.datestart.month);
                                                  });
                                                  return const Icon(MdiIcons.ticket,
                                                      color: Color.fromARGB(255, 255, 209, 59),
                                                      size: 45);
                                                } else {
                                                  return const Text('');
                                                }
                                              } else {
                                                return const CircularProgressIndicator();
                                              }
                                          }
                                        }),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        VisualizeDayTomato(
                                            dayId: 0, data: weeklist),
                                        VisualizeDayTomato(
                                            dayId: 1, data: weeklist),
                                        VisualizeDayTomato(
                                            dayId: 2, data: weeklist),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        VisualizeDayTomato(
                                            dayId: 3, data: weeklist),
                                        VisualizeDayTomato(
                                            dayId: 4, data: weeklist),
                                        VisualizeDayTomato(
                                            dayId: 5, data: weeklist),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        VisualizeDayTomato(
                                            dayId: 6, data: weeklist),
                                      
                                      ],
                                    ),
                                  ],
                                );
                              } else {
                                return const CircularProgressIndicator();
                              }
                          }
                        }))),
              ]),
            ]): Column(
              
              children: [
                SizedBox(height:70),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back_rounded,
                              size: 30, color: Colors.white)),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        color: Colors.white.withOpacity(0.3),
                        child: Container(
                          height: 50,
                          width: 200,
                          child: const Center(
                            child: Text('Your Garden',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 30)),
                          ),
                        ),
                      ),
                      const Text('             '),
                    ],
                  ),
                  SizedBox(height: 250),
                  Text('You\'re not authorized. Please go to the profile page and authorize.', textAlign: TextAlign.center,)],
            ),);}));
  }
}

Future<void> _showChoiceDialog(BuildContext context, day, month) {
  return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.fromLTRB(50, 100, 50, 100),
          elevation: 20,
          backgroundColor: Colors.white,
          content: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                  'You have won a coupon! Check the Coupon Page to use it',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
              SizedBox(
                width: 300,
                height: 350,
                child: Image.asset(
                    'assets/images/trophy.jpg',
                    fit: BoxFit.cover,
                    ),
              )
            ],
          ),
        );
      });
}
