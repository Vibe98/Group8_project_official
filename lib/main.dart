import 'package:flutter/material.dart';
import 'package:tomagolds/classes/changeMonth.dart';
import 'package:tomagolds/classes/verify_cred.dart';
import 'package:tomagolds/classes/weekdata.dart';
import 'package:tomagolds/database/database.dart';
import 'package:tomagolds/repository/databaserepository.dart';
import 'package:tomagolds/screens/couponpage.dart';
import 'package:tomagolds/screens/forgotpassword.dart';
import 'package:tomagolds/screens/gardenpage.dart';
import 'package:tomagolds/screens/homepage.dart';
import 'package:tomagolds/screens/loginpage.dart';
import 'package:tomagolds/screens/profilepage.dart';
import 'package:tomagolds/screens/signin.dart';
import 'package:tomagolds/screens/visualizeCouponPage.dart';
import 'package:provider/provider.dart';
import 'package:tomagolds/classes/DayDate.dart';



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
            
            final args = settings.arguments as Map;
            return MaterialPageRoute(builder: (context) {
              return HomePage(username: args['username']);
            });
          }else if(settings.name == ProfilePage.route){

            final args = settings.arguments as Map;
            return MaterialPageRoute(builder: (context) {
              return ProfilePage(username: args['username']);
            });
          }else if(settings.name == GardenPage.route){
            
            final args = settings.arguments as Map;
            return MaterialPageRoute(builder: (context) {
              return GardenPage(username: args['username']);
            });
          }else if(settings.name == CouponPage.route){
            return MaterialPageRoute(builder: (context) {
                return CouponPage();
            });
          }else if(settings.name == VisualizeCouponScreen.route){
            return MaterialPageRoute(builder: (context) {
              final args = settings.arguments as Map;
                return VisualizeCouponScreen(day: args['day'], month: args['month']);
            });
          }
          
          }),
    );
  }
}