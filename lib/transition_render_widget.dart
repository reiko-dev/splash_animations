import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class TransitionRenderWidget extends SingleChildRenderObjectWidget {
  const TransitionRenderWidget({
    required this.animValue,
    required this.status,
    this.color = const Color(0xFF131517),
    this.backgroundColor = const Color(0x00000000),
    this.beginAngle = Alignment.topCenter,
    this.endAngle = Alignment.bottomCenter,
    required super.child,
    super.key,
  });

  final double animValue;
  final AnimationStatus status;
  final Color color;
  final Color backgroundColor;
  final AlignmentGeometry beginAngle;
  final AlignmentGeometry endAngle;

  @override
  RenderObject createRenderObject(BuildContext context) {
    final tRender = TransitionRender(
        animValue, status, color, backgroundColor, beginAngle, endAngle);

    updateRenderObject(context, tRender);

    return tRender;
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant TransitionRender renderObject) {
    renderObject
      ..animValue = animValue
      ..mainColor = color
      ..status = status
      ..backgroundColor = backgroundColor
      ..beginAngle = beginAngle
      ..endAngle = endAngle;
  }
}

class TransitionRender extends RenderProxyBox {
  TransitionRender(
    this._animValue,
    this.status,
    this.mainColor,
    this.backgroundColor,
    this.beginAngle,
    this.endAngle,
  );

  double _animValue;
  AnimationStatus status;
  Color mainColor;
  Color backgroundColor;
  AlignmentGeometry beginAngle;
  AlignmentGeometry endAngle;

  set animValue(newVal) {
    if (newVal != _animValue) {
      _animValue = newVal;
      markNeedsPaint();
    }
  }

  double get animValue => _animValue;

  @override
  void paint(PaintingContext context, Offset offset) {
    final rect = offset & size;
    context.canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          colors: [
            mainColor, mainColor, //
            backgroundColor, backgroundColor,
            mainColor, mainColor,
          ],
          begin: beginAngle,
          end: endAngle,
          stops: [
            0,
            (.5 * animValue),
            (.5 * animValue),
            (1 - .5 * animValue),
            (1 - .5 * animValue),
            1,
          ],
        ).createShader(rect),
    );

    context.paintChild(child!, offset);
  }
}
