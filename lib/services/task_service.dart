import 'package:drift/drift.dart';
import 'package:personal_task_manager/database/task_dao.dart';
import '../database/database.dart';
import '../services/notification_service.dart';

class TaskService {
  final TaskDao _taskDao;
  final NotificationService _notificationService;

  TaskService(this._taskDao, this._notificationService);

  Future<int> addTask({
    required String title,
    required int category,
    required DateTime deadline,
    String? note,
  }) async {
    final taskId = await _taskDao.insertTask(
      TasksCompanion.insert(
        title: title,
        category: category,
        deadline: deadline,
        note: Value(note),
      ),
    );

    await _notificationService.scheduleTaskNotification(
      id: taskId,
      title: "Task Reminder",
      body: "You have a task: $title",
      taskDeadline: deadline,
    );

    return taskId;
  }

  Future<void> updateTask(Task task) async {
    await _taskDao.updateTask(task);

    await _notificationService.scheduleTaskNotification(
      id: task.id,
      title: "Task Reminder",
      body: "You have a task: ${task.title}",
      taskDeadline: task.deadline,
    );
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

  Future<void> deleteTask(int id) async {
    await _taskDao.deleteTask(id);
    await _notificationService.cancelNotification(id);
  }
}
