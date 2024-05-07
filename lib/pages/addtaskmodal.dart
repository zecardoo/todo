import 'package:flutter/material.dart';
import 'package:todo/components/taskdata.dart';

class AddNewTask extends StatefulWidget {
  const AddNewTask({super.key});

  @override
  State<AddNewTask> createState() => _AddNewTaskState();
}

class _AddNewTaskState extends State<AddNewTask> {
  final  namecontroller = TextEditingController();
  final  descriptioncontroller = TextEditingController();
  late DateTime _dueDate;



  @override
  void initState() {
    super.initState();
    _dueDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      buttonPadding: const EdgeInsets.all(20),
      
        title: const Text(
          'Add New Task',
          style: TextStyle(
            fontWeight: FontWeight.bold
          ),
        ),
        
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
          TextField(
            controller: namecontroller,
            decoration: const InputDecoration(label: Text('Task')),
          ),

          const SizedBox(height: 20),

          TextField(
            controller: descriptioncontroller,
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
            child: Text(
              'Due Date: ${_dueDate.year}/${_dueDate.month}/${_dueDate.day}',
              style: const TextStyle(
                color: Colors.black87
              ),
            ),
          ),

          const SizedBox(height: 20),

        ],),

        

        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Colors.red,
                // fontWeight: FontWeight.bold,
                fontSize: 15
              ),
              
            ),
          ),
          
          ElevatedButton(
            onPressed: () {
              final newtask = Task(
                name: namecontroller.text,
                description: descriptioncontroller.text,
                dueDate: _dueDate,
                isCompleted: false,
              );
              Navigator.pop(context,newtask);
            },
            
            child: Text(
              'Add Task', 
              style: TextStyle(
                color: Colors.blueGrey[800],
                fontSize: 15
              ),
            
            ),
          )
        
        ],
        
        
      );
  }
}

