import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final user = FirebaseAuth.instance.currentUser!;

  void signUserOut () {
    FirebaseAuth.instance.signOut();
  }
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: const Icon(Icons.logout_rounded, color: Colors.white,),
          )
        ],
        backgroundColor: Colors.blueGrey[600],
      ),

      body: Center(
        
        child: Column(
            
          children: [
            Text('LOGGED IN AS ${user.email!}', style: const TextStyle(fontSize: 20),),
          ],
          
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
          onPressed: () {
            Navigator.pushNamed(context, '/addtask');
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

