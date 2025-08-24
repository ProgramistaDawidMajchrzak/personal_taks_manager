import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:personal_task_manager/views/edit_task_view.dart';
import '../database/database.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final ValueChanged<bool?> onToggle;
  final VoidCallback onDelete;
  final bool isFirst;
  final bool isLast;

  const TaskTile({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
    this.isFirst = false,
    this.isLast = false,
  });

  String getCategoryIcon(int category) {
    switch (category) {
      case 1:
        return "assets/images/category1.svg";
      case 2:
        return "assets/images/category2.svg";
      case 3:
        return "assets/images/category3.svg";
      default:
        return "assets/images/cancel.svg";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: isFirst ? const Radius.circular(12) : Radius.zero,
          topRight: isFirst ? const Radius.circular(12) : Radius.zero,
          bottomLeft: isLast ? const Radius.circular(12) : Radius.zero,
          bottomRight: isLast ? const Radius.circular(12) : Radius.zero,
        ),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
        border:
            isLast
                ? null
                : const Border(
                  bottom: BorderSide(color: Color(0xFFF1F5F9), width: 1.5),
                ),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            getCategoryIcon(task.category),
            width: 40,
            height: 40,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => EditTaskView(task: task)),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "${task.deadline.day.toString().padLeft(2, '0')}.${task.deadline.month.toString().padLeft(2, '0')}.${task.deadline.year} ${task.deadline.hour.toString().padLeft(2, '0')}:${task.deadline.minute.toString().padLeft(2, '0')}",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),

          Checkbox(
            value: task.isDone,
            onChanged: onToggle,
            activeColor: const Color(0xFF4A3780),
          ),
        ],
      ),
    );
  }
}
