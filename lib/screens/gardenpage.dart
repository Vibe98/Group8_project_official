import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:login_flow/widgets/viusalizeDayTomato.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../classes/verify_cred.dart';
import '../classes/weekchart.dart';
import '../classes/weekdata.dart';
import '../database/entities/mydata.dart';
import '../repository/databaserepository.dart';
import '../widgets/weekwidget.dart';

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
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                              onPressed: () {
                                              Navigator.pop(context);
                                            }, icon: Icon(Icons.arrow_back_rounded,
                                            size: 30, color: Colors.white)),
                                      SizedBox(width: 70),
                                      Text('Your Garden',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 30)),
                                      SizedBox(width:100)
                                    ],
                                  ),
                                
                                SizedBox(height: 30),
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
