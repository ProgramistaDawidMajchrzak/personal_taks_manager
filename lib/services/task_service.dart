import 'package:drift/drift.dart';
import 'package:personal_task_manager/database/task_dao.dart';
import '../database/database.dart';

class TaskService {
  final TaskDao _taskDao;

  TaskService(this._taskDao);

  Future<int> addTask({
    required String title,
    required int category,
    required DateTime deadline,
    String? note,
  }) {
    return _taskDao.insertTask(
      TasksCompanion.insert(
        title: title,
        category: category,
        deadline: deadline,
        note: Value(note),
      ),
    );
  }

  Future<void> updateTask(Task task) async {
    await _taskDao.updateTask(task);
  }

  Stream<List<Task>> watchAllTasksSorted() {
    return _taskDao.watchAllTasks().map((tasks) {
      final sorted = List<Task>.from(tasks);
      sorted.sort((a, b) => a.deadline.compareTo(b.deadline));
      return sorted;
    });
  }

  Future<void> toggleDone(Task task) {
    return _taskDao.updateTask(task.copyWith(isDone: !task.isDone));
  }

  Future<void> deleteTask(int id) => _taskDao.deleteTask(id);
}
