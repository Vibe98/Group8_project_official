import 'package:flutter/foundation.dart';
import 'package:login_flow/database/database.dart';

import '../database/entities/mydata.dart';

class DataBaseRepository extends ChangeNotifier{
  final AppDatabase database;

  DataBaseRepository({required this.database});

  Future<MyData?> findDatas(int day, int month) async{
    final datas = await database.mydatadao.findDatas(day, month);
    return datas;
  }

  Future<List<MyData?>> findMonthDatas(int month) async{
    final monthdatas = await database.mydatadao.findMonthDatas(month);
    return monthdatas;
  }

  Future<void> insertMyData(MyData mydata) async{
  await database.mydatadao.insertMyData(mydata);
    notifyListeners();
  }

  Future<void> deleteAllDatas() async{
    await database.mydatadao.deleteAllDatas();
    notifyListeners();
  }

  Future<List<MyData>> findAllData()async{
    final datas = await database.mydatadao.findAllData();
    return datas;
  }

   Future<List<MyData?>> findWeekData(int daystart, int monthstart) async{
    List<int> daylist = [];
    List<int> monthlist = [];
    int day = daystart;
    int month = monthstart;

    for(int i=0; i<7; i++){
      daylist.add(day);
      monthlist.add(month);
      if(month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12){
        if(day == 31){
          day = 1;
          if (month == 12){
            month = 1;
          } else{
            month = month+1;
          }
        }else{
          day = day+1;
        }
      }else{
        if(month == 4 || month == 5 || month == 9 || month == 11){
          if(day == 30){
            day = 1;
            month = month+1;
          }else{
            day = day+1;
          }
        }else{
          if(day == 28){
            day = 1;
            month = month+1;
          }else{
            day = day+1;
          }
        }
      }

    }
    final datas = await database.mydatadao.findWeekData(daylist[0], daylist[1], daylist[2], daylist[3], daylist[4], daylist[5], daylist[6], monthlist[0], monthlist[1], monthlist[2], monthlist[3], monthlist[4], monthlist[5],  monthlist[6]);

    return datas;
  
  }

}