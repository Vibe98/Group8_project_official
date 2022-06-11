import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../classes/weekchart.dart';
import '../classes/weekdata.dart';
import '../widgets/weekwidget.dart';

class GardenPage extends StatelessWidget {
  const GardenPage({Key? key, required this.username}) : super(key: key);

  final String username;
  static const route = '/garden';
  static const routename = 'GardenPage';

  @override
  Widget build(BuildContext context) {
    print('${GardenPage.routename} built');
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text(GardenPage.routename),
        ),
        body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/prato2.jpg"),
                  fit: BoxFit.cover),
            ),
            child: Center(
                child: Consumer<WeekData>(
                    builder: ((context, value, child) => FutureBuilder(
                        future: fetchweekdata(
                            context,
                            value
                                .datestart), //Provider.of<DataBaseRepository>(context, listen: false).findWeekData(value.datestart.day, value.datestart.month),
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.none:
                            case ConnectionState.waiting:
                              return CircularProgressIndicator();
                            case ConnectionState.active:
                            case ConnectionState.done:
                              if (snapshot.hasData) {
                                final weeklist =
                                    snapshot.data as List<List<WeekChart>>;
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text('Day 1'),
                                        Text('Day 2'),
                                        Text('Day 3'),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text('Day 4'),
                                        Text('Day 5'),
                                        Text('Day 6'),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text('Day 7'),
                                      ],
                                    ),
                                  ],
                                );
                              } else {
                                return CircularProgressIndicator();
                              }
                          }
                        }))))));
  } //build

} //Page