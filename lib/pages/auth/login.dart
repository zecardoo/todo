
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo/components/button.dart';
import 'package:todo/components/textfild.dart';
import 'package:todo/components/square_tile.dart';
import 'package:todo/services/google_auth.dart';
 
 
class LoginPage extends StatefulWidget {
  
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailcontroller = TextEditingController();

  final passwordcontroller = TextEditingController();
  // sign user method
  void signUserIn() async{
    
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    );
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailcontroller.text,
        password: passwordcontroller.text
      );
      
      // ignore: use_build_context_synchronously
      Navigator.pop(context);

    } on FirebaseAuthException catch (e) {
      
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      
      showErrorMessage(e.code);

      
    }
  }

  void showErrorMessage (String message) {
    showDialog(
      context: context, 
      builder: (context) {
      return AlertDialog(
        backgroundColor: const Color.fromARGB(255, 255, 0, 0),
        title: Column(
          children: [
            const Icon(Icons.error, color: Colors.white, size: 50,),
            const SizedBox(height: 20),
            Text(message, style: const TextStyle(color: Colors.white),)
          ],
        ),
      );
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold (
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // const SizedBox(height: 50,),
                
                //logo 
                const Icon(
                  Icons.lock,
                  size: 100,
                ),
                
                // Wlecome message 
                const SizedBox(height: 50),
                const Text('Welcome back you\'ve been missd'),
                const SizedBox(height: 10),
            
                // username input 
                TextFild(
                  labelText: 'Email',
                  contrller: emailcontroller,
                  obscureText: false,
            
                ),
            
                const SizedBox(height: 15),
                 // Password input 
                TextFild(
                  labelText: 'Password',
                  contrller: passwordcontroller,
                  obscureText: true,
            
                ),
            
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('Forgot Password ?', style: TextStyle(color: Colors.grey[700]),),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Sign button
                Button(
                  onTap: signUserIn,
                  text: 'Sign In',

                ),
                
                const SizedBox(height: 50),
            
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    children: [
            
                      Expanded(
                        child: Divider(thickness: 1, color: Colors.grey[400],)
                      ),
            
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text('Or continue with'),
                      ),
            
                      Expanded(
                        child: Divider(thickness: 1, color: Colors.grey[400],)
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 10),
            
                // Google & facebook Sign In
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Image(image: AssetImage('assets/google.png'))
                    SquareTile(
                      onTap: () => GoogleAuth().signInWithGoogle(context),
                      imagePath: 'assets/google.png',
                    ),
                    
                    const SizedBox(width: 25),
            
                    SquareTile(
                      onTap: () {},
                      imagePath: 'assets/facebook.png',
                    )
                    
                  ],
                ),
            
                const SizedBox(height: 50),
            
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Not a member?', style: TextStyle(
                      color: Colors.grey[700]
                    ),),
                    const SizedBox(width: 4,),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text('Register now', style:  TextStyle(
                        color: Color.fromARGB(255, 0, 23, 230)
                      ),),
                    ),
                  ],
                ),
              ],),
          ),
          ),
        
      ),
    );
  }
}

