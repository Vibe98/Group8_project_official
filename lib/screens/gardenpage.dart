import 'package:flutter/material.dart';
import 'package:login_flow/widgets/viusalizeDayTomato.dart';
import 'package:provider/provider.dart';

import '../classes/verify_cred.dart';

import '../database/entities/mydata.dart';
import '../repository/databaserepository.dart';

class GardenPage extends StatelessWidget {
  const GardenPage({Key? key, required this.username}) : super(key: key);

  final String username;
  static const route = '/garden';
  static const routename = 'GardenPage';

  @override
  Widget build(BuildContext context) {
    print('${GardenPage.routename} built');
    var daydate;
    return Scaffold(
        body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/prato2.jpg"),
                  fit: BoxFit.cover),
            ),
            child: Consumer<VerifyCredentials>(
                builder: ((context, value, child) => Consumer<
                        DataBaseRepository>(
                    builder: (context, db, child) => FutureBuilder(
                        initialData: null,
                        future: db.findWeekData(
                            getFirstDay(DateTime.now().day) as int,
                            DateTime.now().month),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final data = snapshot.data as List<MyData?>;
                            print(
                                '${changeWeek('decrease', 2, 3)}');
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('${DateTime.now().weekday + 7}'),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: Icon(Icons.arrow_back_rounded,
                                            size: 30, color: Colors.white)),
                                    Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      color: Colors.white.withOpacity(0.3),
                                      child: Container(
                                        height: 50,
                                        width: 200,
                                        child: Center(
                                          child: Text('Your Garden',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 30)),
                                        ),
                                      ),
                                    ),
                                    Text('             '),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        color: Colors.white.withOpacity(0.3),
                                        child: IconButton(
                                            onPressed: () {},
                                            icon: Icon(Icons.arrow_back_ios,
                                                color: Colors.white))),
                                    Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        color: Colors.white.withOpacity(0.3),
                                        child: Container(
                                            width: 200,
                                            height: 50,
                                            child: Center(
                                                child: Text(
                                                    '${data[0]!.day}/${data[0]!.month}/22 - ${data[6]!.day}/${data[6]!.month}/22',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18,
                                                        fontWeight: FontWeight
                                                            .w500))))),
                                    Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        color: Colors.white.withOpacity(0.3),
                                        child: IconButton(
                                            onPressed: () {},
                                            icon: Icon(Icons.arrow_forward_ios,
                                                color: Colors.white)))
                                  ],
                                ),
                                SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    VisualizeDayTomato(dayId: 0, data: data),
                                    VisualizeDayTomato(dayId: 1, data: data),
                                    VisualizeDayTomato(dayId: 2, data: data),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    VisualizeDayTomato(dayId: 3, data: data),
                                    VisualizeDayTomato(dayId: 4, data: data),
                                    VisualizeDayTomato(dayId: 5, data: data),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    VisualizeDayTomato(dayId: 6, data: data),
                                  ],
                                ),
                              ],
                            );
                          } else {
                            return CircularProgressIndicator();
                          }
                        }))))));
  } //build

} //Page

num getFirstDay(int day) {
  // given the day of today, it resitituate the number of Monday
  num today = DateTime.now().weekday;
  num firstDay = DateTime.now().day - today + 1;
  return firstDay;
}

List<int> changeWeek(inc_dec, day, month) {
  // different if we want to increase or decrease the week
  List<int> weekList = [];
  int end = 0;
  int oldmonth = month - 1;
  int newday=0;
  int newmonth=0;
  if (inc_dec == 'increase') {
    // increase week
    if (month == 1 ||
        month == 3 ||
        month == 5 ||
        month == 7 ||
        month == 8 ||
        month == 10 ||
        month == 12) {
      // mese ha 31 giorni
      end = 31;
    } else if (month == 4 || month == 6 || month == 9 || month == 11) {
      // mese ha 30 giorni
      end = 30;
    } else {
      end = 28;
    }
    if (day + 7 > end) {
      // sforo la fine del mese
      newmonth = month + 1;
      newday = 7 - (end - day) as int;
    } else {
      newday = day + 7;
      newmonth = month;
    }
      if (newday > DateTime.now().day) {
        // don't increase
        weekList.add(DateTime.now().day);
        weekList.add(DateTime.now().month);
      } else {
        weekList.add(newday);
        weekList.add(newmonth);
      }

  } else {
    // decrease week
    if (oldmonth == 1 ||
        oldmonth == 3 ||
        oldmonth == 5 ||
        oldmonth == 7 ||
        oldmonth == 8 ||
        oldmonth == 10 ||
        oldmonth == 12) {
      // mese ha 31 giorni
      end = 31;
    } else if (oldmonth == 4 ||
        oldmonth == 5 ||
        oldmonth == 9 ||
        oldmonth == 11) {
      // mese ha 30 giorni
      end = 30;
    } else {
      end = 28;
    }
    if (day - 7 < 0) {
      // sforo la fine del mese
      newmonth = month - 1;
      newday = end - (7 - day) as int;
    } else {
      newday = day - 7;
      newmonth= month;
    }
    if (newmonth < 3) {
        // iniziato a prendere i dati il 3 marzo
        // don't decrease
        weekList.add(1);
        weekList.add(3);
      } else {
        weekList.add(newday);
        weekList.add(newmonth);
      }
  }
  return weekList;
}
