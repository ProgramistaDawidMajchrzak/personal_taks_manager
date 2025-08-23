import 'package:flutter/material.dart';
import 'package:personal_task_manager/utils/weather_icons.dart';
import 'package:personal_task_manager/viewmodels/weather_viewmodel.dart';
import 'package:personal_task_manager/widgets/app_bar_text.dart';

class WeatherInfo extends StatelessWidget {
  final WeatherViewModel weatherVM;
  const WeatherInfo({super.key, required this.weatherVM});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.location_on, color: Colors.white),
        const SizedBox(width: 4),
        AppBarText(text: weatherVM.weather!.cityName),
        const Spacer(),
        AppBarText(text: "${weatherVM.weather!.temperature}°C  "),
        Icon(
          WeatherIcons.getIcon(weatherVM.weather!.icon),
          color: Colors.white,
        ),
      ],
    );
  }
}
