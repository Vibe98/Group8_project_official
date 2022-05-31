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
import '../classes/myMonthData.dart';
import '../classes/verify_cred.dart';
import '../classes/credentialsFitbitter.dart';
import '../classes/myMonthData.dart';

import 'package:charts_flutter/flutter.dart' as charts;

import '../database/entities/mydata.dart';
import '../utils/utils.dart';


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
              builder: (context, value, child) =>  Card(
                  child: value.isAuthenticated(widget.username) && value.iscompleted(widget.username)  == true ? ElevatedButton(
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
                  Provider.of<DataBaseRepository>(context, listen: false).deleteAllDatas();
                  
                  final sp = await SharedPreferences.getInstance();
                  sp.remove('userid');
                  setState(() {
                    
                  });
                  Provider.of<VerifyCredentials>(context, listen: false).AssociateAuthorization(widget.username, userId);
                  Provider.of<VerifyCredentials>(context, listen: false).hascompleted(widget.username);
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
                         onPressed:() async{
                          
                          String? userId = await FitbitConnector.authorize(
                          context: context,
                          clientID: CredentialsFitbitter.clientID,
                          clientSecret: CredentialsFitbitter.clientSecret,
                          redirectUri: CredentialsFitbitter.redirectUri,
                          callbackUrlScheme: 'example');
                          setState(() {
                            ena = true;
                          });
                          Provider.of<VerifyCredentials>(context, listen: false).AssociateAuthorization(widget.username, userId);
                          List<MyData> datalist = await computeMonthData(credentials.Restituteuser(widget.username)['userID'], DateTime.parse('2022-03-01 00:00:00'), DateTime.now(),); 
                          for(int i =0; i<datalist.length; i++){
                            MyData mydata = datalist[i];
                            Provider.of<DataBaseRepository>(context, listen:false).insertMyData(mydata);
                          }
                          final sp = await SharedPreferences.getInstance();
                            sp.setString('userid', credentials.Restituteuser(widget.username)['userID']);
                            
                            setState(() {
                              ena = false;
                            });
                            
                            Provider.of<VerifyCredentials>(context, listen:false).hascompleted(widget.username);
      
                        },
                        ),
                        
                    ],
                  ),
                ),)),
            
            ElevatedButton(
              onPressed:(){
                Provider.of<DataBaseRepository>(context, listen: false).deleteAllDatas();
              } , 
              child: Text('to mare')),
            
          ]),
        ),
      ),
    );
  }
}

