import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:personal_task_manager/utils/weather_icons.dart';
import 'package:personal_task_manager/viewmodels/weather_viewmodel.dart';
import 'package:personal_task_manager/views/add_task_view.dart';
import 'package:personal_task_manager/widgets/app_bar_text.dart';
import 'package:personal_task_manager/widgets/custom_bottom_nav_bar.dart';
import 'package:personal_task_manager/widgets/custom_button.dart';
import 'package:personal_task_manager/widgets/task_tile.dart';
import 'package:provider/provider.dart';
import '../viewmodels/task_viewmodel.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final taskVM = context.watch<TaskViewModel>();

    final pendingTasks = taskVM.tasks.where((t) => !t.isDone).toList();
    final completedTasks = taskVM.tasks.where((t) => t.isDone).toList();

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: const Color(0xFF4A3780),
                expandedHeight: 180,
                collapsedHeight: 90,
                pinned: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(24),
                  ),
                ),
                flexibleSpace: LayoutBuilder(
                  builder: (context, constraints) {
                    final appBarHeight = constraints.biggest.height;
                    final t =
                        (appBarHeight - kToolbarHeight) /
                        (180 - kToolbarHeight);

                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        Positioned(
                          top: 110,
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

                        // zawartość
                        SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Builder(
                                  builder: (context) {
                                    final weatherVM =
                                        context.watch<WeatherViewModel>();
                                    if (weatherVM.weather == null) {
                                      return const SizedBox();
                                    }
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 12.0),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.location_on,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(width: 4),
                                          AppBarText(
                                            text: weatherVM.weather!.cityName,
                                          ),
                                          const Spacer(),
                                          AppBarText(
                                            text:
                                                "${weatherVM.weather!.temperature}°C ",
                                          ),
                                          Icon(
                                            WeatherIcons.getIcon(
                                              weatherVM.weather!.icon,
                                            ),
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),

                                const Spacer(),
                                Opacity(
                                  opacity: t.clamp(0.0, 1.0),
                                  child: const Center(
                                    child: Text(
                                      "My Todo List",
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),

                                const Spacer(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              // Reszta sliverów (tasks)
              SliverToBoxAdapter(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    child: Column(
                      children: List.generate(pendingTasks.length, (index) {
                        final task = pendingTasks[index];
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: TaskTile(
                            key: ValueKey(task.id),
                            task: task,
                            onToggle: (_) => taskVM.toggleTask(task),
                            onDelete: () => taskVM.deleteTask(task.id),
                            isFirst: index == 0,
                            isLast: index == pendingTasks.length - 1,
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),

              if (completedTasks.isNotEmpty)
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: const Text(
                      "Completed",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),

              if (completedTasks.isNotEmpty)
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final task = completedTasks[index];
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: TaskTile(
                          key: ValueKey(task.id),
                          task: task,
                          onToggle: (_) => taskVM.toggleTask(task),
                          onDelete: () => taskVM.deleteTask(task.id),
                          isFirst: index == 0,
                          isLast: index == completedTasks.length - 1,
                        ),
                      );
                    }, childCount: completedTasks.length),
                  ),
                ),

              const SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          ),

          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: CustomButton(
              text: "Add New Task",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddTaskView()),
                );
              },
            ),
          ),
        ],
      ),

      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 0),
    );
  }
}
