import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../models/drawing_models.dart';
import '../widgets/drawing_canvas.dart';

class SavedDrawingsScreen extends StatefulWidget {
  const SavedDrawingsScreen({super.key});

  @override
  State<SavedDrawingsScreen> createState() => _SavedDrawingsScreenState();
}

class _SavedDrawingsScreenState extends State<SavedDrawingsScreen> {
  List<FileSystemEntity> drawingFiles = [];

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/drawings';
  }

  Future<void> _loadDrawingFiles() async {
    final path = await _localPath;
    final dir = Directory(path);
    if (!await dir.exists()) {
      await dir.create();
    }
    setState(() {
      drawingFiles = dir.listSync().where((file) => file.path.endsWith('.json')).toList();
    });
  }

  Future<List<DrawingStroke>> _loadDrawingFromFile(File file) async {
    final content = await file.readAsString();
    final List<dynamic> jsonData = jsonDecode(content);

    List<DrawingStroke> strokes = [];

    for (var strokeJson in jsonData) {
      ToolType tool = strokeJson['tool'] == 'ToolType.eraser' ? ToolType.eraser : ToolType.pencil;
      Color color = Color(strokeJson['color']);
      double strokeWidth = strokeJson['strokeWidth'].toDouble();

      List<DrawingPoint> points = [];
      for (var pointJson in strokeJson['points']) {
        points.add(DrawingPoint(
          point: Offset(pointJson['x'], pointJson['y']),
          paint: Paint()
            ..color = tool == ToolType.eraser ? Colors.white : color
            ..strokeWidth = strokeWidth
            ..strokeCap = StrokeCap.round,
        ));
      }

      strokes.add(DrawingStroke(
        points: points,
        tool: tool,
        color: color,
        strokeWidth: strokeWidth,
      ));
    }
    return strokes;
  }

  @override
  void initState() {
    super.initState();
    _loadDrawingFiles();
  }

  void _openDrawing(File file) async {
    List<DrawingStroke> strokes = await _loadDrawingFromFile(file);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ViewDrawingScreen(strokes: strokes),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Drawings'),
      ),
      body: drawingFiles.isEmpty
          ? const Center(child: Text('No saved drawings found.'))
          : ListView.builder(
              itemCount: drawingFiles.length,
              itemBuilder: (context, index) {
                final file = drawingFiles[index];
                final name = file.path.split('/').last;
                return ListTile(
                  leading: const Icon(Icons.image),
                  title: Text(name),
                  onTap: () => _openDrawing(File(file.path)),
                );
              },
            ),
    );
  }
}

class ViewDrawingScreen extends StatelessWidget {
  final List<DrawingStroke> strokes;

  const ViewDrawingScreen({super.key, required this.strokes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Drawing'),
      ),
      body: Container(
        color: Colors.white,
        child: CustomPaint(
          painter: _ViewPainter(strokes: strokes),
          child: Container(),
        ),
      ),
    );
  }
}

class _ViewPainter extends CustomPainter {
  final List<DrawingStroke> strokes;

  _ViewPainter({required this.strokes});

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
  bool shouldRepaint(covariant _ViewPainter oldDelegate) => false;
}
