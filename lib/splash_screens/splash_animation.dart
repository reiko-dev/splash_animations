import 'dart:math';

import 'package:flutter/material.dart';
import 'package:splash_screens/transition_render_widget.dart';

enum SecondAnimationType { leftRight, rightLeft, topBottom, bottomTop }

class SplashAnimation extends StatefulWidget {
  const SplashAnimation({super.key});

  @override
  State<SplashAnimation> createState() => _SplashAnimationState();
}

class _SplashAnimationState extends State<SplashAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> colorAnim1;
  late final Animation<double> colorAnim2;
  late final Animation<double> opacityAnim;
  late final Animation<double> scaleAnim;
  late final Animation<double> translateAnim;

  late AlignmentGeometry beginValue;
  late AlignmentGeometry endValue;
  static final angles = [
    [Alignment.topLeft, Alignment.bottomRight],
    [Alignment.topCenter, Alignment.bottomCenter],
    [Alignment.topRight, Alignment.bottomLeft],
    [Alignment.centerLeft, Alignment.centerRight],
  ];

  late SecondAnimationType secondAnimationType;

  late Color backgroundColor;
  late Color mainColor;

  static final bgColors = [
    Colors.black,
    Colors.white,
    Colors.purple,
    Colors.amber,
    Colors.blue
  ];
  static final mainColors = [
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.indigo
  ];

  static final rand = Random();

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    colorAnim1 = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0, 0.2),
      ),
    );
    colorAnim2 = Tween<double>(begin: 0, end: -1).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.2, .66, curve: Curves.decelerate),
      ),
    );
    opacityAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.2, .66, curve: Curves.easeInCubic),
      ),
    );
    scaleAnim = Tween<double>(begin: .8, end: 1).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.26, .66, curve: Curves.elasticOut),
      ),
    );
    translateAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(.66, 1, curve: Curves.bounceOut),
      ),
    );

    super.initState();
  }

  @override
  dispose() {
    controller.dispose();
    super.dispose();
  }

  restart(Size size) {
    controller.value = 0;
    controller.forward();

    sortData(size);
  }

  sortData(Size size) {
    backgroundColor = bgColors[rand.nextInt(bgColors.length)];
    mainColor = mainColors[rand.nextInt(mainColors.length)];
    final newAngle = angles[rand.nextInt(angles.length)];
    beginValue = newAngle.first;
    endValue = newAngle.last;
    secondAnimationType = SecondAnimationType
        .values[rand.nextInt(SecondAnimationType.values.length)];
  }

  Offset secondAnimationOffset(double translateAnimValue, Size size) {
    switch (secondAnimationType) {
      case SecondAnimationType.rightLeft:
        return Offset(-translateAnimValue * size.width, 0);

      case SecondAnimationType.leftRight:
        return Offset(translateAnimValue * size.width, 0);

      case SecondAnimationType.topBottom:
        return Offset(0, translateAnimValue * size.height);

      case SecondAnimationType.bottomTop:
        return Offset(0, -translateAnimValue * size.height);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    restart(size);

    return IgnorePointer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SizedBox.fromSize(
          size: size,
          child: AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              return Transform.translate(
                offset: secondAnimationOffset(translateAnim.value, size),
                child: TransitionRenderWidget(
                  status: controller.status,
                  animValue: colorAnim1.value + colorAnim2.value,
                  backgroundColor: backgroundColor,
                  color: mainColor,
                  beginAngle: beginValue,
                  endAngle: endValue,
                  child: Opacity(
                    opacity: opacityAnim.value,
                    child: Transform.scale(
                      scale: scaleAnim.value,
                      child: child,
                    ),
                  ),
                ),
              );
            },
            child: const Center(
              child: Text(
                "Reiko (Vitor Lucas)",
                style: TextStyle(
                  color: Color(0xFFdcd5c7),
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
