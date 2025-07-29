import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../models/drawing_models.dart';

class DrawingToolbar extends StatelessWidget {
  final ToolType selectedTool;
  final ValueChanged<ToolType> onToolChanged;
  final Color selectedColor;
  final ValueChanged<Color> onColorChanged;
  final double strokeWidth;
  final ValueChanged<double> onStrokeWidthChanged;

  const DrawingToolbar({
    super.key,
    required this.selectedTool,
    required this.onToolChanged,
    required this.selectedColor,
    required this.onColorChanged,
    required this.strokeWidth,
    required this.onStrokeWidthChanged,
  });

  void _showColorPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        Color pickerColor = selectedColor;
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: pickerColor,
              onColorChanged: (color) => pickerColor = color,
              showLabel: true,
              pickerAreaHeightPercent: 0.7,
            ),
          ),
          actions: [
            ElevatedButton(
              child: const Text('Select'),
              onPressed: () {
                onColorChanged(pickerColor);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.create,
                color: selectedTool == ToolType.pencil ? Colors.blue : Colors.black),
            onPressed: () => onToolChanged(ToolType.pencil),
            tooltip: 'Pencil',
          ),
          IconButton(
            icon: Icon(Icons.edit,
                color: selectedTool == ToolType.eraser ? Colors.blue : Colors.black),
            onPressed: () => onToolChanged(ToolType.eraser),
            tooltip: 'Eraser',
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () => _showColorPicker(context),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: selectedColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Slider(
              min: 1,
              max: 10,
              value: strokeWidth,
              onChanged: onStrokeWidthChanged,
              label: strokeWidth.toStringAsFixed(1),
            ),
          ),
        ],
      ),
    );
  }
}
