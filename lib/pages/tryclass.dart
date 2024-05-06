// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class Task {
  final String name;
  final String description;
  final DateTime dueDate;
  final bool isCompleted;

  Task({
    required this.name,
    required this.description,
    required this.dueDate,
    this.isCompleted = false,
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ToDoList(),
    );
  }
}

class ToDoList extends StatefulWidget {
  const ToDoList({super.key});

  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  final List<Task> _tasks = [];

  void _addTask(Task task) {
    setState(() {
      _tasks.add(task);
    });
  }

  void _removeTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
      ),
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final task = _tasks[index];
          return ListTile(
            title: Text(task.name),
            subtitle: Text(task.description),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                _removeTask(index);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTask = await showDialog<Task>(
            context: context,
            builder: (BuildContext context) {
              return const AddTaskDialog();
            },
          );
          if (newTask != null) {
            _addTask(newTask);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddTaskDialog extends StatefulWidget {
  const AddTaskDialog({super.key});

  @override
  _AddTaskDialogState createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  late DateTime _dueDate;

  @override
  void initState() {
    super.initState();
    _dueDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Task'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Task Name'),
          ),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: 'Description'),
          ),
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
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final newTask = Task(
              name: _nameController.text,
              description: _descriptionController.text,
              dueDate: _dueDate,
            );
            Navigator.pop(context, newTask);
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
