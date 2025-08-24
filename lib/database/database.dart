import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:personal_task_manager/database/task_dao.dart';

part 'database.g.dart';

class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 6, max: 32)();
  IntColumn get category => integer()();
  DateTimeColumn get deadline => dateTime()();
  TextColumn get note => text().nullable()();
  BoolColumn get isDone => boolean().withDefault(Constant(false))();
}

@DriftDatabase(tables: [Tasks], daos: [TaskDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();

      await into(tasks).insert(
        TasksCompanion.insert(
          title: 'Go shopping',
          category: 1,
          deadline: DateTime.now().subtract(const Duration(days: 6)),
        ),
      );

      await into(tasks).insert(
        TasksCompanion.insert(
          title: 'Church',
          category: 3,
          deadline: DateTime.now().subtract(const Duration(days: 10)),
          isDone: Value(true),
        ),
      );

      await into(tasks).insert(
        TasksCompanion.insert(
          title: 'Do gym',
          category: 2,
          deadline: DateTime.now().subtract(const Duration(days: 9)),
        ),
      );

      await into(tasks).insert(
        TasksCompanion.insert(
          title: 'Work on school project',
          category: 1,
          deadline: DateTime.now().subtract(const Duration(days: 4)),
          isDone: Value(true),
        ),
      );

      await into(tasks).insert(
        TasksCompanion.insert(
          title: 'Date with girlfriend',
          category: 1,
          deadline: DateTime.now().subtract(const Duration(days: 3)),
          isDone: Value(true),
        ),
      );
      await into(tasks).insert(
        TasksCompanion.insert(
          title: 'Hire David :)',
          category: 3,
          deadline: DateTime.now().subtract(const Duration(days: 1)),
        ),
      );
      await into(tasks).insert(
        TasksCompanion.insert(
          title: 'Clean my desk',
          category: 2,
          deadline: DateTime.now().subtract(const Duration(days: 8)),
        ),
      );
    },
  );

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'tasks_database',
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
    );
  }
}
