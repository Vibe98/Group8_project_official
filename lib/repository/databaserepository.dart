import 'package:flutter/foundation.dart';
import 'package:login_flow/database/database.dart';

import '../database/entities/couponentity.dart';
import '../database/entities/mydata.dart';
import '../database/daos/coupondao.dart';

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
    if(datas.length<7){
   
    for(int i = datas.length; i<7; i++){
    datas.add(MyData(null,daylist[i], monthlist[i], 0, 0, 0, 0, 0, false));
   
    }
    }
    return datas;
  
  }

  Future<MyData?> findLastDay() async{
  final result = await database.mydatadao.findLastDay();
  print(result);
  return result;
  }

  Future<void> deleteLastDay()async{
    await database.mydatadao.deleteLastDay();
    notifyListeners();
  }


  // Coupon Entity
  
   Future<void> insertCoupon(CouponEntity coupon) async{
  await database.coupondao.insertCoupon(coupon);
    notifyListeners();
  }

  
  Future<CouponEntity?> findCoupons(int day, int month) async{
    final coupon = await database.coupondao.findCoupon(day, month);
    return coupon;
  }
  
  Future<List<CouponEntity>> findAllCoupons()async{
    final coupons = await database.coupondao.findAllCoupons();
    return coupons;
  }

   Future<CouponEntity?> findLastCoupon() async{
  final result = await database.coupondao.findLastCoupon();
  //print(result);
  return result;
  }

  Future<List<CouponEntity>> findPresendAndUsedCoupons(bool present, bool used)async{
    final result = await database.coupondao.findPresendAndUsedCoupons(present, used);
    return result;
  }

  Future<void> updatePresent(bool present, int day, int month) async{
    await database.coupondao.updatePresent(present, day, month);
    notifyListeners();
  } // forse da eliminare

   Future<void> updateUsed(bool used, int? day, int? month) async{
    await database.coupondao.updateUsed(used, day!, month!);
    notifyListeners();
  }

  Future<void> deleteAllCoupons() async{
    await database.coupondao.deleteAllCoupons();
    notifyListeners();
  }

  Future<void> deleteLastCoupon()async{
    await database.coupondao.deleteLastCoupon();
    notifyListeners();
  }


 



}