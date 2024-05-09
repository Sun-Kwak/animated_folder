import 'package:flutter/material.dart';
import 'package:flutter/animated_folder.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: AnimatedFolder(
            width: 300,

            /// without animationBy, the default is depend on platform
            /// on web, the default is AnimationBy.hover
            /// on mobile, the default is AnimationBy.tap
            animationBy: AnimationBy.tap,

            /// without animationDuration, the default is 300ms
            duration: const Duration(milliseconds: 500),

            /// without mainColor, the default is Color(0xFF56AAF3)
            mainColor: Colors.red,

            /// without folderColor, the default is [Color(0xFFE8E9EC), Color(0xFFD9D9D9), Color(0xFFBFBFBF), mainColor]
            /// the length of folderColor must be 4 or null
            folderSheetColors: const [
              Colors.red,
              Colors.green,
              Colors.blue,
              Colors.yellow,
            ],

            /// it will be placed on the front of the folder
            child: const Center(
              child: Text('Hello World'),
            )),
      ),
    );
  }
}
