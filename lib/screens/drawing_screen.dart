import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../models/drawing_models.dart';
import '../widgets/drawing_canvas.dart';
import '../widgets/drawing_toolbar.dart';

class DrawingScreen extends StatefulWidget {
  const DrawingScreen({super.key});

  @override
  State<DrawingScreen> createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {
  ToolType selectedTool = ToolType.pencil;
  Color selectedColor = Colors.black;
  double strokeWidth = 4.0;
  List<DrawingStroke> strokes = [];

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    final dir = Directory('${directory.path}/drawings');
    if (!await dir.exists()) {
      await dir.create();
    }
    return dir.path;
  }

  Future<File> _localFile(String fileName) async {
    final path = await _localPath;
    return File('$path/$fileName.json');
  }

  String _generateFileName() {
    final now = DateTime.now();
    return 'drawing_${now.millisecondsSinceEpoch}';
  }

  void _saveDrawing() async {
    final fileName = _generateFileName();
    final file = await _localFile(fileName);

    // Serialize the strokes to JSON
    final jsonStrokes = strokes
        .map((stroke) => {
              'tool': stroke.tool.toString(),
              'color': stroke.color.value,
              'strokeWidth': stroke.strokeWidth,
              'points': stroke.points
                  .map((p) => {'x': p.point.dx, 'y': p.point.dy})
                  .toList(),
            })
        .toList();

    await file.writeAsString(jsonEncode(jsonStrokes));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Drawing saved successfully!')),
    );
  }

  void _onStrokesChanged(List<DrawingStroke> updatedStrokes) {
    strokes = updatedStrokes;
  }

  void _clearCanvas() {
    setState(() {
      strokes.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Draw Here'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Clear Canvas',
            onPressed: () {
              _clearCanvas();
            },
          ),
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Save Drawing',
            onPressed: () {
              if (strokes.isNotEmpty) {
                _saveDrawing();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Nothing to save!')),
                );
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: DrawingCanvas(
              selectedTool: selectedTool,
              selectedColor: selectedColor,
              strokeWidth: strokeWidth,
              onChanged: _onStrokesChanged,
              initialStrokes: strokes,
            ),
          ),
          DrawingToolbar(
            selectedTool: selectedTool,
            onToolChanged: (tool) {
              setState(() {
                selectedTool = tool;
              });
            },
            selectedColor: selectedColor,
            onColorChanged: (color) {
              setState(() {
                selectedColor = color;
              });
            },
            strokeWidth: strokeWidth,
            onStrokeWidthChanged: (width) {
              setState(() {
                strokeWidth = width;
              });
            },
          ),
        ],
      ),
    );
  }
}
