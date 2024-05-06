import 'package:flutter/material.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: Colors.blueGrey[600],
        title: const Text(
          'Add New Task ',
          style: TextStyle(
            color: Colors.white
          ),
        ),
        centerTitle: true,

        iconTheme: const IconThemeData(
          color: Colors.white,
          
        ),
        
      ),

      body: const Column(
        children: [

        ],
      ),
    );
  }
}