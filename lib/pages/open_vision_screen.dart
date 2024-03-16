import 'package:flutter/material.dart';

class Screen2 extends StatefulWidget {
  const Screen2({super.key});

  @override
  State<Screen2> createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              color: Color.fromARGB(255, 215, 231, 237),
              child: Center(
                child: Text('Top Part'),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Color.fromARGB(255, 206, 194, 182),
              child: Center(
                child: Text('Bottom Part'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
