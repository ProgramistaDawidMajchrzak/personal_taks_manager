import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:personal_task_manager/services/notification_service.dart';
import 'package:personal_task_manager/widgets/custom_app_bar.dart';
import 'package:personal_task_manager/widgets/custom_button.dart';
import 'package:personal_task_manager/widgets/custom_date_input.dart';
import 'package:personal_task_manager/widgets/custom_form_input.dart';
import 'package:personal_task_manager/widgets/custom_time_input.dart';
import 'package:provider/provider.dart';
import '../viewmodels/task_viewmodel.dart';
import '../database/database.dart';

class EditTaskView extends StatefulWidget {
  final Task task;

  const EditTaskView({super.key, required this.task});

  @override
  State<EditTaskView> createState() => _EditTaskViewState();
}

class _EditTaskViewState extends State<EditTaskView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _noteController;
  late TextEditingController _dateController;
  late TextEditingController _timeController;
  DateTime? _selectedDeadline;
  TimeOfDay? _selectedTime;
  int _selectedCategory = 1;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _noteController = TextEditingController(text: widget.task.note ?? '');
    _selectedDeadline = widget.task.deadline;
    _selectedTime = TimeOfDay(
      hour: _selectedDeadline!.hour,
      minute: _selectedDeadline!.minute,
    );
    _dateController = TextEditingController(
      text:
          "${_selectedDeadline!.day}/${_selectedDeadline!.month}/${_selectedDeadline!.year}",
    );
    _timeController = TextEditingController(
      text:
          "${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}",
    );
    _selectedCategory = (widget.task.category as int?) ?? 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(height: 100, currentIndex: 3),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomButton(
              text: "Dev Notif Test",
              onPressed: () async {
                final notificationService = NotificationService();
                await notificationService.init();
                await notificationService.showNotification(
                  id: widget.task.id ?? 0,
                  title: widget.task.title,
                  body: "30 mins left !",
                );
              },
            ),
            const SizedBox(height: 12),
            CustomButton(
              text: "Delete",
              onPressed: () async {
                final vm = context.read<TaskViewModel>();
                await vm.deleteTask(widget.task.id);
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 12),
            CustomButton(
              text: "Save",
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  if (_selectedDeadline == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please select a date")),
                    );
                    return;
                  }
                  final vm = context.read<TaskViewModel>();
                  await vm.updateTask(
                    id: widget.task.id,
                    title: _titleController.text.trim(),
                    category: _selectedCategory,
                    deadline: _selectedDeadline!,
                    note:
                        _noteController.text.trim().isNotEmpty
                            ? _noteController.text.trim()
                            : null,
                  );
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                  label: "Title",
                  hint: "Task Title",
                  controller: _titleController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Title is required";
                    }
                    if (value.length < 6) {
                      return "Title need to has min 6 char";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text(
                      "Category",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 24),
                    _buildCategoryIcon(1, "assets/images/category1.svg"),
                    const SizedBox(width: 14),
                    _buildCategoryIcon(2, "assets/images/category2.svg"),
                    const SizedBox(width: 14),
                    _buildCategoryIcon(3, "assets/images/category3.svg"),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: DateInputField(
                        label: "Date",
                        controller: _dateController,
                        onDateSelected: (picked) {
                          if (_selectedTime != null) {
                            _selectedDeadline = DateTime(
                              picked.year,
                              picked.month,
                              picked.day,
                              _selectedTime!.hour,
                              _selectedTime!.minute,
                            );
                          } else {
                            _selectedDeadline = DateTime(
                              picked.year,
                              picked.month,
                              picked.day,
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TimeInputField(
                        label: "Time",
                        controller: _timeController,
                        onTimeSelected: (picked) {
                          _selectedTime = picked;
                          if (_selectedDeadline != null) {
                            _selectedDeadline = DateTime(
                              _selectedDeadline!.year,
                              _selectedDeadline!.month,
                              _selectedDeadline!.day,
                              picked.hour,
                              picked.minute,
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: "Notes (optional)",
                  hint: "Notes (optional)",
                  controller: _noteController,
                  maxLines: 4,
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryIcon(int id, String asset) {
    final isSelected = _selectedCategory == id;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = id;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color:
                isSelected ? const Color(0xFF4A3780) : const Color(0xFFE0E0E0),
            width: 2.0,
          ),
        ),
        child: SvgPicture.asset(asset, height: 36, width: 36),
      ),
    );
  }
}
