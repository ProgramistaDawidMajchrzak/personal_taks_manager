import 'package:flutter/foundation.dart';
import '../services/task_service.dart';

class StatsViewModel extends ChangeNotifier {
  final TaskService _taskService;

  StatsViewModel(this._taskService);

  int _completedCount = 0;
  int _totalCount = 0;

  int get completedCount => _completedCount;
  int get totalCount => _totalCount;

  void loadStats() {
    _taskService.watchAllTasksSorted().listen((tasks) {
      _totalCount = tasks.length;
      _completedCount = tasks.where((t) => t.isDone).length;
      notifyListeners();
    });
  }
}
