import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import '../database/database.dart';
import '../services/task_service.dart';

class TaskViewModel extends ChangeNotifier {
  final TaskService _taskService;

  TaskViewModel(this._taskService) {
    _observeTasks();
  }

  List<Task> _tasks = [];
  bool _isLoading = false;
  String? _error;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void _observeTasks() {
    _isLoading = true;
    notifyListeners();

    _taskService.watchAllTasksSorted().listen(
      (tasks) {
        _tasks = tasks;
        _isLoading = false;
        _error = null;
        notifyListeners();
      },
      onError: (e) {
        _error = e.toString();
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<void> updateTask({
    required int id,
    required String title,
    required int category,
    required DateTime deadline,
    String? note,
  }) async {
    final task = tasks
        .firstWhere((t) => t.id == id)
        .copyWith(
          title: title,
          category: category,
          deadline: deadline,
          note: Value(note),
        );
    await _taskService.updateTask(task);
  }

  Future<void> addTask({
    required String title,
    required int category,
    required DateTime deadline,
    String? note,
  }) async {
    await _taskService.addTask(
      title: title,
      category: category,
      deadline: deadline,
      note: note,
    );
  }

  Future<void> toggleTask(Task task) async {
    await _taskService.toggleDone(task);
  }

  Future<void> deleteTask(int id) async {
    await _taskService.deleteTask(id);
  }
}
