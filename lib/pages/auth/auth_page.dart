import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo/pages/auth/login_or_register.dart';
import 'package:todo/pages/home.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // User is logged in 
          if(snapshot.hasData){
            return HomePage();
          }

          //User is not logged in
          else {
            return const LoginOrRegister();
          } 
        },
        
      ),
    );
  }
}