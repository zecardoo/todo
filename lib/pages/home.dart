import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo/components/taskdata.dart';
import 'package:todo/pages/addtaskmodal.dart';
import 'package:intl/intl.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final user = FirebaseAuth.instance.currentUser!;
  final List<Task> _tasks = [];


  void _addnewtask (Task task) {
    setState(() {
      _tasks.add(task);
    });
  }
  
  void _removeTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }
  void signUserOut () {
    FirebaseAuth.instance.signOut();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
            // ############################################# APP BAR #############################################

      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: const Icon(Icons.logout_rounded, color: Colors.white,),
          )
        ],
        
        backgroundColor: Colors.blueGrey[600],
      ),

      // ############################################# Body #############################################
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          
          child: ListView.builder(
            itemCount: _tasks.length,
            itemBuilder: (context, index){
              final task = _tasks[index];
              // Format the date
              String formattedDate = DateFormat('yyyy-MM-dd').format(task.dueDate);
              
              return Card(
                child: ListTile(
                
                
                leading: Checkbox(
                  activeColor: Colors.blueGrey[400],
                  value: task.isCompleted,
                  onChanged: (bool? value) {
                    setState(() {
                      task.isCompleted = value!;
                    });
                  },
                ),
                
                title: Text(
                  task.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    decoration: task.isCompleted ? TextDecoration.lineThrough : null, // Add a strikethrough effect when task is completed
                    color: task.isCompleted ? Colors.grey : Colors.black, // Change text color when task is completed
                  ),
                ),
                subtitle: Text(
                  task.description,
                  style: TextStyle(
                    fontSize: 13,
                    decoration: task.isCompleted ? TextDecoration.lineThrough : null, // Add a strikethrough effect when task is completed
                    color: task.isCompleted ? Colors.grey : Colors.grey[700], // Change text color when task is completed
                  ),
                ),
                dense: true,
                trailing: IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {
                    // _removeTask(index);
                  },
                ),
                          ),
              );
            },
          )
        ),
      ),
      
      // ############################################# NavigationBar #############################################


      //  bottomNavigationBar
      bottomNavigationBar: BottomAppBar(
        color: Colors.blueGrey[600],
        height: 50,
      ),

      // button 
      floatingActionButton: PhysicalModel(
        color: Colors.black,
        shadowColor: Colors.white,
        elevation: 3,
        shape: BoxShape.circle,
        child: FloatingActionButton(
          onPressed: () async{
            final task = await showDialog(
              barrierDismissible: false, // Set to false to prevent dialog dismissal on tap outside
              context: context,
              builder: (BuildContext context) {
                return const AddNewTask();
              },
            );
            if(task != null){
              _addnewtask(task);
            }
            
          
          // Navigator.pushNamed(context, '/addtask');
          },
          backgroundColor: Colors.white,
        
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: const Icon(
            Icons.add,
            size: 28,
            color: Colors.black,
          )
        ),
      ),
      
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      

    );
  }
}

