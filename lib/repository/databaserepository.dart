import 'package:flutter/foundation.dart';
import 'package:login_flow/database/database.dart';

import '../database/entities/mydata.dart';

class DataBaseRepository extends ChangeNotifier{
  final AppDatabase database;

  DataBaseRepository({required this.database});

  Future<List<double>?> findDatas(int day, int month) async{
    final datas = await database.mydatadao.findDatas(day, month);
    return datas;
  }

  Future<List<int>> insertMyData(List<MyData> mydatas) async{
    final ids = await database.mydatadao.insertMyDatas(mydatas);
    notifyListeners();
    return ids;
  }

  Future<void> deleteAllDatas() async{
    await database.mydatadao.deleteAllDatas();
    notifyListeners();
  }

}