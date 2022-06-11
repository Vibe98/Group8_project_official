import 'package:fitbitter/fitbitter.dart';
import 'package:login_flow/repository/databaserepository.dart';
import 'package:provider/provider.dart';

import '../classes/credentialsFitbitter.dart';
import '../database/entities/couponentity.dart';
import '../database/entities/mydata.dart';

Future<List<MyData>> computeMonthData(String userID, DateTime startdate, DateTime enddate) async {
   
   List<MyData> mydatalist = [];
    //steps
    FitbitActivityTimeseriesDataManager
        fitbitStepsDataManager =
        FitbitActivityTimeseriesDataManager(
      clientID: CredentialsFitbitter.clientID,
      clientSecret: CredentialsFitbitter.clientSecret,
      type: "steps",
    );

    // prendo i dati dal 1 Marzo
    
    FitbitActivityTimeseriesAPIURL fitbitStepsApiUrl =
    FitbitActivityTimeseriesAPIURL.dateRangeWithResource(
    startDate: startdate,
    endDate: enddate,
    userID: userID,
    resource: "steps"
    );
    final steps =
      await fitbitStepsDataManager.fetch(fitbitStepsApiUrl)
        as List<FitbitActivityTimeseriesData>;
  
  FitbitActivityTimeseriesDataManager
        fitbitCaloriesDataManager =
        FitbitActivityTimeseriesDataManager(
      clientID: CredentialsFitbitter.clientID,
      clientSecret: CredentialsFitbitter.clientSecret,
      type: "calories",
    );

  FitbitActivityTimeseriesAPIURL fitbitCaloriesApiUrl =
  FitbitActivityTimeseriesAPIURL.dateRangeWithResource(
    startDate: startdate,
    endDate: enddate,
    userID: userID,
    resource: "calories"
    );
    final calories =
      await fitbitCaloriesDataManager.fetch(fitbitCaloriesApiUrl)
        as List<FitbitActivityTimeseriesData>;
  
  FitbitActivityTimeseriesDataManager
        fitbitDistanceDataManager =
        FitbitActivityTimeseriesDataManager(
      clientID: CredentialsFitbitter.clientID,
      clientSecret: CredentialsFitbitter.clientSecret,
      type: "distance",
    );

  FitbitActivityTimeseriesAPIURL fitbitDistanceApiUrl =
  FitbitActivityTimeseriesAPIURL.dateRangeWithResource(
    startDate: startdate,
    endDate: enddate,
    userID: userID,
    resource: "distance"
    );
    final distances =
      await fitbitDistanceDataManager.fetch(fitbitDistanceApiUrl)
        as List<FitbitActivityTimeseriesData>;

  FitbitActivityTimeseriesDataManager
        fitbitMinutesFADataManager =
        FitbitActivityTimeseriesDataManager(
      clientID: CredentialsFitbitter.clientID,
      clientSecret: CredentialsFitbitter.clientSecret,
      type: "minutesFairlyActive",
    );

  FitbitActivityTimeseriesAPIURL fitbitMinutesFAApiUrl =
  FitbitActivityTimeseriesAPIURL.dateRangeWithResource(
    startDate: startdate,
    endDate: enddate,
    userID: userID,
    resource: "minutesFairlyActive"
    );
    final minutesFA =
      await fitbitMinutesFADataManager.fetch(fitbitMinutesFAApiUrl)
        as List<FitbitActivityTimeseriesData>;

  FitbitActivityTimeseriesDataManager
        fitbitMinutesVADataManager =
        FitbitActivityTimeseriesDataManager(
      clientID: CredentialsFitbitter.clientID,
      clientSecret: CredentialsFitbitter.clientSecret,
      type: "minutesVeryActive",
    );

  FitbitActivityTimeseriesAPIURL fitbitMinutesVAApiUrl =
  FitbitActivityTimeseriesAPIURL.dateRangeWithResource(
    startDate: startdate,
    endDate: enddate,
    userID: userID,
    resource: "minutesVeryActive"
    );
    final minutesVA =
      await fitbitMinutesVADataManager.fetch(fitbitMinutesVAApiUrl)
        as List<FitbitActivityTimeseriesData>;

    print(steps.length);
    for(int i=0; i<steps.length; i++) {
      print('hey');
      print(steps[i].dateOfMonitoring);
      bool tomato = false;
      if (steps[i].value! >= 7000 && calories[i].value! >= 2800 && (minutesVA[i].value! + minutesFA[i].value!) >= 30){
        tomato = true;
      } 
      MyData mydata = MyData(null, steps[i].dateOfMonitoring!.day, steps[i].dateOfMonitoring!.month, steps[i].value, distances[i].value, calories[i].value, minutesFA[i].value, minutesVA[i].value, tomato);
      mydatalist.add(mydata);


    }

    return mydatalist;
      
   
    
  }




Future<List<CouponEntity>> computeCoupons(context, String userID, DateTime startdate, DateTime enddate)  async{
  // gli do gia in ingresso due datetime
  List<CouponEntity> couponlist = [];
  Duration? diff = enddate.difference(startdate);
  int difference = diff.inDays; // differenza tra oggi e per esempio 4 aprile

  int weeks = (difference/7).floor();
  
  
  for(var i=0; i<weeks; i++) {
    int count = 0;
    bool present = false;
    DateTime firstday = startdate.add(Duration(days: 7*i));

    for(var j=0; j<7; j++){
      DateTime date = firstday.add(Duration(days: j));
      int day = date.day;
      int month = date.month;

      MyData? dataoftheday = await Provider.of<DataBaseRepository>(context,listen: false).findDatas(day, month);
      if(dataoftheday!.tomatos == true){
        count = count +1;
        
      }         

    }
    if(count > 5){
      present= true;
    }
    CouponEntity coupon = CouponEntity(null, firstday.day, firstday.month, present, false);
    //Provider.of<DataBaseRepository>(context, listen:false).insertCoupon(coupon);
    couponlist.add(coupon);

  }

  DateTime lastday = startdate.add(Duration(days: 7*weeks));
  CouponEntity coupon = CouponEntity(null, lastday.day, lastday.month, false, false);
  //  Provider.of<DataBaseRepository>(context, listen:false).insertCoupon(coupon); 
  couponlist.add(coupon);

  return couponlist; 
                                                   
                                                  

}


  String modifyDate(int? date){
    //modifica mese o giorno aggiungendo 0 se inizia con un numero minore di 10
    String newDate='';
    if(date!<10){
      newDate = '0$date';
    }else{
      newDate = '$date';
    }

    return newDate;
  }