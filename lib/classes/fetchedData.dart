import 'myMonthData.dart';

class FetchedData{

  static bool complete=false;
  static Map<String, List<myMonthData>> stepsData = {}; 
  static Map<String, List<myMonthData>> caloriesData = {};
  static Map<String, List<myMonthData>> minutesFairlyActiveData = {};
  static Map<String, List<myMonthData>> minutesVeryActiveData = {};
  static Map<String, List<myMonthData>> sleepData = {};
}