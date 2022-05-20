import 'package:flutter/material.dart';
import 'package:splash_screens/splash_screens/splash_animation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nested Navigation',
      home: const Home(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink,
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              print("tapped");
            },
            child: Container(
              color: Colors.green,
              child: const Center(
                child: Text(
                  "Initial Page content",
                  style: TextStyle(
                    fontSize: 40,
                  ),
                ),
              ),
            ),
          ),
          const SplashAnimation(),
        ],
      ),
    );
  }
}
