import 'package:fitbitter/fitbitter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tomagolds/classes/DayDate.dart';
import 'package:tomagolds/repository/databaserepository.dart';
import 'package:tomagolds/screens/loginpage.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../classes/credentialsFitbitter.dart';
import '../classes/verify_cred.dart';
import '../database/entities/couponentity.dart';
import '../database/entities/mydata.dart';
import '../utils/utils.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, required this.username}) : super(key: key);

  static const route = '/profile';
  final String username;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  int actual = -1;
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool ena = false;

  @override
  void initState() {
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

  Future<void>? _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          BuildContext dialogContext = context;
          return AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0))),
              title: const Text('Connecting to your fitbit account...'),
              content:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                SizedBox(
                    height: 40,
                    width: 40,
                    child: CircularProgressIndicator(color: Colors.green))
              ]));
        });
  }

  Future<void> _showDeleteDialogue(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            content: const Text('Are you sure you want to delete your account?',
                style: TextStyle(fontSize: 20)),
            actions: <Widget>[
              CupertinoDialogAction(
                  isDefaultAction: true,
                  child: const Text('Yes'),
                  onPressed: () async {
                    final sp = await SharedPreferences.getInstance();
                    final keys = sp.getKeys().toList();
                    int L = keys.length;
                    for (int i = 0; i < L; i++) {
                      sp.remove(keys[i]);
                    }
                    Provider.of<DataBaseRepository>(context, listen: false)
                        .deleteAllCoupons();
                    Provider.of<DataBaseRepository>(context, listen: false)
                        .deleteAllDatas();
                    Navigator.pushNamedAndRemoveUntil(
                        context, LoginPage.route, ModalRoute.withName('/'));
                  }),
              CupertinoDialogAction(
                  isDefaultAction: true,
                  child: const Text('Cancel'),
                  textStyle: const TextStyle(color: Colors.red),
                  onPressed: () {
                    Navigator.of(context).pop();
                  })
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
   
    ena = actual == -1 ? false : true;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
        backgroundColor: Colors.green,
      ),
      body: Form(
        child: SingleChildScrollView(
          child: Column(children: [
            TextField(
              readOnly: true,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              decoration: const InputDecoration(border: InputBorder.none),
              controller: usernameController,
            ),
            const SizedBox(height: 10),
            Container(
              alignment: Alignment.center,
              width: 200.0,
              height: 200.0,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromARGB(255, 28, 70, 47),
              ),
              child: Center(
                  child: Text(
                nameController.text[0],
                style: const TextStyle(fontSize: 130, color: Colors.white),
              )),
            ),
            const SizedBox(height: 10),
            Container(
              width: 400,
              child: TextFormField(
                  controller: nameController,
                  enabled: ena,
                  decoration: InputDecoration(
                      border: actual == -1
                          ? InputBorder.none
                          : const OutlineInputBorder(),
                      icon: const Icon(
                        Icons.person,
                        color: Colors.green,
                      ),
                      labelText: 'Name')),
            ),
            const SizedBox(height: 20),
            Container(
              width: 400,
              child: TextFormField(
                controller: surnameController,
                enabled: ena,
                decoration: InputDecoration(
                    border:
                        actual == -1 ? InputBorder.none : const OutlineInputBorder(),
                    icon: const Icon(
                      Icons.person,
                      color: Colors.green,
                    ),
                    labelText: 'Surname'),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 400,
              child: TextFormField(
                controller: emailController,
                enabled: ena,
                decoration: InputDecoration(
                    border:
                        actual == -1 ? InputBorder.none : const OutlineInputBorder(),
                    icon: const Icon(Icons.email, color: Colors.green),
                    labelText: 'E-mail'),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 400,
              child: TextFormField(
                controller: passwordController,
                enabled: ena,
                decoration: InputDecoration(
                    border:
                        actual == -1 ? InputBorder.none : const OutlineInputBorder(),
                    icon: const Icon(
                      Icons.key,
                      color: Colors.green,
                    ),
                    labelText: 'Password'),
                obscureText: true,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                    onPressed: () async {
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
                        final sp = await SharedPreferences.getInstance();
                        if (sp.getStringList('username') != null) {
                          final answer = sp.getStringList('username')![5];

                          sp.remove('username');
                          sp.setStringList('username', [
                            widget.username,
                            nameController.text,
                            surnameController.text,
                            passwordController.text,
                            emailController.text,
                            answer
                          ]);
                        }
                        setState(() {
                          actual = -1;
                        });
                      }
                      ;
                    },
                    child: actual == -1 ? const Icon(Icons.edit) : const Icon(Icons.check),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.green, shape: const CircleBorder())),
              ],
            ),
            Consumer<VerifyCredentials>(
                builder: (context, credentials, child) => Padding(
                      padding: const EdgeInsets.fromLTRB(8, 1, 8, 1),
                      child: Column(
                        children: [
                          const Text('FitBit connection status',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          Row(
                            children: [
                              const Text('You\'re actually: '),
                              credentials.isAuthenticated(widget.username) &&
                                      credentials
                                              .iscompleted(widget.username) ==
                                          true
                                  ? const Text('Authorized',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(
                                              255, 12, 91, 53)))
                                  : const Text('Unauthorized',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(
                                              255, 143, 36, 36))),
                              const SizedBox(
                                width: 100,
                              ),
                              credentials.isAuthenticated(widget.username) &&
                                      credentials
                                              .iscompleted(widget.username) ==
                                          true
                                  ? ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.red),
                                      onPressed: () async {
                                        await FitbitConnector.unauthorize(
                                            clientID:
                                                CredentialsFitbitter.clientID,
                                            clientSecret: CredentialsFitbitter
                                                .clientSecret);
                                        String userId = '';
                                        Provider.of<DataBaseRepository>(
                                                context,
                                                listen: false)
                                            .deleteAllDatas();

                                        final sp = await SharedPreferences
                                            .getInstance();
                                        sp.remove('userid');
                                        setState(() {});
                                        Provider.of<VerifyCredentials>(
                                                context,
                                                listen: false)
                                            .AssociateAuthorization(
                                                widget.username, userId);
                                        Provider.of<VerifyCredentials>(
                                                context,
                                                listen: false)
                                            .hascompleted(widget.username);
                                      },
                                      child: const Icon(MdiIcons.lanDisconnect))
                                  : ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.green),
                                      onPressed: () async {
                                        String? userId =
                                            await FitbitConnector.authorize(
                                                context: context,
                                                clientID: CredentialsFitbitter
                                                    .clientID,
                                                clientSecret:
                                                    CredentialsFitbitter
                                                        .clientSecret,
                                                redirectUri:
                                                    CredentialsFitbitter
                                                        .redirectUri,
                                                callbackUrlScheme: 'example');

                                        _showChoiceDialog(context);
                                        Provider.of<VerifyCredentials>(
                                                context,
                                                listen: false)
                                            .AssociateAuthorization(
                                                widget.username, userId);

                   
                                        List<MyData?> dataavailablelist =
                                            await Provider.of<
                                                        DataBaseRepository>(
                                                    context,
                                                    listen: false)
                                                .findAllData();

                                        if (dataavailablelist.isEmpty) {
                          
                                          List<MyData> datalist =
                                              await computeMonthData(
                                            credentials.Restituteuser(
                                                widget.username)['userID'],
                                            DateTime.parse(
                                                '2022-03-01 00:00:00'),
                                            DateTime.now(),
                                          );
                                          for (int i = 0;
                                              i < datalist.length;
                                              i++) {
                                            MyData mydata = datalist[i];
                                            Provider.of<DataBaseRepository>(
                                                    context,
                                                    listen: false)
                                                .insertMyData(mydata);
                                          }
                                        } else {
                                          final listlastday = await Provider
                                                  .of<DataBaseRepository>(
                                                      context,
                                                      listen: false)
                                              .findLastDay();

                                          Provider.of<DataBaseRepository>(
                                                  context,
                                                  listen: false)
                                              .deleteLastDay();

                                          if (DateTime.now().day ==
                                                  listlastday!.day &&
                                              DateTime.now().month ==
                                                  listlastday.month) {
                                            List<MyData> data =
                                                await computeMonthData(
                                                    userId!,
                                                    DateTime.now(),
                                                    DateTime.now());

                                            Provider.of<DataBaseRepository>(
                                                    context,
                                                    listen: false)
                                                .insertMyData(data[0]);
                                          } else {
                                            DateTime startdate = DateTime.parse(
                                                '2022-${modifyDate(listlastday.month)}-${modifyDate(listlastday.day)}');
                                            DateTime enddate = DateTime.now();
                                            List<MyData> datalist =
                                                await computeMonthData(
                                                    userId!,
                                                    startdate,
                                                    enddate);
                                            for (int i = 0;
                                                i < datalist.length;
                                                i++) {
                                              MyData mydata = datalist[i];
                                              Provider.of<DataBaseRepository>(
                                                      context,
                                                      listen: false)
                                                  .insertMyData(mydata);
                                            }
                                          }
                                        }
                                        final sp = await SharedPreferences
                                            .getInstance();
                                        sp.setString(
                                            'userid',
                                            credentials.Restituteuser(
                                                widget.username)['userID']);

                                        List<CouponEntity?> list =
                                            await Provider.of<
                                                        DataBaseRepository>(
                                                    context,
                                                    listen: false)
                                                .findAllCoupons();
                                        if (list.isEmpty) {
                                         
                                          List<CouponEntity> couponlist =
                                              await computeCoupons(
                                                  context,
                                                  credentials.Restituteuser(
                                                          widget.username)[
                                                      'userID'],
                                                  DateTime.parse(
                                                      '2022-03-06 00:00:00'),
                                                  DateTime.now());
                                          for (int i = 0;
                                              i < couponlist.length;
                                              i++) {
                                            CouponEntity coupon =
                                                couponlist[i];
                                            Provider.of<DataBaseRepository>(
                                                    context,
                                                    listen: false)
                                                .insertCoupon(coupon);
                                          }
                                        } else {
                                          
                                          CouponEntity? lastcoupon =
                                              await Provider.of<
                                                          DataBaseRepository>(
                                                      context,
                                                      listen: false)
                                                  .findLastCoupon();
                                          DateTime startdate = DateTime.parse(
                                              '2022-${modifyDate(lastcoupon!.month)}-${modifyDate(lastcoupon.day)}');
                                          Duration? diff = DateTime.now()
                                              .difference(startdate);
                                          int difference = diff.inDays;
                                          if (difference > 6) {
                                            
                                            Provider.of<DataBaseRepository>(
                                                    context,
                                                    listen: false)
                                                .deleteLastCoupon();
                                            List<CouponEntity> couponlist =
                                                await computeCoupons(
                                                    context,
                                                    credentials.Restituteuser(
                                                            widget.username)[
                                                        'userID'],
                                                    startdate,
                                                    DateTime.now());
                                            for (int i = 0;
                                                i < couponlist.length;
                                                i++) {
                                              CouponEntity coupon =
                                                  couponlist[i];
                                              Provider.of<DataBaseRepository>(
                                                      context,
                                                      listen: false)
                                                  .insertCoupon(coupon);
                                            }
                                          } 
                                        }

                                        Provider.of<VerifyCredentials>(
                                                context,
                                                listen: false)
                                            .hascompleted(widget.username);
                                        Provider.of<DayData>(context,
                                                listen: false)
                                            .changeDay(DateTime.now());
                                        Provider.of<DayData>(context,
                                                listen: false)
                                            .computeDifference();
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop();
                                      },
                                      child: const Icon(MdiIcons.lanConnect))
                            ],
                          ),
                          RichText(
                            text: TextSpan(children: [
                              const TextSpan(
                                  text: "By authorizing fitbit you accept the fitibit ",
                                  style: TextStyle(color: Colors.grey)),
                              TextSpan(
                                text: "terms and conditions.",
                                style: const TextStyle(
                                    color: Colors.blue,
                                  
                                    decoration: TextDecoration.underline),
                                recognizer: TapGestureRecognizer()..onTap = () async {
                                  final Uri _url = Uri.parse('https://www.fitbit.com/global/us/legal/terms-of-service.com');
                                  if (await canLaunchUrl(_url) == true) {
                        launchUrl(_url);
                       } 
                   }
                                
                              )
                            ]),
                          )
                        ],
                      ),
                    )),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(255, 234, 231, 231))),
              onPressed: () async {
                _showDeleteDialogue(context);
              },
              child:  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Delete Account', style: TextStyle(color: Colors.red))
                  ]),
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'By clicking this button you will remove definetely your account along with all the data associated (fitbit and coupons).',
                style: TextStyle(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                    fontSize: 10),
                textAlign: TextAlign.justify,
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(255, 234, 231, 231))),
              onPressed: () {
                Provider.of<DataBaseRepository>(context, listen: false)
                    .deleteAllCoupons();
              },
              child:
                 Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('Remove coupons data', style: TextStyle(color: Colors.red))
              ]),
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'By clicking this button you will remove the coupons data. You can recover them by re-authorizing your account.',
                style: TextStyle(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                    fontSize: 10),
                textAlign: TextAlign.justify,
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(255, 234, 231, 231))),
              onPressed: () {
                Provider.of<DataBaseRepository>(context, listen: false)
                    .deleteAllDatas();
              },
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('Remove fitbit data', style: TextStyle(color: Colors.red))
              ]),
            ),
            const Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'By clicking this button you will remove the fitbit data. You can recover them by re-authorizing your account.',
                style: TextStyle(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                    fontSize: 10),
                textAlign: TextAlign.justify,
              ),
            )
          ]),
        ),
      ),
    );
  }
}
