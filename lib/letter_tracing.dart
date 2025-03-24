import 'package:flutter/material.dart';

class LetterTracingPage extends StatefulWidget {
  const LetterTracingPage({super.key});

  @override
  _LetterTracingPageState createState() => _LetterTracingPageState();
}

class _LetterTracingPageState extends State<LetterTracingPage>
    with SingleTickerProviderStateMixin {
  int currentLetterIndex = 0;
  List<Offset?> points = [];
  bool isTracing = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  final List<String> letters = List.generate(
    26,
    (index) => String.fromCharCode(65 + index),
  );

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    )..addListener(() {
      setState(() {});
    });

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _nextLetter() {
    setState(() {
      currentLetterIndex = (currentLetterIndex + 1) % letters.length;
      points.clear();
      _animationController.reset();
      _animationController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF6A4C93),
        elevation: 0,
        title: Text(
          "Letter Tracing",
          style: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      backgroundColor: Color(0xFFF5F7FA),
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30, vertical: 16),
              height: 10,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Flexible(
                    flex: currentLetterIndex + 1,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF6A4C93), Color(0xFF86A8E7)],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: letters.length - currentLetterIndex - 1,
                    child: Container(),
                  ),
                ],
              ),
            ),

            // Instruction Text
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Trace the letter ",
                      style: TextStyle(
                        fontSize: 22,
                        color: Color(0xFF4A4A4A),
                        fontFamily: 'Quicksand',
                      ),
                    ),
                    TextSpan(
                      text: letters[currentLetterIndex],
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6A4C93),
                        fontFamily: 'Quicksand',
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Tracing canvas area
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 15,
                      offset: Offset(0, 5),
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Stack(
                    children: [
                      // Background grid pattern
                      Positioned.fill(
                        child: CustomPaint(painter: GridPainter()),
                      ),

                      // Letter outline with animation
                      Center(
                        child: AnimatedOpacity(
                          opacity: 0.2,
                          duration: Duration(milliseconds: 500),
                          child: Transform.scale(
                            scale: 0.8 + (0.2 * _animation.value),
                            child: Text(
                              letters[currentLetterIndex],
                              style: TextStyle(
                                fontSize: 250,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Comic Sans MS',
                                color: Color(0xFF6A4C93).withOpacity(0.5),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Drawing area
                      GestureDetector(
                        onPanStart: (details) {
                          setState(() {
                            isTracing = true;
                            points.add(details.localPosition);
                          });
                        },
                        onPanUpdate: (details) {
                          setState(() {
                            points.add(details.localPosition);
                          });
                        },
                        onPanEnd: (details) {
                          setState(() {
                            isTracing = false;
                            points.add(null);
                          });
                        },
                        child: CustomPaint(
                          painter: DrawingPainter(points: points),
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                      ),

                      // Overlay indicators for active tracing
                      if (isTracing && points.isNotEmpty && points.last != null)
                        Positioned(
                          left: points.last!.dx - 15,
                          top: points.last!.dy - 15,
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),

            // Controls
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton(
                    icon: Icons.restart_alt,
                    label: "Clear",
                    color: Color(0xFFFF9A8B),
                    onPressed: () {
                      setState(() {
                        points.clear();
                      });
                    },
                  ),
                  _buildActionButton(
                    icon: Icons.arrow_forward,
                    label: "Next",
                    color: Color(0xFF86A8E7),
                    onPressed: _nextLetter,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 24),
      label: Text(
        label,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          fontFamily: 'Quicksand',
        ),
      ),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 3,
      ),
    );
  }
}

// Grid pattern painter
class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint linePaint =
        Paint()
          ..color = Colors.grey.withOpacity(0.2)
          ..strokeWidth = 1.0;

    // Draw horizontal lines
    double spacing = 20.0;
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }

    // Draw vertical lines
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), linePaint);
    }
  }

  @override
  bool shouldRepaint(GridPainter oldDelegate) => false;
}

// Drawing painter for letter tracing with improved visuals
class DrawingPainter extends CustomPainter {
  final List<Offset?> points;

  DrawingPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    // Create paint objects
    final Paint mainPaint =
        Paint()
          ..color = Color(0xFF5B86E5)
          ..strokeWidth = 8.0
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..style = PaintingStyle.stroke;

    // Glow effect paint
    final Paint glowPaint =
        Paint()
          ..color = Color(0xFF5B86E5).withOpacity(0.3)
          ..strokeWidth = 20.0
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..style = PaintingStyle.stroke
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 5);

    // Draw the path segments
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        // Draw glow effect first
        canvas.drawLine(points[i]!, points[i + 1]!, glowPaint);
        // Then draw the main line
        canvas.drawLine(points[i]!, points[i + 1]!, mainPaint);
      } else if (points[i] != null && points[i + 1] == null) {
        // Draw a dot at the end of a stroke
        canvas.drawCircle(points[i]!, 4, mainPaint);
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;
}
