import 'package:floor/floor.dart';

@Entity(primaryKeys: ['day', 'month']) 
class MyData{
  

  final int day;
  final int month;

  final double? steps;
  final double? distance;
  final double? calories;
  final double? minutesfa;
  final double? minutesva;

  MyData(this.day, this.month, this.steps, this.distance, this.calories, this.minutesfa, this.minutesva);

}