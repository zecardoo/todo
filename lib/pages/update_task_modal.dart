import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class EditTask extends StatefulWidget {

  // Declare variables to hold required data
  final String initialTask;
  final String initialDescription;
  final String initialdocID;
  final DateTime initialdate;
  // Define required parameters in the constructor
  const EditTask({
    super.key,
    required this.initialTask,
    required this.initialDescription,
    required this.initialdocID,
    required this.initialdate

  });

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  final Logger logger = Logger();

  late TextEditingController taskController;
  late TextEditingController descriptionController;
  late String docID;
  late DateTime initialdate;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with initial data
    taskController = TextEditingController(text: widget.initialTask);
    descriptionController = TextEditingController(text: widget.initialDescription);
    initialdate = widget.initialdate;
    docID = widget.initialdocID;
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
      buttonPadding:  EdgeInsets.all(MediaQuery.of(context).size.width*0.1),

      title: const Text('Edit Task', style: TextStyle(),),
    
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: taskController,style: TextStyle(
              color: Colors.grey[600],
              fontSize: 20
            ),

            decoration: const InputDecoration( label: Text('Task')),
          ),


          const SizedBox(height: 30),

          TextField(
            controller: descriptionController, style: TextStyle(
              color: Colors.grey[600],
              fontSize: 20
            ),

            decoration: const InputDecoration(label: Text('Description')),
          ),

          const SizedBox(height: 30),

          TextButton(
            onPressed: () async{
              final editDate = await showDatePicker(
                context: context,
                firstDate: DateTime.now(),
                lastDate: DateTime(2100),
              );
               if (editDate != null) {
                setState(() {
                  initialdate = editDate;
                });
              }
            },

            child: Text( 'Due Date: ${initialdate.year}/${initialdate.month}/${initialdate.day}', style: const TextStyle(color: Colors.black),),
          ),
          const SizedBox(height: 30),
        ],
      ),

      actions: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.red, fontSize: 15),
          ),
        ),
        
        ElevatedButton(
          onPressed: () {
            if (taskController.text.isNotEmpty && descriptionController.text.isNotEmpty) {
              final documentReference = FirebaseFirestore.instance.collection('Todo').doc(docID);
              documentReference.update({
                'task': taskController.text,
                'description': descriptionController.text,
                'date': initialdate,
              }).then((_) {
                          logger.i('----------[ Updated Successfull ]----------'); 
                        }).catchError((onError) {
                          logger.i('Error: $onError  id: $docID');
                        });

              Navigator.pop(context);
            } else {
              // Handle case when fields are empty
            }
          },
          child: Text(
            'Edit Task',
            style: TextStyle(color: Colors.blueGrey[800], fontSize: 15),
          ),
        ),
      ],
    );
  }
}
