import 'package:flutter/material.dart';

class WeatherIcons {
  static IconData getIcon(String code) {
    switch (code) {
      case "01d":
        return Icons.wb_sunny;
      case "01n":
        return Icons.nights_stay;

      case "02d":
      case "03d":
      case "04d":
        return Icons.cloud;
      case "02n":
      case "03n":
      case "04n":
        return Icons.cloud;

      case "09d":
      case "09n":
        return Icons.grain;
      case "10d":
      case "10n":
        return Icons.umbrella;

      case "11d":
      case "11n":
        return Icons.flash_on;

      case "13d":
      case "13n":
        return Icons.ac_unit;

      case "50d":
      case "50n":
        return Icons.blur_on;

      default:
        return Icons.help_outline;
    }
  }
}
