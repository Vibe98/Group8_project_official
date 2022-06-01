import 'package:fitbitter/fitbitter.dart';
import 'package:flutter/material.dart';
import 'package:login_flow/classes/credentialsFitbitter.dart';
import 'package:login_flow/classes/verify_cred.dart';
import 'package:login_flow/database/entities/mydata.dart';
import 'package:login_flow/repository/databaserepository.dart';
import 'package:login_flow/screens/forgotpassword.dart';
import 'package:login_flow/screens/homepage.dart';
import 'package:login_flow/screens/profilepage.dart';
import 'package:login_flow/screens/signin.dart';
import 'package:login_flow/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../classes/DayDate.dart';
import '../database/entities/mydata.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  static const route = '/';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //Form globalkey: this is required to validate the form fields.

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override 
  void initState() {
    // se lo user è già loggato vado diretto alla HomePage
  super.initState();

  _checkLogin();
  }

  String modifyDate(int date){
    //modifica mese o giorno aggiungendo 0 se inizia con un numero minore di 10
    String newDate='';
    if(date<10){
      newDate = '0$date';
    }else{
      newDate = '$date';
    }

    return newDate;
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

      // prendiamo anche lo userId
      final sc = await SharedPreferences.getInstance();
      if(sc.getString('userid')!=null){
        final userId=sc.getString('userid');
        Provider.of<VerifyCredentials>(context, listen: false).AssociateAuthorization(username, userId);
        final listlastday = await Provider.of<DataBaseRepository>(context, listen:false).findLastDay();
        
        Provider.of<DataBaseRepository>(context, listen: false).deleteLastDay();

        if(DateTime.now().day == listlastday!.day && DateTime.now().month == listlastday!.month){
          List<MyData> data = await computeMonthData(
            userId!, DateTime.now(), DateTime.now());

          Provider.of<DataBaseRepository>(context, listen:false).insertMyData(data[0]);
        }else{
          DateTime startdate = DateTime.parse('2022-${modifyDate(listlastday!.month)}-${modifyDate(listlastday!.day)}');
          DateTime enddate = DateTime.now();
          List<MyData> datalist = await computeMonthData(
            userId!, startdate, enddate);
          for(int i=0; i<datalist.length; i++){
            MyData mydata = datalist[i];
            Provider.of<DataBaseRepository>(context, listen:false)
            .insertMyData(mydata);
          }

          await FitbitConnector.refreshToken(
            clientID: CredentialsFitbitter.clientID,
            clientSecret: CredentialsFitbitter.clientSecret,
        );


        }
        //Provider.of<DayData>(context, listen: false).changeDay(DateTime.now());

        Provider.of<VerifyCredentials>(context, listen: false).hascompleted(username);
      }

    
      

      Navigator.pushNamed(context, HomePage.route, arguments: {'username': username});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Login Page'),
        backgroundColor: Colors.green,),
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
                      controller: usernameController,
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
                      child: Consumer<VerifyCredentials>(
                        builder: ((context, cred, child) => 
                        ElevatedButton(
                            child: const Text('Login'),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()){  
                                print(usernameController.text);
                                print(verifyCred.credentials);
                                if (!verifyCred.credentials.containsKey(usernameController.text)){
                                // se non c'è un account con username corrente, allora bisogna crearlo
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text('Wrong username! Sign in if you do not have an account',
                                      style: TextStyle(fontSize: 15)),
                                  backgroundColor: Colors.red,
                                ));
                              }else if (verifyCred.credentials[usernameController.text].password != passwordController.text) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text('Wrong Password: try recover it',
                                      style: TextStyle(fontSize: 15)),
                                  backgroundColor: Colors.red,
                                ));
                              } else {
                                // esiste un profilo quindi mi ricavo le sue info e lo salvo in memoria
                                final name = cred.Restituteuser(usernameController.text)['name'];
                                final surname = cred.Restituteuser(usernameController.text)['surname'];
                                final email = cred.Restituteuser(usernameController.text)['email'];

                                final sp = await SharedPreferences.getInstance();
                                if(sp.getStringList('username')== null){
                                  sp.setStringList('username', [usernameController.text, name, surname, passwordController.text, email]);
                                
                                }
                                Navigator.pushNamed(context, HomePage.route, arguments: {
                                  'username': usernameController.text
                                });
                      
                              }
                            }})),
                      ),
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
                  
                ],
              ),
            ),
          ],
        ));
  }
}
