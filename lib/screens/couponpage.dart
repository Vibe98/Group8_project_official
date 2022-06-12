import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_flow/repository/databaserepository.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';

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
                    _showCodeDialogue(context);

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

  Future<void>? _showCodeDialogue(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0))),
              title: const Text('Your Code', textAlign: TextAlign.center,),
              content: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 300,
                      width: 300,
                      child: Image.asset('assets/images/pomodoro_felice.png',
                          fit: BoxFit.cover, scale: 10),
                    ),
                    
                   Text(randomAlphaNumeric(8), style: TextStyle(
                            //color: Colors.green,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.italic,
                            fontSize: 30)),
                            
                   ElevatedButton(onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();

                   },
                   style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.green),
                                  ),
                   child: Icon(Icons.done))
                  ]));
        });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Color.fromARGB(255, 183, 208, 201),
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
                              elevation: 5,
                              child: ListTile(
                                horizontalTitleGap: 40,
                                tileColor: Color.fromARGB(255, 165, 221, 167),
                                //style: ,
                                leading: Icon(MdiIcons.trophyOutline),
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
                              elevation: 5,
                              child: ListTile(
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
    );
  } //build

} //Page
