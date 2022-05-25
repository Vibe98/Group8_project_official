import 'package:flutter/material.dart';
import 'package:login_flow/classes/verify_cred.dart';
import 'package:login_flow/screens/forgotpassword.dart';
import 'package:login_flow/screens/homepage.dart';
import 'package:login_flow/screens/signin.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  static const route = '/';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //Form globalkey: this is required to validate the form fields.

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override 
  void initState() {
    // se lo user è già loggato vado diretto alla HomePage
  super.initState();

  _checkLogin();
  }

  void _checkLogin() async{
    final sp = await SharedPreferences.getInstance();
    if(sp.getStringList('username')!=null){
      // significa che lo user è già loggato
      final credentials = sp.getStringList('username');
      final username = credentials![0];
      final name = credentials[1];
      final surname = credentials[2];
      final password = credentials[3];
      final email = credentials[4];
      
      // a questo punto devo aggiungere l'account
      Provider.of<VerifyCredentials>(context, listen: false).addAccount(username, name, surname, password, email);
      Navigator.pushNamed(context, HomePage.route, arguments: {'username': username});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Login Page')),
        body: ListView(
          children: [
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 100),
                  Container(
                    height: 50,
                    child: const Text('My Application',
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.italic,
                            fontSize: 30)),
                    //padding: EdgeInsets.fromLTRB(0,30,0,15),
                  ),
                  Container(
                    child:
                        const Text('Sign in', style: TextStyle(fontSize: 20)),
                    // padding: EdgeInsets.fromLTRB(0,0,0,15),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                      
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      controller: nameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        icon: Icon(Icons.person),
                        labelText: 'Username *',
                      ),
                    ),
                  ),
                  //const SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        icon: Icon(Icons.security),
                        labelText: 'Password *',
                      ),
                    ),
                  ),
                  Container(
                    child: TextButton(
                      child: const Text('Forgot Password',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                      onPressed: () {
                        Navigator.pushNamed(context, ForgotPassword.route);
                      },
                    ),
                  ),
                  Consumer<VerifyCredentials>(
                    builder: (context, verifyCred, child) => 
                    Container(
                      width: 350,
                      height: 50,
                      // padding: EdgeInsets.fromLTRB(10,0,10,0),
                      child: ElevatedButton(
                          child: const Text('Login'),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()){  
                              if (!verifyCred.credentials.containsKey(nameController.text)){
                              // se non c'è un account con username corrente, allora bisogna crearlo
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text('Wrong username! Sign in if you do not have an account',
                                    style: TextStyle(fontSize: 15)),
                                backgroundColor: Colors.red,
                              ));
                            }else if (verifyCred.credentials[nameController.text].password != passwordController.text) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text('Wrong Password: try recover it',
                                    style: TextStyle(fontSize: 15)),
                                backgroundColor: Colors.red,
                              ));
                            } else {
                              
                              Navigator.pushNamed(context, HomePage.route, arguments: {
                                'username': nameController.text
                              });

                            }
                          }}),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Does not have an account?'),
                      TextButton(
                        child: const Text('Sign in',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500)),
                        onPressed: () {
                          Navigator.pushNamed(context, SignIn.route);
                        },
                      ),
                    ],
                  ),
                  
                  ElevatedButton(onPressed: () async {
                    final sp = await SharedPreferences.getInstance();
                    if(sp.getString('username')!=null){
                      //print(Provider.of<VerifyCredentials>(context, listen: false).Restituteuser(sp.getString('username')!)['email']);
                      sp.remove('username');
                      print(sp.getString('username'));
                    }else{
                      print('ok');
                    }
                  }, child: Text('prova')),
                ],
              ),
            ),
          ],
        ));
  }
}
