import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'daos/mydatadao.dart';
import 'daos/coupondao.dart';
import 'entities/mydata.dart';
import 'entities/couponentity.dart';

part 'database.g.dart';

@Database(version:1, entities: [MyData, CouponEntity])
abstract class AppDatabase extends FloorDatabase{
  MyDataDao get mydatadao;
  CouponDao get coupondao;

}


