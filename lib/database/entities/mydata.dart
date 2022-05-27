import 'package:floor/floor.dart';

@entity 
class MyData{
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final int day;
  final int month;

  final double steps;
  final double distance;
  final double calories;
  final double minutesfa;
  final double minutesva;

  MyData(this.id, this.day, this.month, this.steps, this.distance, this.calories, this.minutesfa, this.minutesva);

}