import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_flow/classes/verify_cred.dart';
import 'package:login_flow/screens/loginpage.dart';
import 'package:provider/provider.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../classes/googleAuthApi.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  static const route = '/forgotpass';

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController answerController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  void checkAnswer() async {
    final sp = await SharedPreferences.getInstance();
    if(sp.getStringList('username')!=null){
      final answer = sp.getStringList('username')![5];
      
      // verify that the answer is correct
      if(answer==answerController.text){
        _showChoiceDialog(context);
      }else{
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: 
        Text('Your answer is not correct! Please insert the correct answer',
        ),
        backgroundColor: Colors.red,
        ));
      }
    }else{
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: 
        Text('You don\'t have an account, please sign in', 
        ),
        backgroundColor: Colors.red,
      ));
    }
  }

    Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Update your password',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: TextFormField(
                   
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Mandatory field';
                      } else if(value.length<8) {
                        return 'Password must be at least 8 characters length';
                      }else if (!value.contains(new RegExp(r'[0-9]'))) {
                        //it must contain a number
                        return 'Password must contain at least a number';
                      }else {
                        return null;
                      }
                    },
                    textInputAction: TextInputAction.next,
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: 'New Password *'),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.fromLTRB(15, 0, 15, 15),
                  child: TextFormField(
                    
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Mandatory field';
                      } else {
                        return null;
                      }
                    },
                    textInputAction: TextInputAction.next,
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Confirm Password *'),
                  ),
                ),
                Consumer<VerifyCredentials>(
                  builder: (context, verifyCred, child) => 
                  FloatingActionButton(
                      backgroundColor: Colors.green,
                        child: const Icon(Icons.done),
                        onPressed: () async {
                        
                            if (passwordController.text !=
                              confirmPasswordController.text) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text('Your password is not correct'),
                              backgroundColor: Colors.red,
                            ));
                          }else{
                            final sp = await SharedPreferences.getInstance();
                            if(sp.getStringList('username')!=null){
                              final username = sp.getStringList('username')![0];
                              final name = sp.getStringList('username')![1];
                              final surname = sp.getStringList('username')![2];
                              final email = sp.getStringList('username')![4];
                              sp.remove('username');
                              sp.setStringList('username', [username, name, surname, passwordController.text, email, answerController.text]);
                              
                              verifyCred.modifyAccount(username, email, name, surname, passwordController.text);
                              
                              setState(() {
                                
                              });
                              Navigator.pushNamed(context, LoginPage.route);
                            }
                          }
                        }
                        
                  ),
                )
              ],
            )
          );
        });
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Forgot your password?'),
      backgroundColor: Colors.green,),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: const Text(
                'Recover your password',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text('When is your mom\'s birthday?', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18), textAlign: TextAlign.left),
            ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: TextFormField(
                    controller: answerController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Answer *',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Mandatory field';
                      } 
                      return null;
                    },
                  ),
                ),
                ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green),
                    ),
                      child: const Text('Submit'),
                      onPressed: () async {
                        checkAnswer();
                      }
                ),
            Padding(
              padding: EdgeInsets.all(10),
              child: const Text(
                'Answer the question to recover your old password',
                style: TextStyle(fontSize: 15),),),
            
          ],
        ),
      ),
    );
  }
}

