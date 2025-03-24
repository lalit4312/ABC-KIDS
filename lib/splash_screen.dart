import 'package:alphabet_learning_app/home_page.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Main title animation
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  // Subtitle animation
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  // Character animations
  late AnimationController _charactersController;
  late Animation<double> _charactersAnimation;

  // Rotating stars animation
  late AnimationController _rotateController;

  // Bouncing animation
  late AnimationController _bounceController;
  late Animation<Offset> _bounceAnimation;

  @override
  void initState() {
    super.initState();

    // Scale animation for the main title
    _scaleController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1200),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    );

    // Fade animation for subtitle
    _fadeController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    // Character animations
    _charactersController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2500),
    );
    _charactersAnimation = CurvedAnimation(
      parent: _charactersController,
      curve: Curves.elasticInOut,
    );

    // Rotating animation for stars
    _rotateController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    )..repeat();

    // Bouncing animation for the rocket
    _bounceController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat(reverse: true);

    _bounceAnimation = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(0, -0.1),
    ).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );

    // Start animations in sequence
    _scaleController.forward();

    Future.delayed(Duration(milliseconds: 400), () {
      _fadeController.forward();
    });

    Future.delayed(Duration(milliseconds: 800), () {
      _charactersController.forward();
    });

    // Navigate to home page after 3.5 seconds
    Future.delayed(Duration(milliseconds: 3500), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => HomePage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var tween = Tween(
              begin: 0.0,
              end: 1.0,
            ).chain(CurveTween(curve: Curves.easeInOut));
            return FadeTransition(
              opacity: animation.drive(tween),
              child: child,
            );
          },
          transitionDuration: Duration(milliseconds: 500),
        ),
      );
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _fadeController.dispose();
    _charactersController.dispose();
    _rotateController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF9CECFB), Color(0xFF65C7F7), Color(0xFF0052D4)],
          ),
        ),
        child: Stack(
          children: [
            // Background animated stars
            ...List.generate(10, (index) {
              final random = math.Random();
              final size = random.nextDouble() * 20 + 10;
              final left =
                  random.nextDouble() * MediaQuery.of(context).size.width;
              final top =
                  random.nextDouble() * MediaQuery.of(context).size.height;
              final angle = random.nextDouble() * 360;

              return Positioned(
                left: left,
                top: top,
                child: AnimatedBuilder(
                  animation: _rotateController,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _rotateController.value * 2 * math.pi + angle,
                      child: Icon(
                        Icons.star,
                        size: size,
                        color: Colors.yellow.withOpacity(0.7),
                      ),
                    );
                  },
                ),
              );
            }),

            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Main App Logo/Title
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: Text(
                      "ABC's",
                      style: TextStyle(
                        fontSize: 72,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Fredoka One',
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.purple.shade800,
                            offset: Offset(3, 3),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  // App Tagline with fade-in animation
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Text(
                      "Fun Learning Adventure!",
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                        shadows: [
                          Shadow(
                            color: Colors.black38,
                            offset: Offset(1, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 40),

                  // Animated alphabets
                  SizeTransition(
                    sizeFactor: _charactersAnimation,
                    axis: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (int i = 0; i < 5; i++)
                          TweenAnimationBuilder(
                            tween: Tween<double>(begin: 0, end: 1),
                            duration: Duration(milliseconds: 800 + (i * 200)),
                            builder: (context, double value, child) {
                              return Transform.translate(
                                offset: Offset(
                                  0,
                                  20 * math.sin(value * math.pi),
                                ),
                                child: Opacity(
                                  opacity: value,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 6,
                                    ),
                                    child: Container(
                                      width: 45,
                                      height: 45,
                                      decoration: BoxDecoration(
                                        color:
                                            [
                                              Colors.red,
                                              Colors.green,
                                              Colors.blue,
                                              Colors.orange,
                                              Colors.purple,
                                            ][i],
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 4,
                                            offset: Offset(2, 2),
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Text(
                                          String.fromCharCode(65 + i),
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),

                  SizedBox(height: 50),

                  // Rocket animation
                  SlideTransition(
                    position: _bounceAnimation,
                    child: Icon(
                      Icons.rocket_launch,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),

                  SizedBox(height: 30),

                  // Loading indicator
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
