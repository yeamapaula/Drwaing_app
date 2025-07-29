import 'package:flutter/material.dart';

enum ToolType { pencil, eraser }

class DrawingPoint {
  final Offset point;
  final Paint paint;

  DrawingPoint({required this.point, required this.paint});
}

class DrawingStroke {
  final List<DrawingPoint> points;
  final ToolType tool;
  final Color color;
  final double strokeWidth;

  DrawingStroke({
    required this.points,
    required this.tool,
    required this.color,
    required this.strokeWidth,
  });
}
