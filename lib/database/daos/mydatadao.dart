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
  
  @insert //inserting
  Future<void> insertMyData(MyData mydata);

  @Query('DELETE FROM MyData')
  Future<void> deleteAllDatas();

  @Query('SELECT * FROM MyData')
  Future<List<MyData>> findAllData();



}