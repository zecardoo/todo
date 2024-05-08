// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class SquareTile extends StatelessWidget {
  final String imagePath;
  final Function()? onTap;
  
  const SquareTile({
    super.key,
    required this.imagePath,
    required this.onTap,
  });

  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        padding: const EdgeInsets.all(20),

        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[200]
          
        ),

        child: Image(
          image: AssetImage(imagePath),
          height: 40,
        )
      ),
    );
  }
}
