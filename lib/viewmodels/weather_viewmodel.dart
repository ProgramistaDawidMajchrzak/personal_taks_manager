import 'package:flutter/foundation.dart';
import '../services/weather_service.dart';
import '../models/weather_model.dart';

class WeatherViewModel extends ChangeNotifier {
  final WeatherService _weatherService;

  WeatherViewModel(this._weatherService);

  WeatherData? _weather;
  bool _isLoading = false;
  String? _error;

  WeatherData? get weather => _weather;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadWeather() async {
    _isLoading = true;
    notifyListeners();

    try {
      final position = await _weatherService.determinePosition();
      final json = await _weatherService.getWeather(
        position.latitude,
        position.longitude,
      );
      _weather = WeatherData.fromJson(json);
      _error = null;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
