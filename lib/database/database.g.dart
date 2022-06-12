// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  MyDataDao? _mydatadaoInstance;

  CouponDao? _coupondaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `MyData` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `day` INTEGER NOT NULL, `month` INTEGER NOT NULL, `steps` REAL, `distance` REAL, `calories` REAL, `minutesfa` REAL, `minutesva` REAL, `tomatos` INTEGER)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `CouponEntity` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `day` INTEGER, `month` INTEGER, `present` INTEGER, `used` INTEGER)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  MyDataDao get mydatadao {
    return _mydatadaoInstance ??= _$MyDataDao(database, changeListener);
  }

  @override
  CouponDao get coupondao {
    return _coupondaoInstance ??= _$CouponDao(database, changeListener);
  }
}

class _$MyDataDao extends MyDataDao {
  _$MyDataDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _myDataInsertionAdapter = InsertionAdapter(
            database,
            'MyData',
            (MyData item) => <String, Object?>{
                  'id': item.id,
                  'day': item.day,
                  'month': item.month,
                  'steps': item.steps,
                  'distance': item.distance,
                  'calories': item.calories,
                  'minutesfa': item.minutesfa,
                  'minutesva': item.minutesva,
                  'tomatos':
                      item.tomatos == null ? null : (item.tomatos! ? 1 : 0)
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<MyData> _myDataInsertionAdapter;

  @override
  Future<MyData?> findDatas(int day, int month) async {
    return _queryAdapter.query(
        'SELECT * FROM MyData WHERE day = ?1 AND month = ?2',
        mapper: (Map<String, Object?> row) => MyData(
            row['id'] as int?,
            row['day'] as int,
            row['month'] as int,
            row['steps'] as double?,
            row['distance'] as double?,
            row['calories'] as double?,
            row['minutesfa'] as double?,
            row['minutesva'] as double?,
            row['tomatos'] == null ? null : (row['tomatos'] as int) != 0),
        arguments: [day, month]);
  }

  @override
  Future<List<MyData?>> findMonthDatas(int month) async {
    return _queryAdapter.queryList('SELECT * FROM MyData WHERE month = ?1',
        mapper: (Map<String, Object?> row) => MyData(
            row['id'] as int?,
            row['day'] as int,
            row['month'] as int,
            row['steps'] as double?,
            row['distance'] as double?,
            row['calories'] as double?,
            row['minutesfa'] as double?,
            row['minutesva'] as double?,
            row['tomatos'] == null ? null : (row['tomatos'] as int) != 0),
        arguments: [month]);
  }

  @override
  Future<List<MyData?>> findWeekData(
      int day1,
      int day2,
      int day3,
      int day4,
      int day5,
      int day6,
      int day7,
      int month1,
      int month2,
      int month3,
      int month4,
      int month5,
      int month6,
      int month7) async {
    return _queryAdapter.queryList(
        'SELECT * FROM MyData WHERE (day = ?1 AND month = ?8) OR (day = ?2 AND month = ?9) OR (day = ?3 AND month = ?10) OR (day = ?4 AND month = ?11) OR (day = ?5 AND month = ?12) OR (day = ?6 AND month = ?13) OR (day = ?7 AND month = ?14)',
        mapper: (Map<String, Object?> row) => MyData(
            row['id'] as int?,
            row['day'] as int,
            row['month'] as int,
            row['steps'] as double?,
            row['distance'] as double?,
            row['calories'] as double?,
            row['minutesfa'] as double?,
            row['minutesva'] as double?,
            row['tomatos'] == null ? null : (row['tomatos'] as int) != 0),
        arguments: [
          day1,
          day2,
          day3,
          day4,
          day5,
          day6,
          day7,
          month1,
          month2,
          month3,
          month4,
          month5,
          month6,
          month7
        ]);
  }

  @override
  Future<void> deleteAllDatas() async {
    await _queryAdapter.queryNoReturn('DELETE FROM MyData');
  }

  @override
  Future<List<MyData>> findAllData() async {
    return _queryAdapter.queryList('SELECT * FROM MyData',
        mapper: (Map<String, Object?> row) => MyData(
            row['id'] as int?,
            row['day'] as int,
            row['month'] as int,
            row['steps'] as double?,
            row['distance'] as double?,
            row['calories'] as double?,
            row['minutesfa'] as double?,
            row['minutesva'] as double?,
            row['tomatos'] == null ? null : (row['tomatos'] as int) != 0));
  }

  @override
  Future<MyData?> findLastDay() async {
    return _queryAdapter.query(
        'SELECT * FROM MyData WHERE id=(SELECT MAX(id) FROM MyData)',
        mapper: (Map<String, Object?> row) => MyData(
            row['id'] as int?,
            row['day'] as int,
            row['month'] as int,
            row['steps'] as double?,
            row['distance'] as double?,
            row['calories'] as double?,
            row['minutesfa'] as double?,
            row['minutesva'] as double?,
            row['tomatos'] == null ? null : (row['tomatos'] as int) != 0));
  }

  @override
  Future<void> deleteLastDay() async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM MyData WHERE id=(SELECT MAX(id) FROM MyData)');
  }

  @override
  Future<void> insertMyData(MyData mydata) async {
    await _myDataInsertionAdapter.insert(mydata, OnConflictStrategy.abort);
  }
}

class _$CouponDao extends CouponDao {
  _$CouponDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _couponEntityInsertionAdapter = InsertionAdapter(
            database,
            'CouponEntity',
            (CouponEntity item) => <String, Object?>{
                  'id': item.id,
                  'day': item.day,
                  'month': item.month,
                  'present':
                      item.present == null ? null : (item.present! ? 1 : 0),
                  'used': item.used == null ? null : (item.used! ? 1 : 0)
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<CouponEntity> _couponEntityInsertionAdapter;

  @override
  Future<CouponEntity?> findCoupon(int day, int month) async {
    return _queryAdapter.query(
        'SELECT * FROM CouponEntity WHERE day = ?1 AND month = ?2',
        mapper: (Map<String, Object?> row) => CouponEntity(
            row['id'] as int?,
            row['day'] as int?,
            row['month'] as int?,
            row['present'] == null ? null : (row['present'] as int) != 0,
            row['used'] == null ? null : (row['used'] as int) != 0),
        arguments: [day, month]);
  }

  @override
  Future<List<CouponEntity>> findPresendAndUsedCoupons(
      bool present, bool used) async {
    return _queryAdapter.queryList(
        'SELECT * FROM CouponEntity WHERE present = ?1 AND used = ?2',
        mapper: (Map<String, Object?> row) => CouponEntity(
            row['id'] as int?,
            row['day'] as int?,
            row['month'] as int?,
            row['present'] == null ? null : (row['present'] as int) != 0,
            row['used'] == null ? null : (row['used'] as int) != 0),
        arguments: [present ? 1 : 0, used ? 1 : 0]);
  }

  @override
  Future<List<CouponEntity>> findAllCoupons() async {
    return _queryAdapter.queryList('SELECT * FROM CouponEntity',
        mapper: (Map<String, Object?> row) => CouponEntity(
            row['id'] as int?,
            row['day'] as int?,
            row['month'] as int?,
            row['present'] == null ? null : (row['present'] as int) != 0,
            row['used'] == null ? null : (row['used'] as int) != 0));
  }

  @override
  Future<CouponEntity?> findLastCoupon() async {
    return _queryAdapter.query(
        'SELECT * FROM CouponEntity WHERE id=(SELECT MAX(id) FROM CouponEntity)',
        mapper: (Map<String, Object?> row) => CouponEntity(
            row['id'] as int?,
            row['day'] as int?,
            row['month'] as int?,
            row['present'] == null ? null : (row['present'] as int) != 0,
            row['used'] == null ? null : (row['used'] as int) != 0));
  }

  @override
  Future<void> updatePresent(bool present, int day, int month) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE CouponEntity SET present = ?1 WHERE day = ?2 AND month = ?3',
        arguments: [present ? 1 : 0, day, month]);
  }

  @override
  Future<void> updateUsed(bool used, int day, int month) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE CouponEntity SET used = ?1 WHERE day = ?2 AND month = ?3',
        arguments: [used ? 1 : 0, day, month]);
  }

  @override
  Future<void> deleteAllCoupons() async {
    await _queryAdapter.queryNoReturn('DELETE FROM CouponEntity');
  }

  @override
  Future<void> deleteLastCoupon() async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM CouponEntity WHERE id=(SELECT MAX(id) FROM CouponEntity)');
  }

  @override
  Future<void> insertCoupon(CouponEntity coupon) async {
    await _couponEntityInsertionAdapter.insert(
        coupon, OnConflictStrategy.abort);
  }
}
