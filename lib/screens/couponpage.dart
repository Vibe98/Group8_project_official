import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tomagolds/repository/databaserepository.dart';
import 'package:tomagolds/screens/visualizeCouponPage.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
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
                  child: const Text('Yes'),
                  onPressed: () {
                    Provider.of<DataBaseRepository>(context, listen: false)
                        .updateUsed(true, day, month);
                    Navigator.pushNamed(context, VisualizeCouponScreen.route, arguments: {
                      'day': day, 'month': month
                    });
                  }),
              CupertinoDialogAction(
                  isDefaultAction: true,
                  child: const Text('No'),
                  textStyle: const TextStyle(color: Colors.red),
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
          color: Color.fromARGB(255, 206, 245, 201),
        image: DecorationImage(
            image: AssetImage("assets/images/trophy_background.png"),
            opacity: 150,
            scale: 1,
            alignment: Alignment(1,0.3)
            
          ),
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
                                  tileColor: const Color.fromARGB(211, 237, 179, 3),
                                 
                                  leading: const Icon(MdiIcons.trophyOutline, color: Colors.brown),
                                  
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
                                    child: const Text('Use'),
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return const Text('No available Coupons');
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
                                  tileColor: const Color.fromARGB(255, 202, 194, 194),
                                  leading: const Icon(MdiIcons.trophyOutline),
                                  title: Text(
                                      '${usedlist[index].day}/${usedlist[index].month}/2022  -  ${computeEndOfWeek(usedlist[index].day, usedlist[index].month).day}/${computeEndOfWeek(usedlist[index].day, usedlist[index].month).month}/2022'),
                                  
                                ),
                              );
                            },
                          );
                        } else {
                          return const Text('No available Coupons');
                        }
                      },
                    ),
                  ),
                ),
              ]),
            )),
      ),
    );
  } 

} 
