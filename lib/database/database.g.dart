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
            'CREATE TABLE IF NOT EXISTS `MyData` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `day` INTEGER NOT NULL, `month` INTEGER NOT NULL, `steps` REAL NOT NULL, `distance` REAL NOT NULL, `calories` REAL NOT NULL, `minutesfa` REAL NOT NULL, `minutesva` REAL NOT NULL)');
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
                  'id': item.id,
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
  Future<List<double>?> findDatas(int day, int month) async {
    await _queryAdapter.queryNoReturn(
        'SELECT steps,calories,distance,minutesfa,minutesva FROM MyData WHERE day = ?1 AND month = ?2',
        arguments: [day, month]);
  }

  @override
  Future<void> deleteAllDatas() async {
    await _queryAdapter.queryNoReturn('DELETE * FROM MyData');
  }

  @override
  Future<List<int>> insertMyDatas(List<MyData> mydatas) {
    return _myDataInsertionAdapter.insertListAndReturnIds(
        mydatas, OnConflictStrategy.abort);
  }
}
