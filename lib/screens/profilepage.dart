import 'dart:io';

import 'package:fitbitter/fitbitter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:login_flow/screens/homepage.dart';
import 'package:login_flow/screens/loginpage.dart';
import 'package:provider/provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import '../classes/credentialsFitbitter.dart';
import '../classes/fetchedData.dart';
import '../classes/myMonthData.dart';
import '../classes/verify_cred.dart';
import '../classes/credentialsFitbitter.dart';
import '../classes/myMonthData.dart';
import '../classes/fetchedData.dart';

import 'package:charts_flutter/flutter.dart' as charts;


class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, required this.username, required this.keypassed})
      : super(key: key);

  static const route = '/profile';
  final String username;
  final int keypassed;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // This widget is the root of your application.

  int actual = -1;
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool ena = false;

  Future<void> computeMonthData(String userID) async {
    FetchedData.complete=false;

    //steps
    FitbitActivityTimeseriesDataManager
        fitbitStepsDataManager =
        FitbitActivityTimeseriesDataManager(
      clientID: CredentialsFitbitter.clientID,
      clientSecret: CredentialsFitbitter.clientSecret,
      type: "steps",
    );

    // prendo i dati dell'ultimo anno
    for(var i=0; i<4; i++) {
      FitbitActivityTimeseriesAPIURL fitbitStepsApiUrl =
          FitbitActivityTimeseriesAPIURL.monthWithResource(
        baseDate: DateTime(DateTime.now().year, DateTime.now().month+1-i, 0),
        userID: userID,
        resource: "steps"
      );
      final data =
          await fitbitStepsDataManager.fetch(fitbitStepsApiUrl)
              as List<FitbitActivityTimeseriesData>;
      List<myMonthData> stepsValue = [];
      for(var k=0;k<data.length; k++){
        myMonthData addStepsData = myMonthData(day: '${data[k].dateOfMonitoring!.day}', month: '${data[k].dateOfMonitoring!.month}', value: data[k].value, barColor: charts.Color(r:0,g:100,b:0));
        stepsValue.add(addStepsData);
      }
      FetchedData.stepsData[DateFormat('MMMM').format(DateTime(0, DateTime.now().month-i))] = stepsValue;
    }

    //calories
    FitbitActivityTimeseriesDataManager
        fitbitCaloriesDataManager =
        FitbitActivityTimeseriesDataManager(
      clientID: CredentialsFitbitter.clientID,
      clientSecret: CredentialsFitbitter.clientSecret,
      type: "calories",
    );

    // prendo i dati dell'ultimo anno
    for(var i=0; i<4; i++) {
      FitbitActivityTimeseriesAPIURL fitbitCaloriesApiUrl =
          FitbitActivityTimeseriesAPIURL.monthWithResource(
        baseDate: DateTime(DateTime.now().year, DateTime.now().month+1-i, 0),
        userID: userID,
        resource: "calories"
      );
      final data =
          await fitbitCaloriesDataManager.fetch(fitbitCaloriesApiUrl)
              as List<FitbitActivityTimeseriesData>;
      List<myMonthData> caloriesValue = [];
      for(var k=0;k<data.length; k++){
        myMonthData addCaloriesData = myMonthData(day: '${data[k].dateOfMonitoring!.day}', month: '${data[k].dateOfMonitoring!.month}', value: data[k].value, barColor: charts.Color(r:0,g:0,b:100));
        caloriesValue.add(addCaloriesData);
      }
      FetchedData.caloriesData[DateFormat('MMMM').format(DateTime(0, DateTime.now().month-i))] = caloriesValue;
    }

    //minutes fairly active
    FitbitActivityTimeseriesDataManager
        fitbitFActiveDataManager =
        FitbitActivityTimeseriesDataManager(
      clientID: CredentialsFitbitter.clientID,
      clientSecret: CredentialsFitbitter.clientSecret,
      type: "minutesFairlyActive",
    );

    // prendo i dati dell'ultimo anno
    for(var i=0; i<4; i++) {
      FitbitActivityTimeseriesAPIURL fitbitFActiveApiUrl =
          FitbitActivityTimeseriesAPIURL.monthWithResource(
        baseDate: DateTime(DateTime.now().year, DateTime.now().month+1-i, 0),
        userID: userID,
        resource: "minutesFairlyActive"
      );
      final data =
          await fitbitFActiveDataManager.fetch(fitbitFActiveApiUrl)
              as List<FitbitActivityTimeseriesData>;
      List<myMonthData> FActiveValue = [];
      for(var k=0;k<data.length; k++){
        myMonthData addFActiveData = myMonthData(day: '${data[k].dateOfMonitoring!.day}', month: '${data[k].dateOfMonitoring!.month}', value: data[k].value, barColor: charts.Color(r:100,g:0,b:0));
        FActiveValue.add(addFActiveData);
      }
      FetchedData.minutesFairlyActiveData[DateFormat('MMMM').format(DateTime(0, DateTime.now().month-i))] = FActiveValue;
    }

    //minutes very active
    FitbitActivityTimeseriesDataManager
        fitbitVActiveDataManager =
        FitbitActivityTimeseriesDataManager(
      clientID: CredentialsFitbitter.clientID,
      clientSecret: CredentialsFitbitter.clientSecret,
      type: "minutesVeryActive",
    );

    // prendo i dati dell'ultimo anno
    for(var i=0; i<4; i++) {
      FitbitActivityTimeseriesAPIURL fitbitVActiveApiUrl =
          FitbitActivityTimeseriesAPIURL.monthWithResource(
        baseDate: DateTime(DateTime.now().year, DateTime.now().month+1-i, 0),
        userID: userID,
        resource: "minutesVeryActive"
      );
      final data =
          await fitbitVActiveDataManager.fetch(fitbitVActiveApiUrl)
              as List<FitbitActivityTimeseriesData>;
      List<myMonthData> VActiveValue = [];
      for(var k=0;k<data.length; k++){
        myMonthData addVActiveData = myMonthData(day: '${data[k].dateOfMonitoring!.day}', month: '${data[k].dateOfMonitoring!.month}', value: data[k].value, barColor: charts.Color(r:255,g:127,b:80));
        VActiveValue.add(addVActiveData);
      }
      FetchedData.minutesVeryActiveData[DateFormat('MMMM').format(DateTime(0, DateTime.now().month-i))] = VActiveValue;
    }

    FetchedData.complete = true;
    if(mounted){
      setState(() {
      
    });
    }
  } 

  @override
  void initState() {
    nameController.text = Provider.of<VerifyCredentials>(context, listen: false)
        .Restituteuser(widget.username)['name'];

    surnameController.text =
        Provider.of<VerifyCredentials>(context, listen: false)
            .Restituteuser(widget.username)['surname'];
    usernameController.text =
        Provider.of<VerifyCredentials>(context, listen: false)
            .Restituteuser(widget.username)['username'];
    emailController.text =
        Provider.of<VerifyCredentials>(context, listen: false)
            .Restituteuser(widget.username)['email'];
    passwordController.text =
        Provider.of<VerifyCredentials>(context, listen: false)
            .Restituteuser(widget.username)['password'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //File? imageFile = Provider.of<VerifyCredentials>(context, listen: false).Restituteuser(widget.username)['image'];
    File? imageFile = null;
    print(imageFile);

    ena = actual == -1 ? false : true;

    return Scaffold(
      appBar: AppBar(title: Text('Profile Page')),
      body: Form(
        child: SingleChildScrollView(
          child: Column(
            children: [ 
              
              TextField(
                readOnly: true,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                decoration: InputDecoration(
                      border: InputBorder.none
                ),
                controller: usernameController,
                
              ),
              Container(
                width: 250.0,
                height: 190.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: imageFile == null
                          ? AssetImage('assets/images/default_picture.png')
                          : FileImage(imageFile) as ImageProvider),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                  controller: nameController,
                  enabled: ena,
                  decoration: InputDecoration(
                      border: actual == -1
                          ? InputBorder.none
                          : OutlineInputBorder(),
                      icon: Icon(
                        Icons.person,
                        color: Colors.blue,
                      ),
                      labelText: 'Name')),
              SizedBox(height: 20),
              TextFormField(
                controller: surnameController,
                enabled: ena,
                decoration: InputDecoration(
                    border:
                        actual == -1 ? InputBorder.none : OutlineInputBorder(),
                    icon: Icon(
                      Icons.person,
                      color: Colors.blue,
                    ),
                    labelText: 'Surname'),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                enabled: ena,
                decoration: InputDecoration(
                    border:
                        actual == -1 ? InputBorder.none : OutlineInputBorder(),
                    icon: Icon(Icons.email, color: Colors.blue),
                    labelText: 'E-mail'),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: passwordController,
                enabled: ena,
                decoration: InputDecoration(
                    border:
                        actual == -1 ? InputBorder.none : OutlineInputBorder(),
                    icon: Icon(
                      Icons.key,
                      color: Colors.blue,
                    ),
                    labelText: 'Password'),
                obscureText: true,
              ),
              ElevatedButton(
                  onPressed: () {
                    if (actual == -1) {
                      setState(() {
                        actual = 0;
                      });
                    } else {
                      Provider.of<VerifyCredentials>(context, listen: false)
                          .modifyAccount(
                              widget.username,
                              emailController.text,
                              nameController.text,
                              surnameController.text,
                              passwordController.text);
                      setState(() {
                        actual = -1;
                      });
                    }
                    ;
                  },
                  child: actual == -1
                      ? Text('Edit Your Infos')
                      : Icon(Icons.check),
                  style: actual == -1
                      ? ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        )
                      : ElevatedButton.styleFrom(shape: CircleBorder())),
            Consumer<VerifyCredentials>(
              builder: (context, value, child) => Card(
                child: value.isAuthenticated(widget.username) && FetchedData.complete == true ? ElevatedButton(
                  child: Text('You\'re connected. \n Click if you want to disconnect', textAlign: TextAlign.center,), 
                  style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  textStyle: TextStyle(
                  fontWeight: FontWeight.bold)), 
                  onPressed: ()async{
                await FitbitConnector.unauthorize(
                clientID: CredentialsFitbitter.clientID,
                clientSecret: CredentialsFitbitter.clientSecret
                );
                String userId = '';
                Provider.of<VerifyCredentials>(context, listen: false).AssociateAuthorization(widget.username, userId);
                }) :
              Consumer<VerifyCredentials>(
                builder: (context, credentials, child) =>
                Column(
                  children: [
                    ElevatedButton(
                      child: Text('Authorize'),
                      style: ElevatedButton.styleFrom(
                      primary: Colors.redAccent,
                  
                      textStyle: TextStyle(
                      fontWeight: FontWeight.bold)), 
                      onPressed: ()async{
                        String? userId = await FitbitConnector.authorize(
                        context: context,
                        clientID: CredentialsFitbitter.clientID,
                        clientSecret: CredentialsFitbitter.clientSecret,
                        redirectUri: CredentialsFitbitter.redirectUri,
                        callbackUrlScheme: 'example');
                        Provider.of<VerifyCredentials>(context, listen: false).AssociateAuthorization(widget.username, userId);
                        FutureBuilder(
                          future:  computeMonthData(credentials.Restituteuser(widget.username)['userID']),
                          builder:(context, snapshot){
                            if(snapshot.hasData){
                              FetchedData.complete = true;
                              if(mounted){
                                setState(() {
                                
                              });
                              }
                              Navigator.pushNamed(context, HomePage.route, arguments: {
                                'username': widget.username
                    
                              });
                              return Text('');
                            }else{
                              return CircularProgressIndicator();
                            }
                          });
                      },
                      ),
                  ],
                ),
              ),)

            )],
          ),
        ),
      ),
    );
  }
}

Future<void> computeMonthData(String userID) async {
    Map<int, List<myMonthData>> monthData= {};

    //steps
    FitbitActivityTimeseriesDataManager
        fitbitStepsDataManager =
        FitbitActivityTimeseriesDataManager(
      clientID: CredentialsFitbitter.clientID,
      clientSecret: CredentialsFitbitter.clientSecret,
      type: "steps",
    );

    // prendo i dati dell'ultimo anno
    for(var i=0; i<4; i++) {
      FitbitActivityTimeseriesAPIURL fitbitStepsApiUrl =
          FitbitActivityTimeseriesAPIURL.monthWithResource(
        baseDate: DateTime(DateTime.now().year, DateTime.now().month + 1 - i, 0),
        userID: userID,
        resource: "steps"
      );
      final data =
          await fitbitStepsDataManager.fetch(fitbitStepsApiUrl)
              as List<FitbitActivityTimeseriesData>;
      List<myMonthData> stepsValue = [];
      for(var k=0;k<data.length; k++){
        myMonthData addStepsData = myMonthData(day: '${data[k].dateOfMonitoring!.day}', month: '${data[k].dateOfMonitoring!.month}', value: data[k].value, barColor: charts.Color(r:0,g:100,b:0));
        stepsValue.add(addStepsData);
      }
      FetchedData.stepsData[DateFormat('MMMM').format(DateTime(0,DateTime.now().month - i))] = stepsValue;
    }

    //calories
    FitbitActivityTimeseriesDataManager
        fitbitCaloriesDataManager =
        FitbitActivityTimeseriesDataManager(
      clientID: CredentialsFitbitter.clientID,
      clientSecret: CredentialsFitbitter.clientSecret,
      type: "calories",
    );

    // prendo i dati dell'ultimo anno
    for(var i=0; i<4; i++) {
      FitbitActivityTimeseriesAPIURL fitbitCaloriesApiUrl =
          FitbitActivityTimeseriesAPIURL.monthWithResource(
        baseDate: DateTime(DateTime.now().year, DateTime.now().month + 1 - i, 0),
        userID: userID,
        resource: "calories"
      );
      final data =
          await fitbitCaloriesDataManager.fetch(fitbitCaloriesApiUrl)
              as List<FitbitActivityTimeseriesData>;
      List<myMonthData> caloriesValue = [];
      for(var k=0;k<data.length; k++){
        myMonthData addCaloriesData = myMonthData(day: '${data[k].dateOfMonitoring!.day}', month: '${data[k].dateOfMonitoring!.month}', value: data[k].value, barColor: charts.Color(r:0,g:0,b:100));
        caloriesValue.add(addCaloriesData);
      }
      FetchedData.caloriesData[DateFormat('MMMM').format(DateTime(0,DateTime.now().month - i))] = caloriesValue;
    }

    //minutes fairly active
    FitbitActivityTimeseriesDataManager
        fitbitFActiveDataManager =
        FitbitActivityTimeseriesDataManager(
      clientID: CredentialsFitbitter.clientID,
      clientSecret: CredentialsFitbitter.clientSecret,
      type: "minutesFairlyActive",
    );

    // prendo i dati dell'ultimo anno
    for(var i=0; i<4; i++) {
      FitbitActivityTimeseriesAPIURL fitbitFActiveApiUrl =
          FitbitActivityTimeseriesAPIURL.monthWithResource(
        baseDate: DateTime(DateTime.now().year, DateTime.now().month + 1 - i, 0),
        userID: userID,
        resource: "minutesFairlyActive"
      );
      final data =
          await fitbitFActiveDataManager.fetch(fitbitFActiveApiUrl)
              as List<FitbitActivityTimeseriesData>;
      List<myMonthData> FActiveValue = [];
      for(var k=0;k<data.length; k++){
        myMonthData addFActiveData = myMonthData(day: '${data[k].dateOfMonitoring!.day}', month: '${data[k].dateOfMonitoring!.month}', value: data[k].value, barColor: charts.Color(r:100,g:0,b:0));
        FActiveValue.add(addFActiveData);
      }
      FetchedData.minutesFairlyActiveData[DateFormat('MMMM').format(DateTime(0,DateTime.now().month - i))] = FActiveValue;
    }

    //minutes very active
    FitbitActivityTimeseriesDataManager
        fitbitVActiveDataManager =
        FitbitActivityTimeseriesDataManager(
      clientID: CredentialsFitbitter.clientID,
      clientSecret: CredentialsFitbitter.clientSecret,
      type: "minutesVeryActive",
    );

    // prendo i dati dell'ultimo anno
    for(var i=0; i<4; i++) {
      FitbitActivityTimeseriesAPIURL fitbitVActiveApiUrl =
          FitbitActivityTimeseriesAPIURL.monthWithResource(
        baseDate: DateTime(DateTime.now().year, DateTime.now().month + 1 - i, 0),
        userID: userID,
        resource: "minutesVeryActive"
      );
      final data =
          await fitbitVActiveDataManager.fetch(fitbitVActiveApiUrl)
              as List<FitbitActivityTimeseriesData>;
      List<myMonthData> VActiveValue = [];
      for(var k=0;k<data.length; k++){
        myMonthData addVActiveData = myMonthData(day: '${data[k].dateOfMonitoring!.day}', month: '${data[k].dateOfMonitoring!.month}', value: data[k].value, barColor: charts.Color(r:255,g:127,b:80));
        VActiveValue.add(addVActiveData);
      }
      FetchedData.minutesVeryActiveData[DateFormat('MMMM').format(DateTime(0,DateTime.now().month - i))] = VActiveValue;
    }
    
  } 