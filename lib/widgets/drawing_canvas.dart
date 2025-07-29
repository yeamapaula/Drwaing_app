import 'package:flutter/material.dart';
import '../models/drawing_models.dart';

class DrawingCanvas extends StatefulWidget {
  final ToolType selectedTool;
  final Color selectedColor;
  final double strokeWidth;
  final Function(List<DrawingStroke>)? onChanged;
  final List<DrawingStroke> initialStrokes;

  const DrawingCanvas({
    super.key,
    required this.selectedTool,
    required this.selectedColor,
    required this.strokeWidth,
    this.onChanged,
    this.initialStrokes = const [],
  });

  @override
  State<DrawingCanvas> createState() => _DrawingCanvasState();
}

class _DrawingCanvasState extends State<DrawingCanvas> {
  List<DrawingStroke> strokes = [];
  List<DrawingPoint> currentPoints = [];

  @override
  void initState() {
    super.initState();
    strokes = List.from(widget.initialStrokes);
  }

  void startStroke(Offset point) {
    final paint = Paint()
      ..color = widget.selectedTool == ToolType.eraser ? Colors.white : widget.selectedColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = widget.strokeWidth
      ..isAntiAlias = true;

    currentPoints = [DrawingPoint(point: point, paint: paint)];
    strokes.add(DrawingStroke(
      points: currentPoints,
      tool: widget.selectedTool,
      color: paint.color,
      strokeWidth: widget.strokeWidth,
    ));
  }

  void appendStroke(Offset point) {
    final paint = Paint()
      ..color = widget.selectedTool == ToolType.eraser ? Colors.white : widget.selectedColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = widget.strokeWidth
      ..isAntiAlias = true;

    setState(() {
      currentPoints.add(DrawingPoint(point: point, paint: paint));
    });
    widget.onChanged?.call(strokes);
  }

  void endStroke() {
    currentPoints = [];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        RenderBox box = context.findRenderObject() as RenderBox;
        final point = box.globalToLocal(details.globalPosition);
        startStroke(point);
        setState(() {});
      },
      onPanUpdate: (details) {
        RenderBox box = context.findRenderObject() as RenderBox;
        final point = box.globalToLocal(details.globalPosition);
        appendStroke(point);
      },
      onPanEnd: (details) {
        endStroke();
      },
      child: CustomPaint(
        size: Size.infinite,
        painter: _DrawingPainter(strokes: strokes),
      ),
    );
  }
}

class _DrawingPainter extends CustomPainter {
  final List<DrawingStroke> strokes;

  _DrawingPainter({required this.strokes});

  @override
  void paint(Canvas canvas, Size size) {
    for (var stroke in strokes) {
      for (int i = 0; i < stroke.points.length - 1; i++) {
        if (stroke.points[i + 1] != null) {
          canvas.drawLine(
            stroke.points[i].point,
            stroke.points[i + 1].point,
            stroke.points[i].paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DrawingPainter oldDelegate) => true;
}
