import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DrawingApp(),
    );
  }
}

class DrawingApp extends StatefulWidget {
  @override
  _DrawingAppState createState() => _DrawingAppState();
}

class _DrawingAppState extends State<DrawingApp> {
  List<List<Offset>> lines = []; // Use a list of lists for each line

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Drawing App'),
      ),
      body: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            RenderBox renderBox = context.findRenderObject() as RenderBox;
            final localPosition =
                renderBox.globalToLocal(details.globalPosition);
            if (lines.isEmpty || lines.last.isEmpty) {
              lines.add([localPosition]);
            } else {
              lines.last.add(localPosition);
            }
          });
        },
        onPanEnd: (_) {
          setState(() {
            lines.add([]);
          });
        },
        child: CustomPaint(
          painter: MyPainter(lines),
          size: Size.infinite,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            lines.clear();
          });
        },
        child: Icon(Icons.clear),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  final List<List<Offset>> lines;
  MyPainter(this.lines);

  @override
  void paint(Canvas canvas, Size size) {

    Paint paint = Paint()
      ..color = Colors.yellow
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;
    final smilePaint = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;
    //first face
    final center = Offset(size.width / 3, size.height / 3);
    final radius = min(size.width/2, size.height/2) / 2;
    canvas.drawCircle(center, radius, paint);
    
    canvas.drawArc(Rect.fromCircle(center: center,radius: radius/1.5), 0, pi, false, smilePaint);
    canvas.drawCircle(Offset(center.dx -radius/2,center.dy-radius/2), 20, smilePaint);
    canvas.drawCircle(Offset(center.dx +radius/2,center.dy-radius/2), 20, smilePaint);
  
    //second face
    final center2 = Offset(size.width /3*2, size.height/3*2);
    final radius2 = min(size.width/2, size.height/2) / 2;
    canvas.drawCircle(center2, radius2, paint);

    canvas.drawArc(Rect.fromCircle(center: center2,radius: radius2/1.5), 0, pi, false, smilePaint);
    canvas.drawCircle(Offset(center2.dx -radius2/2,center2.dy-radius2/2), 20, smilePaint);
    canvas.drawCircle(Offset(center2.dx +radius2/2,center2.dy-radius2/2), 20, smilePaint);

    // hat
    final trianglePath = Path()
      ..moveTo(center2.dx, center2.dy - radius2 * 1.5)
      ..lineTo(center2.dx - radius2 / 2, center2.dy - radius2/1.2)
      ..lineTo(center2.dx + radius2 / 2, center2.dy - radius2/1.2)
      ..close();
    canvas.drawPath(trianglePath, smilePaint);
    
    for (final line in lines) {
      for (int i = 0; i < line.length - 1; i++) {
        canvas.drawLine(line[i], line[i + 1], paint);
      
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
