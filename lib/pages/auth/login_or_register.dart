import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:todo/pages/auth/login.dart';
import 'package:todo/pages/auth/register.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  // Initially show login page
  bool showLoginPage = true;

  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  void showLoadingDialog() {
    // Show a loading dialog
    showDialog(
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.blueGrey[600],
          ),
          child: const Center(
            child: SpinKitCubeGrid(
              color: Colors.white,
              size: 80.0,
            ),
          ),
        );
      },
    );

    // Close the dialog after 1 second
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(
        onTap: () {
          showLoadingDialog(); // Corrected: Call the method as a function
          togglePages(); // Corrected: Call the method as a function
        },
      );
    } else {
      return RegisterPage(
        onTap: () {
          showLoadingDialog(); // Corrected: Call the method as a function
          togglePages(); // Corrected: Call the method as a function
        },
      );
    }
  }
}
