import 'package:flutter/material.dart';
import 'package:login_flow/screens/loginpage.dart';
import 'package:login_flow/screens/profilepage.dart';
import 'package:provider/provider.dart';

import '../classes/verify_cred.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.username}) : super(key: key);

  static const route='/home';
  final String username;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // This widget is the root of your application.

    Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(context: context, 
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Are you sure you want to exit?'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              GestureDetector(
                child: Text('Yes'),
                onTap: () {
                  Navigator.pushNamed(context, LoginPage.route);
                }
              ),
              Padding(padding: EdgeInsets.all(8)),
              GestureDetector(
                child: Text('No'),
                onTap: () {
                  Navigator.of(context).pop();
                }
              )
            ],)
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
        appBar: AppBar(
          title: Text('Home Page')),
        drawer: Drawer(
          child: ListView(
            children: [
              Container(
                child: const Text('Application\'s Options', style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w500, color: Colors.blue
                )),
                padding: EdgeInsets.fromLTRB(8,20,8,20)
              ),
              CustomListTile(Icons.person, 'Your Profile', ()=>{
                
                Navigator.pushNamed(context, ProfilePage.route, arguments: {'username': widget.username, 'keypassed': -1})
              }),
              CustomListTile(Icons.settings, 'Settings', ()=>{
                // TODO go to settings page
              }),  
              CustomListTile(Icons.lock, 'Log Out', ()=>{
                _showChoiceDialog(context)
              }),
          ],)
        ),
        body: Center(
          child: Consumer<VerifyCredentials>(
          builder: (context, credentials, child) {
            return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              Text('Welcome back ${widget.username}!',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
              credentials.isAuthenticated(widget.username)? SizedBox() : Text('You\'re not auth')
            ],
          );}
        ),
    ));
  }
}

class CustomListTile extends StatelessWidget{  
  
  final IconData icon;  
  final String text;  
  final VoidCallback tapped;  
  
  CustomListTile(this.icon, this.text, this.tapped);  
  @override  
  Widget build(BuildContext context){  
    //ToDO   
    return Padding(  
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),  
      child:Container(  
        decoration: BoxDecoration(  
          border: Border(bottom: BorderSide(color: Colors.grey.shade400))  
        ),  
      child: InkWell(  
        splashColor: Colors.blue,  
        onTap: tapped,  
        child: Container(  
          height: 40,  
          child: Row(  
            mainAxisAlignment : MainAxisAlignment.spaceBetween,  
            children: <Widget>[  
            Row(children: <Widget>[  
            Icon(icon),  
            Padding(  
              padding: const EdgeInsets.all(8.0),  
            ),  
            Text(text, style: TextStyle(  
              fontSize: 16  
            ),),  
          ],),  
        Icon(Icons.arrow_right)  
      ],)  
        )   
    ),  
    ),  
    );  
  }  
}  