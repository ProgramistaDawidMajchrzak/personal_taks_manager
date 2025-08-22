import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import 'package:personal_task_manager/services/weather_service.dart';
import 'services/notification_service.dart';
import 'database/database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final notificationService = NotificationService();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  print("----------------------------------------------");
  final weatherService = WeatherService();
  try {
    Position position = await weatherService.determinePosition();
    print("position ${position.latitude}, ${position.longitude}");

    LocationPermission permission = await Geolocator.checkPermission();
    print('permission: $permission');
    final weather = await weatherService.getWeather(
      position.latitude,
      position.longitude,
    );
    print('Temperatura: ${weather['main']['temp']} °C');
    print('Pogoda: ${weather['weather'][0]['description']}');
    print('Response: $weather');
  } catch (e) {
    print("err: $e");
  }
  print("----------------------------------------------");

  await notificationService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final weatherService = WeatherService();

    return MaterialApp(
      title: 'Personal Task Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        appBar: AppBar(title: Text("Hey")),
        body: Center(
          child: FutureBuilder(
            future: _loadWeather(weatherService),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                return Text("Błąd: ${snapshot.error}");
              }

              final weather = snapshot.data as Map<String, dynamic>;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton(
                    onPressed: () {
                      notificationService.showNotification(
                        id: 1,
                        title: "Dawid Majchrzak",
                        body: "To najlepszy ziomal na świecie",
                      );
                    },
                    child: const Text("Instant Notification"),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Temperatura: ${weather['main']['temp']} °C',
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text(
                    'Pogoda: ${weather['weather'][0]['description']}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_on),
                      Text(
                        '${weather['name']}',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> _loadWeather(WeatherService service) async {
    final position = await service.determinePosition();
    return await service.getWeather(position.latitude, position.longitude);
  }
}
