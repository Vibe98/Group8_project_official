import 'package:floor/floor.dart';
import 'package:flutter/material.dart';
import 'package:login_flow/database/entities/mydata.dart';

@dao 
abstract class MyDataDao{

  @Query('SELECT * FROM MyData WHERE day = :day AND month = :month')
  Future<MyData?> findDatas(int day, int month);

  // query fo selecting data of a month
  @Query('SELECT * FROM MyData WHERE month = :month')
  Future<List<MyData?>> findMonthDatas(int month);
  
  @Query('SELECT * FROM MyData WHERE (day = :day1 AND month = :month1) OR (day = :day2 AND month = :month2) OR (day = :day3 AND month = :month3) OR (day = :day4 AND month = :month4) OR (day = :day5 AND month = :month5) OR (day = :day6 AND month = :month6) OR (day = :day7 AND month = :month7)')
  Future<List<MyData?>> findWeekData(int day1, int day2, int day3, int day4, int day5, int day6, int day7,
                                  int month1, int month2, int month3, int month4, int month5, int month6, int month7);

  @insert //inserting
  Future<void> insertMyData(MyData mydata);

  @Query('DELETE FROM MyData')
  Future<void> deleteAllDatas();

  @Query('SELECT * FROM MyData')
  Future<List<MyData>> findAllData();

  @Query('SELECT day,month FROM MyData WHERE day=(SELECT MAX(day) FROM MyData WHERE month=(SELECT MAX(month) FROM MyData))')
  Future<MyData?> findLastDay();

   @Query('DELETE * FROM MyData WHERE day=(SELECT MAX(day) FROM MyData WHERE month=(SELECT MAX(month) FROM MyData))')
  Future<void> deleteLastDay();


}