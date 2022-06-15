import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:login_flow/classes/verify_cred.dart';
import 'package:login_flow/screens/homepage.dart';
import 'package:login_flow/screens/loginpage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  static const route = '/signin';

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  
  File? imageFile;


  Widget _decideImageView() {
    return Container(
        width: 250.0,
        height: 190.0,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage('assets/images/default_picture.png'))));
  }

  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign in'),
        backgroundColor: Colors.green,),
        
      body: ListView(
        children: [
          Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                const Text('Sign in',
                    style:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.w700)),
                Container(
                  child: const Text(
                      'Insert your credentials and then click on the button below'),
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                ),

                // add also an image
                _decideImageView(),
                
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty || value == '') {
                        return 'Insert something';
                      } else {
                        return null;
                      }
                    },
                    textInputAction: TextInputAction.next,
                    controller: nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Name *',
                    ),
                  ),
                ),
                //const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    controller: surnameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Mandatory field';
                      } else {
                        return null;
                      }
                    },
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Surname *'),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: TextFormField(
                    controller: usernameController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Username *',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Mandatory field';
                      } 
                      return null;
                    },
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    controller: emailController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'E-mail *',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Mandatory field';
                      } else if (!value.contains('@')) {
                        return 'Insert a valid email';
                      }
                      return null;
                    },
                  ),
                ),
                //const SizedBox(height: 20),
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
                        border: OutlineInputBorder(), labelText: 'Password *'),
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
                    controller: confirmpasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Confirm Password *'),
                  ),
                ),
                // add a button
                Consumer<VerifyCredentials>(
                  builder: (context, verifyCred, child) => 
                  FloatingActionButton(
                    backgroundColor: Colors.green,
                      child: const Icon(Icons.done),
                      onPressed: () async {
                        if(_formKey.currentState!.validate()){
                        if (!emailController.text.contains('@')) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('Insert a valid e-mail'),
                            backgroundColor: Colors.red,
                          ));
                        } else if(verifyCred.credentials.containsKey(emailController.text)){
                          //l'account è già esistente
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('An account with this e-mail already exist! Try recover your passowrd'),
                            backgroundColor: Colors.red,
                          ));
                        }else if (passwordController.text !=
                            confirmpasswordController.text) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('Your password is not correct'),
                            backgroundColor: Colors.red,
                          ));
                        } else {
                          // aggiungiamo l'account alla lista degli account
                          print(emailController.text);
                          print(passwordController.text);
                          
                          verifyCred.addAccount(usernameController.text, nameController.text, surnameController.text, passwordController.text, emailController.text);
                          final sp = await SharedPreferences.getInstance();
                          sp.setStringList('username', [usernameController.text, nameController.text, surnameController.text, passwordController.text, emailController.text]);
                          setState(() {
                            
                          });
                          Navigator.pushNamed(context, HomePage.route, arguments: {
                            'username': usernameController.text
                          });
                        }
                      }}),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
