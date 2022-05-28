import 'dart:io';

import 'package:fitbitter/fitbitter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:login_flow/classes/DayDate.dart';
import 'package:login_flow/repository/databaserepository.dart';
import 'package:login_flow/screens/homepage.dart';
import 'package:login_flow/screens/loginpage.dart';
import 'package:provider/provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:shared_preferences/shared_preferences.dart';

import '../classes/credentialsFitbitter.dart';
import '../classes/fetchedData.dart';
import '../classes/myMonthData.dart';
import '../classes/verify_cred.dart';
import '../classes/credentialsFitbitter.dart';
import '../classes/myMonthData.dart';
import '../classes/fetchedData.dart';

import 'package:charts_flutter/flutter.dart' as charts;

import '../database/entities/mydata.dart';


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

  @override 
  void initState(){
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

  Future<bool> _checkauthorization()async{
    final  sp = await SharedPreferences.getInstance();
    bool authorized = false;
    if(sp.getString('userid') != null){
      authorized = true;
      Provider.of<VerifyCredentials>(context, listen: false).hascompleted(widget.username);
    }
    return authorized;
    
  }

  Future<void> computeMonthData(String userID) async {
   
    //steps
    FitbitActivityTimeseriesDataManager
        fitbitStepsDataManager =
        FitbitActivityTimeseriesDataManager(
      clientID: CredentialsFitbitter.clientID,
      clientSecret: CredentialsFitbitter.clientSecret,
      type: "steps",
    );

    // prendo i dati dal 1 Marzo
    
    FitbitActivityTimeseriesAPIURL fitbitStepsApiUrl =
    FitbitActivityTimeseriesAPIURL.dateRangeWithResource(
    startDate: DateTime.parse('2022-05-01 00:00:00'),
    endDate: DateTime.now(),
    userID: userID,
    resource: "steps"
    );
    final steps =
      await fitbitStepsDataManager.fetch(fitbitStepsApiUrl)
        as List<FitbitActivityTimeseriesData>;
  
  FitbitActivityTimeseriesDataManager
        fitbitCaloriesDataManager =
        FitbitActivityTimeseriesDataManager(
      clientID: CredentialsFitbitter.clientID,
      clientSecret: CredentialsFitbitter.clientSecret,
      type: "calories",
    );

  FitbitActivityTimeseriesAPIURL fitbitCaloriesApiUrl =
  FitbitActivityTimeseriesAPIURL.dateRangeWithResource(
    startDate: DateTime.parse('2022-05-01 00:00:00'),
    endDate: DateTime.now(),
    userID: userID,
    resource: "calories"
    );
    final calories =
      await fitbitCaloriesDataManager.fetch(fitbitCaloriesApiUrl)
        as List<FitbitActivityTimeseriesData>;
  
  FitbitActivityTimeseriesDataManager
        fitbitDistanceDataManager =
        FitbitActivityTimeseriesDataManager(
      clientID: CredentialsFitbitter.clientID,
      clientSecret: CredentialsFitbitter.clientSecret,
      type: "distance",
    );

  FitbitActivityTimeseriesAPIURL fitbitDistanceApiUrl =
  FitbitActivityTimeseriesAPIURL.dateRangeWithResource(
    startDate: DateTime.parse('2022-05-01 00:00:00'),
    endDate: DateTime.now(),
    userID: userID,
    resource: "distance"
    );
    final distances =
      await fitbitDistanceDataManager.fetch(fitbitDistanceApiUrl)
        as List<FitbitActivityTimeseriesData>;

  FitbitActivityTimeseriesDataManager
        fitbitMinutesFADataManager =
        FitbitActivityTimeseriesDataManager(
      clientID: CredentialsFitbitter.clientID,
      clientSecret: CredentialsFitbitter.clientSecret,
      type: "minutesFairlyActive",
    );

  FitbitActivityTimeseriesAPIURL fitbitMinutesFAApiUrl =
  FitbitActivityTimeseriesAPIURL.dateRangeWithResource(
    startDate: DateTime.parse('2022-05-01 00:00:00'),
    endDate: DateTime.now(),
    userID: userID,
    resource: "minutesFairlyActive"
    );
    final minutesFA =
      await fitbitMinutesFADataManager.fetch(fitbitMinutesFAApiUrl)
        as List<FitbitActivityTimeseriesData>;

  FitbitActivityTimeseriesDataManager
        fitbitMinutesVADataManager =
        FitbitActivityTimeseriesDataManager(
      clientID: CredentialsFitbitter.clientID,
      clientSecret: CredentialsFitbitter.clientSecret,
      type: "minutesVeryActive",
    );

  FitbitActivityTimeseriesAPIURL fitbitMinutesVAApiUrl =
  FitbitActivityTimeseriesAPIURL.dateRangeWithResource(
    startDate: DateTime.parse('2022-05-01 00:00:00'),
    endDate: DateTime.now(),
    userID: userID,
    resource: "minutesVeryActive"
    );
    final minutesVA =
      await fitbitMinutesVADataManager.fetch(fitbitMinutesVAApiUrl)
        as List<FitbitActivityTimeseriesData>;


    for(int i=0; i<steps.length; i++) {
      
      MyData mydata = MyData( steps[i].dateOfMonitoring!.day, steps[i].dateOfMonitoring!.month, steps[i].value, distances[i].value, calories[i].value, minutesFA[i].value, minutesVA[i].value);
      await Provider.of<DataBaseRepository>(context, listen:false).insertMyData(mydata);


    }

      
    final sp = await SharedPreferences.getInstance();
    sp.setString('userid', userID);
    Provider.of<VerifyCredentials>(context, listen: false).hascompleted(widget.username);
    
      setState(() {
      
    });
    
  } 

  
    
    
  

  @override
  Widget build(BuildContext context) {
    //File? imageFile = Provider.of<VerifyCredentials>(context, listen: false).Restituteuser(widget.username)['image'];
    File? imageFile = null;
    print(imageFile);
    final bool authorized = false;
    
   

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
              builder: (context, value, child) => FutureBuilder(
                future: _checkauthorization(),
                builder: (context, snapshot){
                if(snapshot.hasData){
                  final auth = snapshot.data;
                return Card(
                  child: value.isAuthenticated(widget.username) || auth  == true ? ElevatedButton(
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
                  final sp = await SharedPreferences.getInstance();
                  sp.remove('userid');
                  setState(() {
                    
                  });
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
                                
                                  setState(() {
                                  
                                });
                                
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
                ),);}else{
                  return CircularProgressIndicator();
                }},
              )

            ),
            ElevatedButton(
              onPressed:(){
                Provider.of<DataBaseRepository>(context, listen: false).deleteAllDatas();
              } , 
              child: Text('to mare'))],
            
          ),
        ),
      ),
    );
  }
}

