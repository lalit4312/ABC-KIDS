import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class AlphabetLearningPage extends StatefulWidget {
  const AlphabetLearningPage({super.key});

  @override
  _AlphabetLearningPageState createState() => _AlphabetLearningPageState();
}

class _AlphabetLearningPageState extends State<AlphabetLearningPage>
    with SingleTickerProviderStateMixin {
  // Animation controller
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late AudioPlayer _audioPlayer;

  int currentLetterIndex = 0;
  final List<Map<String, dynamic>> letters = [
    {'letter': 'A', 'word': 'Apple', 'color': Colors.red, 'emoji': '🍎'},
    {'letter': 'B', 'word': 'Ball', 'color': Colors.blue, 'emoji': '⚽'},
    {'letter': 'C', 'word': 'Cat', 'color': Colors.orange, 'emoji': '🐱'},
    {'letter': 'D', 'word': 'Dog', 'color': Colors.brown, 'emoji': '🐶'},
    {'letter': 'E', 'word': 'Elephant', 'color': Colors.grey, 'emoji': '🐘'},
    {'letter': 'F', 'word': 'Fish', 'color': Colors.green, 'emoji': '🐠'},
    {'letter': 'G', 'word': 'Giraffe', 'color': Colors.amber, 'emoji': '🦒'},
    {'letter': 'H', 'word': 'Hen', 'color': Colors.indigo, 'emoji': '🐔'},
    {'letter': 'I', 'word': 'Ice Cream', 'color': Colors.pink, 'emoji': '🍦'},
    {'letter': 'J', 'word': 'Jug', 'color': Colors.deepPurple, 'emoji': '🪣'},
    {'letter': 'K', 'word': 'Kite', 'color': Colors.cyan, 'emoji': '🪁'},
    {'letter': 'L', 'word': 'Lion', 'color': Colors.amber, 'emoji': '🦁'},
    {'letter': 'M', 'word': 'Monkey', 'color': Colors.brown, 'emoji': '🐵'},
    {'letter': 'N', 'word': 'Nose', 'color': Colors.teal, 'emoji': '👃'},
    {'letter': 'O', 'word': 'Orange', 'color': Colors.orange, 'emoji': '🍊'},
    {'letter': 'P', 'word': 'Parrot', 'color': Colors.green, 'emoji': '🦜'},
    {'letter': 'Q', 'word': 'Queen', 'color': Colors.purple, 'emoji': '👑'},
    {'letter': 'R', 'word': 'Rabbit', 'color': Colors.grey, 'emoji': '🐰'},
    {'letter': 'S', 'word': 'Sun', 'color': Colors.amber, 'emoji': '☀️'},
    {'letter': 'T', 'word': 'Tiger', 'color': Colors.deepOrange, 'emoji': '🐯'},
    {'letter': 'U', 'word': 'Umbrella', 'color': Colors.pink, 'emoji': '☂️'},
    {'letter': 'V', 'word': 'Van', 'color': Colors.redAccent, 'emoji': '🚐'},
    {'letter': 'W', 'word': 'Watch', 'color': Colors.lightGreen, 'emoji': '⌚'},
    {
      'letter': 'X',
      'word': 'X-Ray',
      'color': Colors.deepPurpleAccent,
      'emoji': '🩻',
    },
    {
      'letter': 'Y',
      'word': 'Yak',
      'color': Colors.lightBlueAccent,
      'emoji': '🐂',
    },
    {'letter': 'Z', 'word': 'Zebra', 'color': Colors.black87, 'emoji': '🦓'},
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _audioPlayer = AudioPlayer();

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.05,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playLetterSound() async {
    String letter = letters[currentLetterIndex]['letter'].toLowerCase();
    String audioPath = 'audio/$letter.mp3';
    await _audioPlayer.setPlaybackRate(0.6);

    try {
      await _audioPlayer.play(AssetSource(audioPath));
    } catch (e) {
      print("Error playing sound: $e");
    }
  }

  void _changeLetterWithAnimation(int newIndex) {
    setState(() {
      currentLetterIndex = newIndex;
    });

    _controller.reset();
    _controller.forward();
    _playLetterSound();
  }

  @override
  Widget build(BuildContext context) {
    final currentLetter = letters[currentLetterIndex];
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[100]!, Colors.purple[50]!],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => {Navigator.pop(context), print("abs")},
                      child: Icon(Icons.arrow_back),
                    ),
                    SizedBox(width: 30),
                    Text(
                      "Learn the Alphabet",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink[400],
                      ),
                    ),
                  ],
                ),
              ),

              // Progress indicator
              Container(
                margin: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Container(
                      width:
                          (screenSize.width - 60) *
                          (currentLetterIndex / (letters.length - 1)),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.pink[300]!, Colors.purple[300]!],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Animated letter and emoji
                      AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _scaleAnimation.value,
                            child: Transform.rotate(
                              angle:
                                  math.sin(_controller.value * math.pi * 10) *
                                  _rotationAnimation.value,
                              child: child,
                            ),
                          );
                        },
                        child: Container(
                          width: 220,
                          height: 220,
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              colors: [
                                currentLetter['color'],
                                Color.lerp(
                                  currentLetter['color'],
                                  Colors.black,
                                  0.3,
                                )!,
                              ],
                              stops: [0.7, 1.0],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Color.alphaBlend(
                                  currentLetter['color'].withOpacity(0.5),
                                  Colors.black26,
                                ),
                                blurRadius: 15,
                                offset: Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Letter
                              Text(
                                currentLetter['letter'],
                                style: TextStyle(
                                  fontSize: 120,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 10,
                                      color: Colors.black38,
                                      offset: Offset(2, 2),
                                    ),
                                  ],
                                ),
                              ),
                              // Emoji (positioned at bottom right)
                              Positioned(
                                right: 20,
                                bottom: 20,
                                child: Text(
                                  currentLetter['emoji'],
                                  style: TextStyle(fontSize: 40),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 30),

                      // Word example with card design
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 15,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              currentLetter['emoji'],
                              style: TextStyle(fontSize: 30),
                            ),
                            SizedBox(width: 15),
                            Text(
                              currentLetter['word'],
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: currentLetter['color'],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Navigation buttons
              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, -5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Previous button
                    ElevatedButton(
                      onPressed: () {
                        int newIndex =
                            currentLetterIndex > 0
                                ? currentLetterIndex - 1
                                : letters.length - 1;
                        _changeLetterWithAnimation(newIndex);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink[100],
                        foregroundColor: Colors.pink[600],
                        padding: EdgeInsets.all(16),
                        shape: CircleBorder(),
                        elevation: 5,
                      ),
                      child: Icon(Icons.arrow_back, size: 32),
                    ),

                    // Sound button
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.pink[400]!, Colors.purple[500]!],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.pink[200]!,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _playLetterSound,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(22),
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: CircleBorder(),
                        ),
                        child: Icon(
                          Icons.volume_up,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    // Next button
                    ElevatedButton(
                      onPressed: () {
                        int newIndex =
                            currentLetterIndex < letters.length - 1
                                ? currentLetterIndex + 1
                                : 0;
                        _changeLetterWithAnimation(newIndex);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink[100],
                        foregroundColor: Colors.pink[600],
                        padding: EdgeInsets.all(16),
                        shape: CircleBorder(),
                        elevation: 5,
                      ),
                      child: Icon(Icons.arrow_forward, size: 32),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
