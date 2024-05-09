import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:todo/pages/addtaskmodal.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Logger logger = Logger();

  final user = FirebaseAuth.instance.currentUser!;
  int currentPageIndex = 0;

  // Sign User out ===========================================
  void signUserOut () {
    FirebaseAuth.instance.signOut();
  }

  // Update the task ===========================================
  // void updateTask (){ 

  // }

  @override
  Widget build(BuildContext context) {



    final List<Widget> taskpages = [
    
    // ############################################# Display TAsk Page 1 #############################################=
          Padding(
          padding: const EdgeInsets.all(8.0),

          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('Todo').where('iscompleted', isEqualTo: false).snapshots(),

            builder: (context, snapshot) {
              if(snapshot.hasError){
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }

              if(snapshot.connectionState == ConnectionState.waiting){
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  //call the data 
                  final task = snapshot.data!.docs[index];

                  // call the id of data
                  final docsID = task.id;
                  //select the DocumentReference to update  
                  DocumentReference documentReference = FirebaseFirestore.instance.collection('Todo').doc(docsID);

                 

                  return Card(
                    child: ListTile(
                      leading: Checkbox(
                        value: task['iscompleted'],
                        onChanged: (bool? value) {
                          setState(() {
                            //update the data 
                            documentReference.update({'iscompleted': value!}).
                             then((_) {
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

                      trailing: IconButton(
                        onPressed: () {
                          
                        },

                        icon: const Icon(Icons.more_vert),
                      ),
                    ),
                  );
                },
              );
            }

          )
      ),

      // ############################################# Display TAsk Page 2 #############################################

      Padding(
          padding: const EdgeInsets.all(8.0),

          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('Todo').where('iscompleted', isEqualTo: true).snapshots(),

            builder: (context, snapshot) {
              if(snapshot.hasError){
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }

              if(snapshot.connectionState == ConnectionState.waiting){
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  //call the data 
                  final task = snapshot.data!.docs[index];

                  // call the id of data
                  final docsID = task.id;

                  //select the DocumentReference to update  
                  DocumentReference documentReference = FirebaseFirestore.instance.collection('Todo').doc(docsID);

                  return Card(
                    child: ListTile(
                      leading: Checkbox(
                        value: task['iscompleted'],
                        onChanged: (bool? value) {
                          setState(() {
                            //update the data 
                            documentReference.update({'iscompleted': value!}).
                            then((_) {
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

                      trailing: IconButton(
                        onPressed: () {
                          
                        },

                        icon: const Icon(Icons.more_vert),
                      ),
                    ),
                  );
                },
              );
            }

          )
      ),
    ];
    
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

      body: taskpages[currentPageIndex],
      

      
      // ############################################# NavigationBar #############################################
      //  bottomNavigationBar
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
              currentPageIndex =0;
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