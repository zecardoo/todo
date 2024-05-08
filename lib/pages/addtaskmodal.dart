import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class AddNewTask extends StatefulWidget {
  const AddNewTask({super.key});

  @override
  State<AddNewTask> createState() => _AddNewTaskState();
}

class _AddNewTaskState extends State<AddNewTask> {

  // i useed this instead of print 
  final Logger logger = Logger();


  final  taskcontroller = TextEditingController();
  final  descriptioncontroller = TextEditingController();
  late DateTime _dueDate;


  void addtask (String task, String description, DateTime date, bool iscompleted) {
    // Get a reference to the Firestore database
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Get a reference to the "databes name" collection
    CollectionReference todo = firestore.collection('Todo');


     // Add a new document with a generated ID
    todo.add({
      'task': task,
      'description': description,
      'date': date,
      'iscompleted': iscompleted
    })
    .then((DocumentReference document) {
      //Here, i stands for the info level,
      logger.i('Document added with ID: ${document.id}');
    })
    .catchError((error) {
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
        
        // ############################################# input #############################################

        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
          TextFormField(
            controller: taskcontroller,
            decoration: const InputDecoration(label: Text('Task')),
            onChanged: (value) {
              
            },
           validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
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

        
        // ############################################# Button in #############################################

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
          
          // ############################################# Add new Task #############################################
          ElevatedButton(
            onPressed: () {
              if(taskcontroller.text.isNotEmpty && descriptioncontroller.text.isNotEmpty){
                addtask(taskcontroller.text, descriptioncontroller.text, _dueDate, false);
                
                Navigator.pop(context);
              }else {
                
              } 
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

