import 'package:drift/drift.dart';
import 'database.dart';

part 'task_dao.g.dart';

@DriftAccessor(tables: [Tasks])
class TaskDao extends DatabaseAccessor<AppDatabase> with _$TaskDaoMixin {
  final AppDatabase db;

  TaskDao(this.db) : super(db);
  //add
  Future<int> insertTask(TasksCompanion task) => into(tasks).insert(task);
  //get
  Future<List<Task>> getAllTasks() => select(tasks).get();
  Stream<List<Task>> watchAllTasks() => select(tasks).watch();
  //update
  Future<bool> updateTask(Task task) => update(tasks).replace(task);
  //del
  Future<int> deleteTask(int id) =>
      (delete(tasks)..where((t) => t.id.equals(id))).go();
}
