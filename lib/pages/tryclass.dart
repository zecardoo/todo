import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:todo/pages/add_task_modal.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

// Define an enum for the menu actions
enum TaskAction { edit, delete }

class _HomeState extends State<Home> {
  final Logger logger = Logger();
  final user = FirebaseAuth.instance.currentUser!;
  int currentPageIndex = 0;

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> taskPages = [
      _buildTaskPage(false), // Page for incomplete tasks
      _buildTaskPage(true),  // Page for completed tasks
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

  // Method to build a task page based on completion status
  Widget _buildTaskPage(bool isCompleted) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Todo')
            .where('iscompleted', isEqualTo: isCompleted)
            .where('userID', isEqualTo: user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final task = snapshot.data!.docs[index];
              final docsID = task.id;
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
                      decoration: task['iscompleted'] ? TextDecoration.lineThrough : null,
                      color: task['iscompleted'] ? Colors.grey[400] : null,
                    ),
                  ),
                  subtitle: Text(
                    task['description'],
                    style: TextStyle(
                      decoration: task['iscompleted'] ? TextDecoration.lineThrough : null,
                      color: task['iscompleted'] ? Colors.grey[400] : null,
                    ),
                  ),
                  dense: false,
                  trailing: PopupMenuButton<TaskAction>(
                    tooltip: '',
                    icon: const Icon(Icons.more_vert),
                    onSelected: (TaskAction item) {
                      switch (item) {
                        case TaskAction.edit:
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) {
                              return const AddNewTask();
                            },
                          );
                          break;

                        case TaskAction.delete:
                          documentReference.delete()
                          .then((_) {
                            logger.i('----------[ Deleted Successfully ]----------');
                          }).catchError((onError) {
                            logger.e('Error ----> $onError');
                          });
                          break;
                      }
                    },
                    itemBuilder: (context) => <PopupMenuEntry<TaskAction>>[
                      const PopupMenuItem(
                        value: TaskAction.edit,
                        child: ListTile(leading: Icon(Icons.edit_outlined), title: Text('Edit')),
                      ),
                      const PopupMenuItem(
                        value: TaskAction.delete,
                        child: ListTile(leading: Icon(Icons.delete_outline_outlined), title: Text('Delete')),
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
