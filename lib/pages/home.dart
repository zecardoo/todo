import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo/components/taskdata.dart';
import 'package:todo/pages/addtaskmodal.dart';

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
      backgroundColor: Colors.grey[100],
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
      body: Center(
        
        child: ListView.builder(
          itemCount: _tasks.length,
          itemBuilder: (context, index){
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
        )
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
            print(task);
            // if(task != null){
            //   _addnewtask(task);
            // }
            
          
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

