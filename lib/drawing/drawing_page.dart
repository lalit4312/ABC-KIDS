import 'dart:ui';
import 'package:flutter/material.dart';

class DrawingPage extends StatefulWidget {
  @override
  _DrawingPageState createState() => _DrawingPageState();
}

class _DrawingPageState extends State<DrawingPage> {
  List<DrawingPoint> points = [];
  Color selectedColor = Colors.black;
  double strokeWidth = 5.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Sketch Pad',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.delete_outline),
            onPressed: () {
              setState(() {
                points.clear();
              });
            },
            tooltip: 'Clear Canvas',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    points.add(
                      DrawingPoint(
                        point: details.localPosition,
                        paint:
                            Paint()
                              ..color = selectedColor
                              ..strokeCap = StrokeCap.round
                              ..strokeWidth = strokeWidth,
                      ),
                    );
                  });
                },
                onPanEnd: (_) {
                  setState(() {
                    points.add(DrawingPoint(point: null));
                  });
                },
                child: CustomPaint(
                  painter: DrawingPainter(points),
                  child: Container(),
                ),
              ),
            ),
          ),
          _buildToolbar(),
        ],
      ),
    );
  }

  Widget _buildToolbar() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _colorSelector(Colors.black),
          _colorSelector(Colors.red),
          _colorSelector(Colors.blue),
          _colorSelector(Colors.green),
          _strokeWidthSelector(),
        ],
      ),
    );
  }

  Widget _colorSelector(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = color;
        });
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: selectedColor == color ? Colors.white : Colors.transparent,
            width: 3,
          ),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
        ),
      ),
    );
  }

  Widget _strokeWidthSelector() {
    return PopupMenuButton<double>(
      icon: Icon(Icons.brush, color: Colors.deepPurple),
      onSelected: (value) {
        setState(() {
          strokeWidth = value;
        });
      },
      itemBuilder:
          (context) => [
            PopupMenuItem(value: 2.0, child: Text('Thin')),
            PopupMenuItem(value: 5.0, child: Text('Medium')),
            PopupMenuItem(value: 10.0, child: Text('Thick')),
          ],
    );
  }
}

class DrawingPoint {
  Offset? point;
  Paint? paint;

  DrawingPoint({this.point, this.paint});
}

class DrawingPainter extends CustomPainter {
  final List<DrawingPoint> points;

  DrawingPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i].point != null && points[i + 1].point != null) {
        canvas.drawLine(
          points[i].point!,
          points[i + 1].point!,
          points[i].paint!,
        );
      } else if (points[i].point != null && points[i + 1].point == null) {
        canvas.drawPoints(PointMode.points, [
          points[i].point!,
        ], points[i].paint!);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
