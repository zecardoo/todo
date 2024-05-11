import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:todo/pages/add_task_modal.dart';
import 'package:todo/pages/update_task_modal.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

// here i used as the value in menu function 
enum TaskAction {edit, delete}

class _HomeState extends State<Home> {
  final Logger logger = Logger();
  final user = FirebaseAuth.instance.currentUser!;
  int currentPageIndex = 0;

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    // Define the task pages
    final List<Widget> taskPages = [
      _buildTaskPage(false), // Page for incomplete tasks
      _buildTaskPage(true), // Page for completed tasks
    ];

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: const Icon(Icons.logout_rounded, color: Colors.white),
          )
        ],
        backgroundColor: Colors.blueGrey[600],
      ),
      body: taskPages[currentPageIndex], // Show the current page

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPageIndex,
        onTap: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.done),
            icon: Icon(Icons.done_outline_sharp),
            label: 'Completed',
          ),
        ],
      ),
      
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final task = await showDialog(
            // not allowed the user to pop the context from anywhere in screen
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return const AddNewTask();
            },
          );
          if (task != null) {
            currentPageIndex = 0;
          }
        },
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: const Icon(
          Icons.add,
          size: 28,
          color: Colors.black,
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  // Method to build a task page based on completion status=======================================================
  Widget _buildTaskPage(bool isCompleted) {
    AnimationStyle? animationStyle;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Todo')
            .where('iscompleted', isEqualTo: isCompleted)
            .where('userID', isEqualTo: user.uid)
            .snapshots(),

        builder: (context, snapshot) {
          //if has error 
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          // if correct
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }


          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              // get the data index
              final task = snapshot.data!.docs[index];
              // get the id of the data 
              final docsID = task.id;
              // get the data of that id doc to update or delete 
              final documentReference = FirebaseFirestore.instance.collection('Todo').doc(docsID);

              return Card(
                child: ListTile(
                  leading: Checkbox(
                    value: task['iscompleted'],

                    onChanged: (bool? value) {
                      setState(() {
                        documentReference.update({'iscompleted': value!})
                            .then((_) {
                          logger.i('Data updated ----->  iscompleted: $value  id: $docsID');
                        }).catchError((onError) {
                          logger.i('Error: $onError  id: $docsID');
                        });
                      });
                    },
                  ),

                  title: Text(
                    task['task'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration:
                          task['iscompleted'] ? TextDecoration.lineThrough : null,
                      color: task['iscompleted'] ? Colors.grey[400] : null,
                    ),
                  ),

                  subtitle: Text(
                    task['description'],
                    style: TextStyle(
                      decoration:
                          task['iscompleted'] ? TextDecoration.lineThrough : null,
                      color: task['iscompleted'] ? Colors.grey[400] : null,
                    ),
                  ),

                  dense: false,
                  trailing: PopupMenuButton<TaskAction>(
                    //to hide text when i hover button
                    tooltip: '',
                    popUpAnimationStyle: animationStyle,
                    icon: const Icon(Icons.more_vert),
                    onSelected: (TaskAction item) {
                      switch (item) {
                        case TaskAction.edit:
                          showDialog(
                            // not allowed the user to pop the context from anywhere in screen
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) {
                              return EditTask(initialTask: task['task'], initialDescription: task['description'], initialdocID: docsID,  initialdate: (task['date'] as Timestamp).toDate(),);
                            }, 
                          );
                          break;

                        case TaskAction.delete:
                          documentReference.delete()
                          .then((_) {
                            logger.i('----------[ Deleted Successfull ]----------');
                          }).catchError((onError) {

                            logger.e('Error ----> $onError');
                          });
                        break;
                        default:
                      }
                    },
                    itemBuilder: (context) => <PopupMenuEntry<TaskAction>>[
                      const PopupMenuItem(
                        value: TaskAction.edit,
                        child: ListTile( leading: Icon(Icons.edit_outlined),   title: Text('Edit'), ),
                      ),
                      
                      const PopupMenuItem(
                        value: TaskAction.delete,
                        child:ListTile( leading: Icon(Icons.delete_outline_outlined), title: Text('Delete'), ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
