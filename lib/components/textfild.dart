import 'package:flutter/material.dart';

class TextFild extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final contrller;
  final String labelText;
  final bool obscureText;

  const TextFild({
    super.key,
    required this.contrller,
    required this.labelText,
    required this.obscureText
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: TextField(
                //get the data 
                controller: contrller,
                //hide the input like in password 
                obscureText: obscureText,
                //info inside the input
                decoration: InputDecoration(
                  labelText: labelText,
                  hintText: 'type here....',
                  hintStyle: TextStyle(
                    color: Colors.grey[300],
                    fontSize: 13,
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(255, 207, 207, 207))
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(255, 104, 104, 104))
                  ),
                  fillColor: Colors.white54,
                  filled: true,

                ),
              ),
            );
  }
}