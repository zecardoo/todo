// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:todo/components/button.dart';
import 'package:todo/components/square_tile.dart';
import 'package:todo/components/text_fild.dart';
import 'package:todo/services/google_auth.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;

  // Constructor with an onTap function parameter
  const LoginPage({
    super.key,
    this.onTap,
  }) ;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn() async {
    // Show loading dialog while signing in
    showLoadingDialog();
    try {
      // Sign in with email and password
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      // Hide loading dialog and show error message
      Navigator.pop(context);
      showErrorMessage(e.code);
    }
  }

  void showLoadingDialog() {
    // Show a loading dialog
    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
  }

  void showErrorMessage(String message) {
    // Show error message in an AlertDialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 255, 0, 0),
        title: Column(
          children: [
            const Icon(Icons.error, color: Colors.white, size: 50),
            const SizedBox(height: 20),
            Text(message, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.lock, size: 100, color: Colors.blueGrey[600],), // Lock icon
                const SizedBox(height: 50), // Spacing
                const SizedBox(height: 10), // Spacing
                TextFild(labelText: 'Email', controller: emailController, obscureText: false), // Email input field
                const SizedBox(height: 15), // Spacing
                TextFild(labelText: 'Password', controller: passwordController, obscureText: true), // Password input field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('Forgot Password ?', style: TextStyle(color: Colors.grey[700])), // Forgot password text
                    ],
                  ),
                ),
                const SizedBox(height: 20), // Spacing
                Button(onTap: signUserIn, text: 'Sign In'), // Sign in button
                const SizedBox(height: 50), // Spacing
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    children: [
                      Expanded(child: Divider(thickness: 1, color: Colors.grey[400])), // Divider
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text('Or continue with'), // Or continue with text
                      ),
                      Expanded(child: Divider(thickness: 1, color: Colors.grey[400])), // Divider
                    ],
                  ),
                ),
                const SizedBox(height: 10), // Spacing
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SquareTile(onTap: () => GoogleAuth().signInWithGoogle(context), imagePath: 'assets/google.png'), // Google sign in
                    const SizedBox(width: 25), // Spacing
                    SquareTile(onTap: () {}, imagePath: 'assets/facebook.png'), // Facebook sign in
                  ],
                ),
                const SizedBox(height: 50), // Spacing
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Not a member?', style: TextStyle(color: Colors.grey[700])), // Not a member text
                    const SizedBox(width: 4), // Spacing
                    GestureDetector(
                      onTap: widget.onTap, // Navigate to register page on tap
                      child: const Text(
                        'Register now',
                        style: TextStyle(color: Color.fromARGB(255, 0, 23, 230)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
