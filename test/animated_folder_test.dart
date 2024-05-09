import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:animated_folder/animated_folder.dart';

void main() {
  testWidgets('AnimatedFolder widget test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AnimatedFolder(
            animationBy: AnimationBy.tap,
            child: const Text('AnimatedFolder Test'),
          ),
        ),
      ),
    );

    // Tap the folder to simulate triggering the animation by tap
    await tester.tap(find.byType(AnimatedFolder));
    await tester.pumpAndSettle();

    // Now the folder should be open, we can check if the child widget is visible
    expect(find.text('AnimatedFolder Test'), findsOneWidget);

    // Tap the folder again to close it
    await tester.tap(find.byType(AnimatedFolder));
    await tester.pumpAndSettle();
  });
}
