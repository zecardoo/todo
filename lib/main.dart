import 'package:flutter/material.dart';
import 'package:todo/pages/auth/auth_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
void main() async{
  
  // Ensure that WidgetsFlutterBinding is properly initialized
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.android,
);
  runApp( MaterialApp(
    initialRoute: '/login',
    routes: {
      '/login':(context) => const AuthPage(),
      // '/addtask':(context) => const AddTask(),

    },
    debugShowCheckedModeBanner: false,
  ));
}
