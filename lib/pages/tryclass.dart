import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo/components/button.dart';
import 'package:todo/components/text_fild.dart';
import 'package:todo/components/square_tile.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;

  // Constructor with an onTap function parameter
  const RegisterPage({Key? key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final conformPasswordController = TextEditingController();

  // Method to sign up user
  void signUserUp() async {
    showLoadingDialog();
    try {
      if (passwordController.text == conformPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
      } else {
        Navigator.pop(context);
        showErrorMessage('Passwords don\'t match. Please try again!');
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      showErrorMessage(e.code);
    }
  }

  // Method to show error message in AlertDialog
  void showErrorMessage(String message) {
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

  // Method to show loading dialog
  void showLoadingDialog() {
    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
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
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.lock, size: 100), // Lock icon
                const SizedBox(height: 50), // Spacing
                const SizedBox(height: 10), // Spacing
                TextFild(labelText: 'Email', controller: emailController, obscureText: false), // Email input field
                const SizedBox(height: 15), // Spacing
                TextFild(labelText: 'Password', controller: passwordController, obscureText: true), // Password input field
                const SizedBox(height: 15), // Spacing
                TextFild(labelText: 'Confirm Password', controller: conformPasswordController, obscureText: true), // Confirm password input field
                const SizedBox(height: 20), // Spacing
                Button(onTap: signUserUp, text: 'Sign Up'), // Sign up button
                const SizedBox(height: 50), // Spacing
                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    children: [
                      Expanded(child: Divider(thickness: 1, color: Colors.grey[700])), // Divider

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
                    SquareTile(onTap: () {}, imagePath: 'assets/google.png'), // Google sign in
                    const SizedBox(width: 25), // Spacing
                    SquareTile(onTap: () {}, imagePath: 'assets/facebook.png'), // Facebook sign in
                  ],
                ),
                const SizedBox(height: 50), // Spacing
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account?', style: TextStyle(color: Colors.grey[700])), // Already have account text
                    const SizedBox(width: 4), // Spacing
                    GestureDetector(
                      onTap: widget.onTap, // Navigate to login page on tap
                      child: const Text('Login now', style: TextStyle(color: Color.fromARGB(255, 0, 23, 230))), // Login now text
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
