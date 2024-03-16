import 'package:aurora/pages/newpagge.dart';
import 'package:aurora/pages/open_vision_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: (Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 40),
                  height: 80,
                  width: 150,
                  decoration: BoxDecoration(
                    image:
                        DecorationImage(image: AssetImage('assets/logo.png')),
                  ),
                ),
              ),
              const Expanded(child: TextAnimation()),
            ],
          )),
        ),
      ),
    );
  }
}

class TextAnimation extends StatefulWidget {
  const TextAnimation({super.key});

  @override
  _TextAnimationState createState() => _TextAnimationState();
}

class _TextAnimationState extends State<TextAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.forward();

    // Navigate to a new screen after 4 seconds
    // Future.delayed(const Duration(seconds: 6), () {
    //   Navigator.of(context).pushReplacement(
    //     MaterialPageRoute(builder: (context) => Screen1()),
    //   );
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 200,
        ),
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(seconds: 2),
          curve: const Interval(0, 0.2, curve: Curves.easeInOut),
          builder: (BuildContext context, double value, Widget? child) {
            return Opacity(
              opacity: value,
              child: const Text(
                'Welcome',
                style: TextStyle(
                    fontSize: 38, color: Color.fromARGB(255, 74, 73, 73)),
              ),
            );
          },
        ),
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(seconds: 2),
          curve: const Interval(0, 0.2, curve: Curves.easeInOut),
          builder: (BuildContext context, double value, Widget? child) {
            return Opacity(
              opacity: value,
              child: const Text(
                'To a',
                style: TextStyle(
                    fontSize: 32, color: Color.fromARGB(255, 74, 73, 73)),
              ),
            );
          },
        ),
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(seconds: 2),
          curve: const Interval(0.2, 0.4, curve: Curves.easeInOut),
          builder: (BuildContext context, double value, Widget? child) {
            return Opacity(
              opacity: value,
              child: const Text(
                'Better',
                style: TextStyle(
                    fontSize: 32, color: Color.fromARGB(255, 74, 73, 73)),
              ),
            );
          },
        ),
        const SizedBox(height: 4),
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(seconds: 2),
          curve: const Interval(0.4, 1, curve: Curves.easeInOut),
          builder: (BuildContext context, double value, Widget? child) {
            return Opacity(
              opacity: value,
              child: const Text(
                'Tomorrow',
                style: TextStyle(
                    fontSize: 32,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
