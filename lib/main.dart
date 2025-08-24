import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:personal_task_manager/services/weather_service.dart';
import 'services/notification_service.dart';
import 'database/database.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'services/task_service.dart';
import 'viewmodels/task_viewmodel.dart';
import 'viewmodels/statistics_viewmodel.dart';
import 'viewmodels/weather_viewmodel.dart';
import './views/home_view.dart';

final notificationService = NotificationService();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  final db = AppDatabase();
  final taskService = TaskService(db.taskDao);

  // taskService.watchAllTasksSorted().listen((tasks) {
  //   print("STREAM TEST: ${tasks.length} tasks");
  //   for (var t in tasks) {
  //     print("${t.id} - ${t.title} - ${t.deadline}");
  //   }
  // });
  final weatherService = WeatherService();

  await notificationService.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskViewModel(taskService)),
        ChangeNotifierProvider(
          create: (_) => WeatherViewModel(weatherService)..loadWeather(),
        ),
        ChangeNotifierProvider(create: (_) => StatsViewModel(taskService)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Task Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFF1F5F9)),
      ),
      home: HomeView(),
    );
  }
}
