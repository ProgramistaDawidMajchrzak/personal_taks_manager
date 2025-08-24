import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:personal_task_manager/widgets/custom_app_bar.dart';
import 'package:personal_task_manager/widgets/custom_bottom_nav_bar.dart';
import 'package:personal_task_manager/widgets/custom_button.dart';
import 'package:provider/provider.dart';
import '../viewmodels/statistics_viewmodel.dart';

class StatsView extends StatefulWidget {
  const StatsView({super.key});

  @override
  State<StatsView> createState() => _StatsViewState();
}

class _StatsViewState extends State<StatsView> {
  bool _currentWeek = true;

  @override
  Widget build(BuildContext context) {
    final statsVM = context.watch<StatsViewModel>();

    final data =
        _currentWeek ? statsVM.currentWeekTasks : statsVM.previousWeekTasks;

    final completed = data.where((t) => t.isDone).length;
    final pending = data.length - completed;

    return Scaffold(
      appBar: CustomAppBar(height: 100, currentIndex: 1),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 1),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 200,
                  child:
                      statsVM.allTasks.isEmpty
                          ? const Center(child: CircularProgressIndicator())
                          : data.isEmpty
                          ? const Center(child: Text("No task this week"))
                          : PieChart(
                            PieChartData(
                              sections: [
                                if (completed > 0)
                                  PieChartSectionData(
                                    value: completed.toDouble(),
                                    color: const Color(0xFF4A3780),
                                    title: '$completed DONE',
                                    radius: 60,
                                    titleStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                if (pending > 0)
                                  PieChartSectionData(
                                    value: pending.toDouble(),
                                    color: const Color.fromARGB(
                                      255,
                                      177,
                                      12,
                                      0,
                                    ),
                                    title: '$pending TO DO',
                                    radius: 60,
                                    titleStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                              ],
                              sectionsSpace: 0,
                              centerSpaceRadius: 40,
                            ),
                          ),
                ),
              ],
            ),
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: "Actual week",
                      onPressed: () => setState(() => _currentWeek = true),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomButton(
                      text: "Last week",
                      onPressed: () => setState(() => _currentWeek = false),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
