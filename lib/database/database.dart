import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'daos/mydatadao.dart';
import 'entities/mydata.dart';
import 'entities/profileentity.dart';

part 'database.g.dart';

@Database(version:1, entities: [MyData, ProfileEntity])
abstract class AppDatabase extends FloorDatabase{
  MyDataDao get mydatadao;

}


