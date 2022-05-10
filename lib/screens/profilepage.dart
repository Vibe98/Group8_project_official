import 'dart:io';

import 'package:flutter/material.dart';
import 'package:login_flow/screens/loginpage.dart';
import 'package:provider/provider.dart';

import '../classes/verify_cred.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, required this.username, required this.keypassed}) : super(key: key);

  static const route='/profile';
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
    nameController.text = Provider.of<VerifyCredentials>(context, listen: false).Restituteuser(widget.username)['name'];
   
    surnameController.text = Provider.of<VerifyCredentials>(context, listen: false).Restituteuser(widget.username)['surname'];
    usernameController.text = Provider.of<VerifyCredentials>(context, listen: false).Restituteuser(widget.username)['username'];
    emailController.text = Provider.of<VerifyCredentials>(context, listen: false).Restituteuser(widget.username)['email'];
    passwordController.text = Provider.of<VerifyCredentials>(context, listen: false).Restituteuser(widget.username)['password'];
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    File? imageFile =  Provider.of<VerifyCredentials>(context, listen: false).Restituteuser(widget.username)['image'];
    print(imageFile);

    ena = actual == -1 ? false : true;
  
    return Scaffold(
        appBar: AppBar(
          title: Text('Profile Page')),
        body: Form(
          child:  SingleChildScrollView(
            child: Column(
            
              children:[
                Container(
                  width: 250.0,
                  height: 190.0,
                  decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.fill,
              image: imageFile == null 
              ? AssetImage('assets/images/default_picture.png')
              : FileImage(imageFile) as ImageProvider),),),
            
                TextFormField(
                  controller: usernameController,
                  enabled: false,
                  decoration: InputDecoration(   
                    border: InputBorder.none , 
                    icon: Icon(Icons.person, color: Colors.blue,),                         
                    labelText: 'Username')
              
                    
                ),
                SizedBox(
                  height:10
                ),
                TextFormField(
                  controller: nameController,
                  enabled: ena,
                  decoration: InputDecoration(   
                    border: actual == -1 ? InputBorder.none : OutlineInputBorder(), 
                    icon: Icon(Icons.person, color: Colors.blue,),                         
                    labelText: 'Name')
              
                    
                ),
                SizedBox(
                  height:20
                ),
                TextFormField(
                  controller: surnameController,
                  enabled: ena,
                  decoration: InputDecoration(   
                    border: actual == -1 ? InputBorder.none : OutlineInputBorder(), 
                    icon: Icon(Icons.person, color: Colors.blue,),                         
                    labelText: 'Surname'),
                    
                ),
                 SizedBox(
                  height:20
                ),
                TextFormField(
                  controller: emailController,
                  enabled: ena,
                  decoration: InputDecoration(   
                    border: actual == -1 ? InputBorder.none : OutlineInputBorder(), 
                    icon: Icon(Icons.email, color: Colors.blue),                         
                    labelText: 'E-mail'),
                    
                ),
                SizedBox(
                  height:20
                ),
                TextFormField(
                  controller: passwordController,
                  enabled: ena,
                  decoration: InputDecoration(   
                    border: actual == -1 ? InputBorder.none : OutlineInputBorder(), 
                    icon: Icon(Icons.key, color: Colors.blue,),                         
                    labelText: 'Password'),
                  obscureText: true,
                    
                ),
                ElevatedButton(
                  onPressed: (){
                    if (actual == -1){
                      setState((){actual = 0;});
                      }else{
                      Provider.of<VerifyCredentials>(context, listen: false).modifyAccount(widget.username, emailController.text, nameController.text, surnameController.text, passwordController.text);
                      setState((){actual = -1;});
                    };
                    },
                    child: actual == -1 ? Text('Click to Modify') : Icon(Icons.check),
                    style: actual == -1 ?  ElevatedButton.styleFrom(shape: RoundedRectangleBorder(  borderRadius: BorderRadius.circular(30.0),  ),) :ElevatedButton.styleFrom(shape: CircleBorder())  )
                
              ],
            ),
          ),
        ),
    );
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