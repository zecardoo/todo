import 'package:flutter/material.dart';

class AddNewTask extends StatefulWidget {
  const AddNewTask({super.key});

  @override
  State<AddNewTask> createState() => _AddNewTaskState();
}

class _AddNewTaskState extends State<AddNewTask> {
  final  name = TextEditingController();
  final  description = TextEditingController();
  late DateTime _dueDate;

  @override
  void initState() {
    super.initState();
    _dueDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text(
          'Add New Task',
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
          TextField(
            controller: name,
            decoration: const InputDecoration(label: Text('Task')),
          ),

          const SizedBox(height: 20),

          TextField(
            controller: description,
            decoration: const InputDecoration(label: Text('Description')),
          ),

          const SizedBox(height: 20),

          TextButton(
            onPressed: () async {
              final selectedDate = await showDatePicker(
                context: context,
                initialDate: _dueDate,
                firstDate: DateTime.now(),
                lastDate: DateTime(2100),
              );
              if (selectedDate != null) {
                setState(() {
                  _dueDate = selectedDate;
                });
              }
            },
            child: Text('Due Date: ${_dueDate.year}-${_dueDate.month}-${_dueDate.day}'),
          ),
        ],),
        
        
      );
  }
}