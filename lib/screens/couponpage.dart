import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_flow/repository/databaserepository.dart';
import 'package:login_flow/screens/visualizeCouponPage.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';
import 'package:flutter_ticket_widget/flutter_ticket_widget.dart';

import '../database/entities/couponentity.dart';
import '../utils/utils.dart';

class CouponPage extends StatelessWidget {
  CouponPage({Key? key}) : super(key: key);

  static const route = '/coupon';

  Future<void> _showChoiceDialog(BuildContext context, day, month) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            content: const Text('Are you sure you want to use this coupon?',
                style: TextStyle(fontSize: 20)),
            actions: <Widget>[
              CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text('Yes'),
                  onPressed: () {
                    Provider.of<DataBaseRepository>(context, listen: false)
                        .updateUsed(true, day, month);
                    Navigator.pushNamed(context, VisualizeCouponScreen.route, arguments: {
                      'day': day, 'month': month
                    });

                    //Navigator.of(context).pop();
                  }),
              CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text('No'),
                  textStyle: TextStyle(color: Colors.red),
                  onPressed: () {
                    Navigator.of(context).pop();
                  })
            ],
          );
        });
  }

  
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.green, Color.fromARGB(255, 204, 121, 19)])
         ),
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.green,
              title: const Text('My Coupons'),
              bottom: const TabBar(
                tabs: <Widget>[
                  Tab(
                    text: 'Available',
                  ),
                  Tab(
                    text: 'Used',
                  ),
                ],
              ),
            ),
            body: Center(
              child: TabBarView(children: <Widget>[
                Center(
                  child: Consumer<DataBaseRepository>(
                    builder: (context, couponList, child) => FutureBuilder(
                      future: couponList.findPresendAndUsedCoupons(true, false),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final list = snapshot.data as List<CouponEntity>;
                          
                          return ListView.builder(
                            itemCount: list.length,
                            itemBuilder: (context, index) {
                              return Card(
                                shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                elevation: 5,
                                child: ListTile(
                                  shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                  horizontalTitleGap: 40,
                                  tileColor: Color.fromARGB(211, 237, 179, 3),
                                  //style: ,
                                  leading: Icon(MdiIcons.trophyOutline, color: Colors.brown),
                                  //leading: Image.asset(
                                  // 'assets/images/pomodoro_felice.png',
                                  //fit: BoxFit.cover, scale: 10),
                                  title: Text(
                                      '${list[index].day}/${list[index].month}/2022  -  ${computeEndOfWeek(list[index].day, list[index].month).day}/${computeEndOfWeek(list[index].day, list[index].month).month}/2022'),
                                  trailing: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.green),
                                    ),
                                    onPressed: () {
                                      _showChoiceDialog(context, list[index].day,
                                          list[index].month);
                                    },
                                    child: Text('Use'),
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return Text('No available Coupons');
                        }
                      },
                    ),
                  ),
                ),
                Center(
                  child: Consumer<DataBaseRepository>(
                    builder: (context, couponList, child) => FutureBuilder(
                      future: couponList.findPresendAndUsedCoupons(true, true),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final usedlist = snapshot.data as List<CouponEntity>;
                          
                          return ListView.builder(
                            itemCount: usedlist.length,
                            itemBuilder: (context, index) {
                              return Card(
                                shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                elevation: 5,
                                child: ListTile(
                                  shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                  tileColor: Color.fromARGB(255, 202, 194, 194),
                                  leading: Icon(MdiIcons.trophyOutline),
                                  title: Text(
                                      '${usedlist[index].day}/${usedlist[index].month}/2022  -  ${computeEndOfWeek(usedlist[index].day, usedlist[index].month).day}/${computeEndOfWeek(usedlist[index].day, usedlist[index].month).month}/2022'),
                                  trailing: ElevatedButton(
                                    onPressed: () {
                                      Provider.of<DataBaseRepository>(context,
                                              listen: false)
                                          .updateUsed(false, usedlist[index].day,
                                              usedlist[index].month);
                                    },
                                    child: Text('prova'),
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return Text('No available Coupons');
                        }
                      },
                    ),
                  ),
                ),
              ]),
            )),
      ),
    );
  } //build

} //Page
