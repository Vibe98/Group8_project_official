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

}