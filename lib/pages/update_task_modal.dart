import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class EditTask extends StatefulWidget {
  final String initialTask;
  final String initialDescription;
  final String initialDocID;
  final DateTime initialDate;

  const EditTask({
    super.key,
    required this.initialTask,
    required this.initialDescription,
    required this.initialDocID,
    required this.initialDate,
  });

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  final Logger logger = Logger();

  late TextEditingController taskController;
  late TextEditingController descriptionController;
  late DateTime initialDate;
  late String docID;

  @override
  void initState() {
    super.initState();
    taskController = TextEditingController(text: widget.initialTask);
    descriptionController =
        TextEditingController(text: widget.initialDescription);
    initialDate = widget.initialDate;
    docID = widget.initialDocID;
  }

  @override
  void dispose() {
    taskController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      buttonPadding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
      title: const Text(
        'Edit Task',
        style: TextStyle(),
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
        'Due Date: ${initialDate.year}/${initialDate.month}/${initialDate.day}',
        style: const TextStyle(color: Colors.black),
      ),
    );
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
      onPressed: _editTask,
      child: Text(
        'Edit Task',
        style: TextStyle(color: Colors.blueGrey[800], fontSize: 15),
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
        initialDate = selectedDate;
      });
    }
  }

  void _editTask() {
    if (taskController.text.isNotEmpty && descriptionController.text.isNotEmpty) {
      final documentReference = FirebaseFirestore.instance.collection('Todo').doc(docID);
      documentReference.update({
        'task': taskController.text,
        'description': descriptionController.text,
        'date': initialDate,
      }).then((_) {
        logger.i('----------[ Updated Successfully ]----------'); 
      }).catchError((onError) {
        logger.i('Error: $onError  id: $docID');
      });

      Navigator.pop(context);
    } else {
      // Handle case when fields are empty
    }
  }
}
