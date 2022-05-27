import 'package:floor/floor.dart';
import 'package:flutter/material.dart';
import 'package:login_flow/database/entities/mydata.dart';

@dao 
abstract class MyDataDao{

  @Query('SELECT * FROM MyData WHERE day = :day AND month = :month')
  Future<MyData?> findDatas(int day, int month);

  /*@Query('SELECT calories FROM MyData WHERE day = :day AND month = :month')
  Future<int> findCalories(int day, int month);

  @Query('SELECT distance FROM MyData WHERE day = :day AND month = :month')
  Future<int> findDistance(int day, int month);

  @Query('SELECT minutesfa FROM MyData WHERE day = :day AND month = :month')
  Future<int> findMinutesFA(int day, int month);

  @Query('SELECT minutesva FROM MyData WHERE day = :day AND month = :month')
  Future<int> findMinutesVA(int day, int month);*/
  
  @insert //inserting
  Future<void> insertMyData(MyData mydata);

  @Query('DELETE FROM MyData')
  Future<void> deleteAllDatas();

  @Query('SELECT * FROM MyData')
  Future<List<MyData>> findAllData();



}