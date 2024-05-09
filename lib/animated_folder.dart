library animated_folder;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

/// AnimatedFolder is a widget that creates a folder with animated sheets.
class AnimatedFolder extends StatefulWidget {
  /// it is the child widget that will be displayed on the last sheet of the folder
  final Widget? child;

  /// default width of the folder. it is 150. But considering perspective, total width will be width + width * 0.065 * 2
  final double? width;

  /// duration of the animation. default is 300 milliseconds
  final Duration? duration;

  /// main color of the folder. default is Color(0xFF56AAF3) which is a blue color
  final Color? mainColor;

  /// colors of the folder sheets. default is [Color(0xFFE8E9EC), Color(0xFFD9D9D9), Color(0xFFBFBFBF), mainColor]
  /// the length should be 4
  /// last color is the main color of the folder
  final List<Color>? folderSheetColors;

  /// how the animation will be triggered. default is depending on the platform. If it is web, it is triggered by hover. Otherwise, it is triggered by tap
  final AnimationBy? animationBy;

  AnimatedFolder({
    this.child,
    this.width = 150,
    this.duration = const Duration(milliseconds: 300),
    this.mainColor,
    this.folderSheetColors,
    this.animationBy = kIsWeb ? AnimationBy.hover : AnimationBy.tap,
    Key? key,
  }) : super(key: key) {
    /// check if the folderSheetColors length is 4 or null
    if (folderSheetColors != null && folderSheetColors!.length != 4) {
      throw Exception('folderSheetColors length should be 4 or null.');
    }
  }

  @override
  State<AnimatedFolder> createState() => _AnimatedFolderState();
}

class _AnimatedFolderState extends State<AnimatedFolder>
    with TickerProviderStateMixin {
  late List<AnimationController> controllers;
  late List<Animation<double>> animations;
  late Color color;
  late List<Color> folderSheetColors;

  /// isBreak is a boolean value that indicates whether the mouse is on the folder or not
  /// it is used to control currentControllerIndex
  late bool isBreak;

  /// currentControllerIndex is an integer value that indicates the index of the current controller
  /// it is set when isBreak is true or false
  int currentControllerIndex = 0;

  @override
  void initState() {
    /// initialize values when the widget is created
    initializeValues();
    super.initState();
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void initializeValues() {
    /// set the main color of the folder
    color = widget.mainColor ?? const Color(0xFF56AAF3);

    /// set the folder sheet colors
    folderSheetColors = widget.folderSheetColors ??
        [
          const Color(0xFFE8E9EC),
          const Color(0xFFD9D9D9),
          const Color(0xFFBFBFBF),
          color,
        ];

    /// set isBreak value depending on the animationBy value
    isBreak = widget.animationBy == AnimationBy.hover ? false : true;

    /// create animation controllers and animations
    controllers = List.generate(4,
        (index) => AnimationController(vsync: this, duration: widget.duration));

    animations = List.generate(
      4,
      (index) => Tween(begin: 0.0, end: 1.0).animate(controllers[index])
        ..addListener(() {
          setState(() {
            /// forward the next controller when the current controller's value is greater than 0.5
            /// and the status is forward
            /// also, the index should be less than the length of the controllers
            /// if isBreak is false which means the mouse is on the folder
            final bool isForwardCondition = !isBreak &&
                controllers[index].value >= 0.5 &&
                controllers[index].status == AnimationStatus.forward &&
                index < controllers.length - 1;

            /// reverse the previous controller when the current controller's value is less than 0.5
            /// and the status is reverse
            /// also, the index should be greater than 0
            /// if isBreak is true which means the mouse is not on the folder
            final bool isReverseCondition = isBreak &&
                controllers[index].value <= 0.5 &&
                controllers[index].status == AnimationStatus.reverse &&
                index > 0;

            /// animation conditions only work when the index is less than the length of the controllers
            if (index < controllers.length && index >= 0) {
              if (isForwardCondition) {
                /// forward the next controller
                controllers[index + 1].forward();
                currentControllerIndex = index + 1;
              } else if (isReverseCondition) {
                /// reverse the previous controller
                controllers[index - 1].reverse();
                currentControllerIndex = index - 1;
              }
            }
          });
        }),
    );
  }

  @override
  Widget build(BuildContext context) {
    /// height of the folder
    /// it is calculated by 0.84 ratio of the width
    final double height = widget.width! * 0.84;

    /// initial left value of the folder considering perspective
    final double initialLeft = widget.width! * 0.065;

    /// total width of the folder considering perspective
    final double totalWidth = widget.width! + (initialLeft * 2);

    /// border radius of the folder
    final double radius = widget.width! * 0.065;

    void onEnterOrTapForward(PointerEnterEvent e) {
      setState(() {
        isBreak = false;
        controllers[currentControllerIndex].forward();
      });
    }

    void onExitOrTapReverse(PointerExitEvent e) {
      setState(() {
        isBreak = true;
        controllers[currentControllerIndex].reverse();
      });
    }

    return GestureDetector(
      onTap: () {
        widget.animationBy == AnimationBy.tap
            ? isBreak
                ? onEnterOrTapForward(const PointerEnterEvent())
                : onExitOrTapReverse(const PointerExitEvent())
            : null;
      },
      child: MouseRegion(
        onEnter: (e) {
          widget.animationBy == AnimationBy.hover
              ? onEnterOrTapForward(e)
              : null;
        },
        onExit: (e) {
          widget.animationBy == AnimationBy.hover
              ? onExitOrTapReverse(e)
              : null;
        },
        cursor: SystemMouseCursors.click,
        child: SizedBox(
          width: totalWidth,
          height: height,
          child: Stack(
            children: [
              /// build the label of the folder
              buildLabel(radius, color, initialLeft),

              /// build the back cover of the folder
              buildBackCover(radius, color, initialLeft),

              /// build the folder sheets which is animated by the controllers
              buildFolderSheets(radius, initialLeft),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLabel(double radius, Color color, double initialLeft) {
    final double labelLeft = initialLeft + (widget.width! * 0.097);
    final double labelWidth = widget.width! * 0.357;
    final double labelHeight = widget.width! * 0.065;
    return Positioned(
      left: labelLeft,
      child: Container(
        width: labelWidth,
        height: labelHeight,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(radius),
            topRight: Radius.circular(radius),
          ),
        ),
      ),
    );
  }

  Widget buildBackCover(double radius, Color color, double initialLeft) {
    final double backCoverTop = widget.width! * 0.052;
    final double backCoverLeft = initialLeft + (widget.width! * 0.013);
    final double backCoverWidth = widget.width! * 0.974;
    final double backCoverHeight = widget.width! * 0.792;
    return Positioned(
      top: backCoverTop,
      left: backCoverLeft,
      child: Container(
        width: backCoverWidth,
        height: backCoverHeight,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(radius)),
        ),
      ),
    );
  }

  Widget buildFolderSheets(double radius, double initialLeft) {
    final int controllersLength = controllers.length;
    return Stack(
      children: List.generate(controllersLength, (index) {
        final double spacing = widget.width! * 0.039;
        final double topStart = widget.width! * 0.078;
        final List<double> tops = List.generate(controllersLength, (index) {
          return topStart + (spacing * index);
        });

        ///when width is 20, the ratio * 20 / width is 0.016
        ///when width is 40, the ratio * 20 / width is 0.008
        ///it increases as the width decreases
        ///this ratio is used to calculate the entry value of the sheet depending on the width
        const ratio = 0.32 / 20;

        /// controllers & animations are reversed to make the last sheet on the top
        final int reversedIndex = controllersLength - index - 1;
        final double entryValue =
            (ratio * 20 / widget.width!) * animations[reversedIndex].value;

        /// the more the index, the more the rotation value
        final double rotationValue = animations[reversedIndex].value *
            3.14 /
            (5 + (reversedIndex * 0.5));
        final double left = index == controllersLength - 1
            ? initialLeft
            : initialLeft + spacing;
        final double sheetWidth = index == controllersLength - 1
            ? widget.width!
            : widget.width! * 0.922;
        final double sheetHeight = widget.width! * 0.65;
        final double opacity =
            (1 - animations[reversedIndex].value + 0.8).clamp(0.0, 1.0);
        return Positioned(
          top: tops[index],
          left: left,
          child: Transform(
            alignment: Alignment.bottomCenter,
            transform: Matrix4.identity()
              ..setEntry(3, 2, entryValue)
              ..rotateX(rotationValue),
            child: Container(
              width: sheetWidth,
              height: sheetHeight,
              decoration: BoxDecoration(
                color: folderSheetColors[index].withOpacity(opacity),
                borderRadius: BorderRadius.all(Radius.circular(radius)),
              ),
              child: index == controllersLength - 1 ? widget.child : null,
            ),
          ),
        );
      }),
    );
  }
}

enum AnimationBy {
  hover,
  tap,
}
