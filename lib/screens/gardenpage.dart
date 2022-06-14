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
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      IconButton(
                                              onPressed: () {
                                              Navigator.pop(context);
                                            }, icon: Icon(Icons.arrow_back_rounded,
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
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        color: Colors.white.withOpacity(0.3),
                                        child: IconButton(
                                          onPressed: () {

                                          },
                                          icon: Icon(Icons.arrow_back_ios, color: Colors.white)
                                        )),
                                        Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        color: Colors.white.withOpacity(0.3),
                                        child: Container(
                                          width: 200,
                                          height: 50,
                                          child: Center(child: 
                                          Text('${data[0]!.day}/${data[0]!.month}/22 - ${data[6]!.day}/${data[6]!.month}/22',
                                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500))
                                          )
                                        )
                                        ),
                                        Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        color: Colors.white.withOpacity(0.3),
                                        child: IconButton(
                                          onPressed: () {

                                          },
                                          icon: Icon(Icons.arrow_forward_ios, color: Colors.white)
                                        ))
                                ],),
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
