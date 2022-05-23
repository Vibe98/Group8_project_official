import 'dart:io';

import 'package:fitbitter/fitbitter.dart';
import 'package:flutter/material.dart';
import 'package:login_flow/screens/loginpage.dart';
import 'package:provider/provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import '../classes/credentialsFitbitter.dart';
import '../classes/fetchedData.dart';
import '../classes/myMonthData.dart';
import '../classes/verify_cred.dart';

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

  String _displayMonth(int month){
    // devo visualizzarlo come 01 o 09 se è minore di 10
    String newMonth="";
    if(month<10){
      newMonth = "0${month-1}";
    }else{
      newMonth = "${month-1}";
    }
    return newMonth;
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
        baseDate: i == 0 ? DateTime.now() : DateTime.now().subtract(Duration(days: i*30)),
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
      FetchedData.stepsData[i] = stepsValue;
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
        baseDate: i == 0 ? DateTime.now() : DateTime.now().subtract(Duration(days: i*30)),
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
      FetchedData.caloriesData[i] = caloriesValue;
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
        baseDate: i == 0 ? DateTime.now() : DateTime.parse("${DateTime.now().year}-${_displayMonth(DateTime.now().month)}-${DateTime.now().day}"),
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
      FetchedData.minutesFairlyActiveData[i] = FActiveValue;
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
        baseDate: i == 0 ? DateTime.now() : DateTime.parse("${DateTime.now().year}-${_displayMonth(DateTime.now().month)}-${DateTime.now().day}"),
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
      FetchedData.minutesVeryActiveData[i] = VActiveValue;
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
    File? imageFile = Provider.of<VerifyCredentials>(context, listen: false)
        .Restituteuser(widget.username)['image'];
    print(imageFile);

    ena = actual == -1 ? false : true;

    return Scaffold(
      appBar: AppBar(title: Text('Profile Page')),
      body: Form(
        child: SingleChildScrollView(
          child: Column(
            children: [
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
              TextFormField(
                  controller: usernameController,
                  enabled: false,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      icon: Icon(
                        Icons.person,
                        color: Colors.blue,
                      ),
                      labelText: 'Username')),
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
                      ? Text('Click to Modify')
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
                child: value.isAuthenticated(widget.username) ? ElevatedButton(child: Text('You\'re authorized. Click if you want to unauthorized'), onPressed: ()async{
                await FitbitConnector.unauthorize(
                clientID: '238C5P',
                clientSecret: '8b6a58492553191918d2cce62a2052c6'
                );
                String userId = '';
                Provider.of<VerifyCredentials>(context, listen: false).AssociateAuthorization(widget.username, userId);
                }) :
              Consumer<VerifyCredentials>(
                builder: (context, credentials, child) =>
                ElevatedButton(
                  child: Text('Authorize'),
                  onPressed: ()async{
                    String? userId = await FitbitConnector.authorize(
                    context: context,
                    clientID: '238C5P',
                    clientSecret: '8b6a58492553191918d2cce62a2052c6',
                    redirectUri: 'example://fitbit/auth',
                    callbackUrlScheme: 'example');
                    Provider.of<VerifyCredentials>(context, listen: false).AssociateAuthorization(widget.username, userId);
                    await computeMonthData(credentials.Restituteuser(widget.username)['userID']);
                  },
                  ),
              ),)

            )],
          ),
        ),
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
