import 'package:charts_flutter/flutter.dart' as charts;
import 'package:fitbitter/fitbitter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:login_flow/database/entities/mydata.dart';
import 'package:login_flow/repository/databaserepository.dart';
import 'package:login_flow/screens/couponpage.dart';
import 'package:login_flow/screens/gardenpage.dart';
import 'package:login_flow/widgets/weekwidget.dart';
import 'package:login_flow/classes/credentialsFitbitter.dart';
import 'package:login_flow/screens/loginpage.dart';
import 'package:login_flow/screens/profilepage.dart';
import 'package:login_flow/widgets/monthWidget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:login_flow/classes/DayDate.dart';
import 'package:login_flow/widgets/DayWidget.dart';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import '../classes/changeMonth.dart';
import '../classes/monthChartGraph.dart';
import '../classes/myMonthData.dart';
import '../classes/verify_cred.dart';
import '../widgets/monthWidget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.username}) : super(key: key);

  static const route = '/home';
  final String username;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // This widget is the root of your application.
  TextEditingController monthController = TextEditingController();

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            content: const Text('Are you sure you want to exit?',
                style: TextStyle(fontSize: 20)),
            actions: <Widget>[
              CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text('Yes'),
                  onPressed: () async {

                    final sp = await SharedPreferences.getInstance();

                    //rimuovo le credenziali salvate
                    
                    sp.setBool('Log', false);
                    sp.remove('userid');
                    print(sp.getBool('Log'));
                    setState(() {});
                    Navigator.pushNamedAndRemoveUntil(context, LoginPage.route, ModalRoute.withName('/'));
                  }),
              CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text('Cancel'),
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
        length: 3,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.green, Colors.blue])),
          child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Colors.green,
                title: const Text('My Data'),
                actions: [
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, GardenPage.route,
                          arguments: {'username': widget.username});
                    },
                    icon: Icon(MdiIcons.shovel),
                  )
                ],
                bottom: const TabBar(
                  tabs: <Widget>[
                    Tab(
                      text: 'Day',
                    ),
                    Tab(
                      text: 'Week',
                    ),
                    Tab(
                      text: 'Month',
                    ),
                  ],
                ),
              ),
              drawer: Drawer(
                  child: ListView(
                children: [
                  Container(
                      child: const Text('Application\'s Options',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.greenAccent)),
                      padding: EdgeInsets.fromLTRB(8, 20, 8, 20)),
                  CustomListTile(
                      Icons.person,
                      'Your Profile',
                      () => {
                            Navigator.pushNamed(context, ProfilePage.route,
                                arguments: {
                                  'username': widget.username,
                                  'keypassed': -1
                                })
                          }),
                  CustomListTile(
                      MdiIcons.ticketPercentOutline,
                      'Coupons',
                      () => {
                            Navigator.pushNamed(context, CouponPage.route)
                            // TODO go to settings page
                          }),
                  CustomListTile(
                      Icons.lock, 'Log Out', () => {_showChoiceDialog(context)}),
                ],
              )),
              body: Center(child: Consumer<VerifyCredentials>(
                  builder: (context, credentials, child) {
                return TabBarView(
                  children: <Widget>[
                    Center(
                      child: (credentials.isAuthenticated(widget.username) &&
                              credentials.iscompleted(widget.username))
                          ? daywidget(context)
                          : Text(
                              'You\'re not auth, go to your profile and authoriz'),
                    ),
                    Center(
                      child: (credentials.isAuthenticated(widget.username) &&
                              credentials.iscompleted(widget.username))
                          ? weekwidget(context)
                          : Text(
                              'You\'re not auth, go to your profile and authoriz'),
                    ),
                    Center(
                      child: (credentials.isAuthenticated(widget.username) &&
                              credentials.iscompleted(widget.username))
                          ? monthwidget(context)
                          : Text(
                              'You\'re not auth, go to your profile and authorize'),
                    ),
                  ],
                );
              }))),
        ));
  }

  Widget daywidget(BuildContext context) {
    return SingleChildScrollView(
        child: DayWidget(
      username: widget.username,
    ));
  }

  Widget monthwidget(BuildContext context) {
    return MonthWidget(username: widget.username);
  }

  Widget weekwidget(BuildContext context) {
    return SingleChildScrollView(child: WeekWidget(username: widget.username));
  }
}

class CustomListTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback tapped;

  CustomListTile(this.icon, this.text, this.tapped);
  @override
  Widget build(BuildContext context) {
    //ToDO
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
      child: Container(
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade400))),
        child: InkWell(
            splashColor: Colors.blue,
            onTap: tapped,
            child: Container(
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(icon),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                        ),
                        Text(
                          text,
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    Icon(Icons.arrow_right)
                  ],
                ))),
      ),
    );
  }
}
