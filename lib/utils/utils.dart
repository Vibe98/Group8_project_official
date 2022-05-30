import 'package:fitbitter/fitbitter.dart';
import 'package:login_flow/repository/databaserepository.dart';
import 'package:provider/provider.dart';

import '../classes/credentialsFitbitter.dart';
import '../database/entities/mydata.dart';

Future<List<MyData>> computeMonthData( String userID, DateTime startdate, DateTime enddate) async {
   
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
      MyData mydata = MyData(null, steps[i].dateOfMonitoring!.day, steps[i].dateOfMonitoring!.month, steps[i].value, distances[i].value, calories[i].value, minutesFA[i].value, minutesVA[i].value);
      mydatalist.add(mydata);


    }

    return mydatalist;
      
   
    
  }