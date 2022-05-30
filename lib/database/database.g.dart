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
            'CREATE TABLE IF NOT EXISTS `MyData` (`day` INTEGER NOT NULL, `month` INTEGER NOT NULL, `steps` REAL, `distance` REAL, `calories` REAL, `minutesfa` REAL, `minutesva` REAL, PRIMARY KEY (`day`, `month`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `ProfileEntity` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT, `surname` TEXT, `username` TEXT, `password` TEXT, `email` TEXT, `complete` INTEGER NOT NULL, `userID` TEXT NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  MyDataDao get mydatadao {
    return _mydatadaoInstance ??= _$MyDataDao(database, changeListener);
  }
}

class _$MyDataDao extends MyDataDao {
  _$MyDataDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _myDataInsertionAdapter = InsertionAdapter(
            database,
            'MyData',
            (MyData item) => <String, Object?>{
                  'day': item.day,
                  'month': item.month,
                  'steps': item.steps,
                  'distance': item.distance,
                  'calories': item.calories,
                  'minutesfa': item.minutesfa,
                  'minutesva': item.minutesva
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
            row['day'] as int,
            row['month'] as int,
            row['steps'] as double?,
            row['distance'] as double?,
            row['calories'] as double?,
            row['minutesfa'] as double?,
            row['minutesva'] as double?),
        arguments: [day, month]);
  }

  @override
  Future<List<MyData?>> findMonthDatas(int month) async {
    return _queryAdapter.queryList('SELECT * FROM MyData WHERE month = ?1',
        mapper: (Map<String, Object?> row) => MyData(
            row['day'] as int,
            row['month'] as int,
            row['steps'] as double?,
            row['distance'] as double?,
            row['calories'] as double?,
            row['minutesfa'] as double?,
            row['minutesva'] as double?),
        arguments: [month]);
  }

  @override
  Future<void> deleteAllDatas() async {
    await _queryAdapter.queryNoReturn('DELETE FROM MyData');
  }

  @override
  Future<List<MyData>> findAllData() async {
    return _queryAdapter.queryList('SELECT * FROM MyData',
        mapper: (Map<String, Object?> row) => MyData(
            row['day'] as int,
            row['month'] as int,
            row['steps'] as double?,
            row['distance'] as double?,
            row['calories'] as double?,
            row['minutesfa'] as double?,
            row['minutesva'] as double?));
  }

  @override
  Future<void> insertMyData(MyData mydata) async {
    await _myDataInsertionAdapter.insert(mydata, OnConflictStrategy.abort);
  }
}