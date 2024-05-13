import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Lodaing extends StatefulWidget {
  const Lodaing({super.key});

  @override
  State<Lodaing> createState() => _LodaingState();

  
}

class _LodaingState extends State<Lodaing> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[600],

      body: const Center(
        child: SpinKitCubeGrid(
          color: Colors.white,
          size: 80.0,
        ),
      ),
    );
  }
}