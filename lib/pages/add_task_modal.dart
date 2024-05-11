import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class AddNewTask extends StatefulWidget {
  const AddNewTask({super.key});

  @override
  State<AddNewTask> createState() => _AddNewTaskState();
}

class _AddNewTaskState extends State<AddNewTask> {

  // used instead of print
  final Logger logger = Logger();
  final user = FirebaseAuth.instance.currentUser!;
  final taskController = TextEditingController();
  final descriptionController = TextEditingController();
  late DateTime _dueDate;

  void addTask(String task, String description, DateTime date, bool isCompleted) {
    // Get a reference to the Firestore database
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
        // Get a reference to the "databes name" collection

    final CollectionReference todo = firestore.collection('Todo');

     // Add a new document with a generated ID
    todo.add({
      'task': task,
      'description': description,
      'date': date,
      'iscompleted': isCompleted,
      'userID': user.uid
    }).then((DocumentReference document) {
      //Here, i stands for the info level,
      logger.i('Document added with ID: ${document.id}');
    }).catchError((error) {
      //Here, i stands for the info level,
      logger.i('Error adding document: $error');
    });
  }

  @override
  void initState() {
    super.initState();
    _dueDate = DateTime.now();
  }

    @override
    void dispose() {
    // Dispose controllers to avoid memory leaks
    taskController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      buttonPadding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),


      title: const Text(
        'Add New Task',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),

      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTextField('Task', taskController),
          const SizedBox(height: 30),
          _buildTextField('Description', descriptionController),
          const SizedBox(height: 30),
          _buildDueDateButton(),
          const SizedBox(height: 30),
        ],
      ),
      actions: [
        _buildCancelButton(),
        _buildEditButton(),
      
      ],
    );
  }
  
  Widget _buildTextField(String labelText, TextEditingController controller) {
    return TextField(
      controller: controller,
      style: TextStyle(
        color: Colors.grey[600],
        fontSize: 20,
      ),
      decoration: InputDecoration(
        labelText: labelText,
      ),
    );
  }

  Widget _buildDueDateButton() {
    return TextButton(
      onPressed: _selectDate,
      child: Text(
        'Due Date: ${_dueDate.year}/${_dueDate.month}/${_dueDate.day}',
        style: const TextStyle(color: Colors.black),
      ),
    );
  }

  Future<void> _selectDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (selectedDate != null) {
      setState(() {
        _dueDate = selectedDate;
      });
    }
  }
   Widget _buildCancelButton() {
    return ElevatedButton(
      onPressed: () => Navigator.pop(context),
      child: const Text(
        'Cancel',
        style: TextStyle(color: Colors.red, fontSize: 15),
      ),
    );
  }

  Widget _buildEditButton() {
    return ElevatedButton(
      onPressed: _addTask,
      child: Text(
        'Edit Task',
        style: TextStyle(color: Colors.blueGrey[800], fontSize: 15),
      ),
    );
  }

  void _addTask() {
    if (taskController.text.isNotEmpty && descriptionController.text.isNotEmpty) {
        addTask(taskController.text, descriptionController.text, _dueDate, false);
      Navigator.pop(context);
    } else {
      // Handle case when fields are empty
    }
  }
  
}
