import 'package:charts_flutter/flutter.dart' as charts;
import 'package:fitbitter/fitbitter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:login_flow/classes/credentialsFitbitter.dart';
import 'package:login_flow/screens/loginpage.dart';
import 'package:login_flow/screens/profilepage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'dart:ui';

import '../classes/changeMonth.dart';
import '../classes/monthChartGraph.dart';
import '../classes/myMonthData.dart';
import '../classes/verify_cred.dart';
import '../classes/fetchedData.dart';

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
          return AlertDialog(
            title: const Text('Are you sure you want to exit?'),
            content: SingleChildScrollView(
                child: ListBody(
              children: <Widget>[
                GestureDetector(
                    child: Text('Yes'),
                    onTap: () async {
                      final sp = await SharedPreferences.getInstance();
                      
                      //rimuovo le credenziali salvate
                      sp.remove('username');
                      setState(() {
                        
                      });
                      Navigator.pushReplacementNamed(context, LoginPage.route);
                    }),
                Padding(padding: EdgeInsets.all(8)),
                GestureDetector(
                    child: Text('No'),
                    onTap: () {
                      Navigator.of(context).pop();
                    })
              ],
            )),
          );
        });
  }

  int calendar = -1;
  DateTime selected_date = DateTime.now();
  int difference = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            title: const Text('My Data'),
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
                          color: Colors.blue)),
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
                  Icons.settings,
                  'Settings',
                  () => {
                        // TODO go to settings page
                      }),
              CustomListTile(
                  Icons.lock, 'Log Out', () => {_showChoiceDialog(context)}),
            ],
          )),
          body: Center(
            child: Consumer<VerifyCredentials>(
                builder: (context, credentials, child) {
              return TabBarView(
                children: <Widget>[
                  Center(
                    child: credentials.isAuthenticated(widget.username)
                        ? _buildForm(context)
                        : Text(
                            'You\'re not auth, go to your profile and authorize'),
                  ),
                  Center(
                    child: credentials.isAuthenticated(widget.username)
                        ? Text('Week data')
                        : Text(
                            'You\'re not auth, go to your profile and authorize'),
                  ),
                  Center(
                    child: credentials.isAuthenticated(widget.username)
                        ? monthPage(context)
                        : Text(
                            'You\'re not auth, go to your profile and authorize'),
                  ),
                ],
              );
            }),
          )),
    );
  }

  
  Widget monthPage(BuildContext context) {
    return Consumer<PickMonth>(
      builder: (context, pickmonth, child) => Center(
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                        onPressed: () {
                          // one month back
                          if(DateTime.now().month-pickmonth.month<3){
                            pickmonth.decreaseMonth();
                          }else{
                            null;
                          }
                        },
                        icon: Icon(Icons.arrow_back_ios, color: Colors.blue)),
                    Container(
                        child: Center(
                          child: Text(
                              '${DateFormat('MMMM').format(DateTime(0, pickmonth.getMonth()))} ${pickmonth.getYear()}',
                              style: TextStyle(fontSize: 18),
                              textAlign: TextAlign.center),
                        ),
                        width: 200,
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue),
                        )),
                    IconButton(
                        onPressed: () {
                          pickmonth.increaseMonth();
                        },
                        icon:
                            Icon(Icons.arrow_forward_ios, color: Colors.blue)),
                  ],
                ),
                
                Column(
                  children: [
                   
                    MonthChartGraph(data: FetchedData.stepsData[DateFormat('MMMM').format(DateTime(0,pickmonth.month))]!, month: pickmonth.month, category: 'Steps',),
                    MonthChartGraph(data: FetchedData.caloriesData[DateFormat('MMMM').format(DateTime(0,pickmonth.month))]!, month: pickmonth.month, category: 'Calories',),
                    MonthMinChartGraph(data1: FetchedData.minutesVeryActiveData[DateFormat('MMMM').format(DateTime(0,pickmonth.month))]!, data2: FetchedData.minutesFairlyActiveData[pickmonth.month]!, category1: 'Minutes Very Active', category2: 'Minutes Fairly Active'),
                  ],
                ),
                /*
                    }else{
                      return CircularProgressIndicator();
                    }
                  }
                ),
              ),
              */
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(
                onPressed: () {
                  if (calendar == -1) {
                    setState(() {
                      calendar = 0;
                    });
                  } else {
                    setState(() {
                      calendar = -1;
                    });
                  }
                },
                child: Icon(Icons.calendar_month)),
            SizedBox(width: 50),
            calendar == -1
                ? Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 65),
                    height: 150,
                    width: 150,
                    child: Text(
                        ' ${selected_date.day.toString()} - ${selected_date.month.toString()} - ${selected_date.year.toString()}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15)))
                : Container(
                    height: 150,
                    width: 150,
                    child: SfDateRangePicker(
                      view: DateRangePickerView.month,
                      minDate: DateTime(2022, 04, 01),
                      maxDate: DateTime.now(),
                      onSelectionChanged:
                          (DateRangePickerSelectionChangedArgs args) {
                        final dynamic value = args.value;
                        setState(() {
                          selected_date = value;
                          difference = DateTime.now().difference(value).inDays;
                        });
                      },
                    )),
          ]),
          Container(
              height: 70,
              width: 500,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              margin: const EdgeInsets.all(15.0),
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.blueAccent)),
              child: Text('Da aggiungere'))
        ],
      ),
    );
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

