
###  Package Description

This package provides an "AnimationFolder" widget, which represents a folder with animated sheets that expand when tapped or hovered over. It offers an intuitive way to display content within a folder with interactive animations, enhancing user experience.

### Features

-Animated folder with expanding sheets
-Interactive animations triggered by tap or hover
(on web, the default is AnimationBy.hover,on mobile, the default is AnimationBy.tap)
- Optional `animationBy` parameter to specify the animation trigger method (default is depending on the platform).
-Customizable duration, size, color for animations

![animated_folder](https://github.com/Sun-Kwak/animated_folder/assets/136423352/0aecd0f9-f7f0-4854-b9fc-5e17df136cee)

### Getting Started

To start using this package, you need to have Flutter installed. Then, you can simply add the package to your pubspec.yaml file:

```
dependencies:
  animation_folder: ^x.x.x # Replace with the latest version
```

For more detailed instructions on installation and usage, check out the animation_folder package on pub.dev.

### Usage

Here's a simple example of how to use the AnimationFolder widget:
```
import 'package:animated_folder/animated_folder.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return   MaterialApp(
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
          )
        ),
      ),
    );
  }
}
```
