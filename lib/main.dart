import 'package:flutter/material.dart';
import 'package:login_flow/classes/changeMonth.dart';
import 'package:login_flow/classes/verify_cred.dart';
import 'package:login_flow/classes/weekdata.dart';
import 'package:login_flow/database/database.dart';
import 'package:login_flow/repository/databaserepository.dart';
import 'package:login_flow/screens/forgotpassword.dart';
import 'package:login_flow/screens/gardenpage.dart';
import 'package:login_flow/screens/homepage.dart';
import 'package:login_flow/screens/loginpage.dart';
import 'package:login_flow/screens/profilepage.dart';
import 'package:login_flow/screens/signin.dart';
import 'package:provider/provider.dart';
import 'package:login_flow/classes/DayDate.dart';



Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();

  final AppDatabase database = 
    await $FloorAppDatabase.databaseBuilder('app_database.db').build();

  final databaseRepository = DataBaseRepository(database: database);

  runApp(ChangeNotifierProvider<DataBaseRepository>(
    create: (context) => databaseRepository ,
    child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    
    return MultiProvider(
      providers: [
      ChangeNotifierProvider<VerifyCredentials>(
        create: (BuildContext context) => VerifyCredentials()),
      ChangeNotifierProvider<PickMonth>(
        create: (BuildContext context) => PickMonth()),
        ChangeNotifierProvider(
          create: (context) => DayData()),
        ChangeNotifierProvider(
          create: (context) => WeekData())
      ],
        child: MaterialApp(
          theme: ThemeData(
            primaryColor: Colors.green),
          initialRoute: LoginPage.route,
          onGenerateRoute: (settings) {
            if(settings.name == LoginPage.route){
              return MaterialPageRoute(builder: (context) {
                return LoginPage();
              });
            }else if(settings.name == SignIn.route){
              return MaterialPageRoute(builder: (context) {
                return SignIn();
              });
            }else if(settings.name == ForgotPassword.route){
              return MaterialPageRoute(builder: (context) {
                return ForgotPassword();
              });
          }else if(settings.name == HomePage.route){
            // in questo caso ho un argomento obbligatorio che è la password
            final args = settings.arguments as Map;
            return MaterialPageRoute(builder: (context) {
              return HomePage(username: args['username']);
            });
          }else if(settings.name == ProfilePage.route){
            // in questo caso ho un argomento obbligatorio che è la password
            final args = settings.arguments as Map;
            return MaterialPageRoute(builder: (context) {
              return ProfilePage(username: args['username'], keypassed: args['keypassed']);
            });
          }else if(settings.name == GardenPage.route){
            // in questo caso ho un argomento obbligatorio che è la password
            final args = settings.arguments as Map;
            return MaterialPageRoute(builder: (context) {
              return GardenPage(username: args['username']);
            });
          }
          }
        ),
    );
  }
}