import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:personal_task_manager/widgets/app_bar_text.dart';
import 'package:personal_task_manager/widgets/weather_appbar_view.dart';
import 'package:provider/provider.dart';
import '../viewmodels/weather_viewmodel.dart';
import 'package:intl/intl.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final int currentIndex;

  const CustomAppBar({
    super.key,
    this.height = kToolbarHeight + 140,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: height,
          decoration: const BoxDecoration(color: Color(0xFF4A3780)),
        ),
        Positioned(
          top: height == 240 ? 110 : -30,
          left: -180,
          child: SvgPicture.asset(
            "assets/images/ellipse-left.svg",
            width: 342,
            fit: BoxFit.contain,
          ),
        ),
        Positioned(
          top: -20,
          right: -80,
          child: SvgPicture.asset(
            "assets/images/ellipse-right.svg",
            width: 145,
            fit: BoxFit.contain,
          ),
        ),
        AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Builder(
            builder: (context) {
              switch (currentIndex) {
                case 0:
                  final weatherVM = context.watch<WeatherViewModel>();
                  if (weatherVM.isLoading) {
                    return const CircularProgressIndicator(color: Colors.white);
                  }
                  if ((weatherVM.error != null) ||
                      (weatherVM.weather == null)) {
                    final now = DateTime.now();
                    final formattedDate = DateFormat('MMMM d, y').format(now);
                    return AppBarText(text: formattedDate);
                  }
                  return WeatherInfo(weatherVM: weatherVM);
                case 1:
                  return Center(child: AppBarText(text: "Statistics"));
                case 2:
                  return Center(child: AppBarText(text: "Add new Task"));
                default:
                  return const SizedBox.shrink();
              }
            },
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
