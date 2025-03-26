import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter_animate/flutter_animate.dart';

// Number Recognition Activity (Unchanged)
class NumberRecognitionActivity extends StatefulWidget {
  const NumberRecognitionActivity({super.key});

  @override
  _NumberRecognitionActivityState createState() =>
      _NumberRecognitionActivityState();
}

class _NumberRecognitionActivityState extends State<NumberRecognitionActivity> {
  int targetNumber = 0;
  List<int> options = [];
  int score = 0;
  int lives = 3;
  final Duration animationDuration = Duration(milliseconds: 300);

  @override
  void initState() {
    super.initState();
    generateChallenge();
  }

  void generateChallenge() {
    final random = Random();
    setState(() {
      targetNumber = random.nextInt(10) + 1;

      // Create list of options including correct answer
      options = List.generate(4, (_) => random.nextInt(10) + 1);
      if (!options.contains(targetNumber)) {
        options[random.nextInt(4)] = targetNumber;
      }
      options.shuffle();
    });
  }

  void checkAnswer(int selectedNumber) {
    if (selectedNumber == targetNumber) {
      setState(() {
        score++;
        generateChallenge();
      });
    } else {
      setState(() {
        lives--;
        if (lives <= 0) {
          _showGameOverDialog();
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Incorrect! The right number was $targetNumber',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red[400],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            'Game Over',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple[700],
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Your Final Score:',
                style: TextStyle(fontSize: 18, color: Colors.grey[700]),
              ),
              SizedBox(height: 10),
              Text(
                '$score',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple[500],
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Restart',
                style: TextStyle(
                  color: Colors.deepPurple[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  score = 0;
                  lives = 3;
                  generateChallenge();
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isNarrow = constraints.maxWidth < 600;

        return Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            title: Text(
              'Number Recognition Challenge',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.deepPurple[400],
            elevation: 0,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Row(
                  children: List.generate(
                    lives,
                    (index) => Icon(Icons.favorite, color: Colors.pink[200]),
                  ),
                ),
              ),
            ],
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ZoomIn(
                          child: Text(
                            'Tap the Number: $targetNumber',
                            style: TextStyle(
                              fontSize: isNarrow ? 20 : 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.deepPurple[700],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Score: $score',
                          style: TextStyle(
                            fontSize: isNarrow ? 18 : 22,
                            fontWeight: FontWeight.w500,
                            color: Colors.deepPurple[600],
                          ),
                        ),
                        SizedBox(height: 30),
                        Wrap(
                          spacing: 15,
                          runSpacing: 15,
                          alignment: WrapAlignment.center,
                          children:
                              options.map((number) {
                                return ElasticIn(
                                  child: ElevatedButton(
                                    onPressed: () => checkAnswer(number),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.deepPurple[100],
                                      minimumSize: Size(
                                        isNarrow ? 100 : 120,
                                        isNarrow ? 80 : 100,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 3,
                                    ),
                                    child: Text(
                                      number.toString(),
                                      style: TextStyle(
                                        fontSize: isNarrow ? 22 : 28,
                                        color: Colors.deepPurple[800],
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                );
                              }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Corrected Math Operations Activity
class MathOperationsActivity extends StatefulWidget {
  const MathOperationsActivity({super.key});

  @override
  _MathOperationsActivityState createState() => _MathOperationsActivityState();
}

class _MathOperationsActivityState extends State<MathOperationsActivity> {
  int num1 = 0;
  int num2 = 0;
  String operation = '+';
  int correctAnswer = 0;
  List<int> options = [];
  int score = 0;
  bool? _lastAnswerCorrect;

  @override
  void initState() {
    super.initState();
    generateProblem();
  }

  void generateProblem() {
    final random = Random();

    // Randomly choose between addition and subtraction
    operation = random.nextBool() ? '+' : '-';

    // Vary difficulty based on operation
    if (operation == '+') {
      num1 = random.nextInt(20) + 1;
      num2 = random.nextInt(20) + 1;
      correctAnswer = num1 + num2;
    } else {
      // Ensure no negative results
      num1 = random.nextInt(20) + 10;
      num2 = random.nextInt(num1);
      correctAnswer = num1 - num2;
    }

    // Generate multiple choice options
    options = [correctAnswer];
    while (options.length < 4) {
      int wrongAnswer;
      if (operation == '+') {
        wrongAnswer = correctAnswer + random.nextInt(10) - 5;
      } else {
        wrongAnswer = correctAnswer + random.nextInt(10) - 5;
      }

      if (!options.contains(wrongAnswer) && wrongAnswer >= 0) {
        options.add(wrongAnswer);
      }
    }
    options.shuffle();

    // Reset last answer state
    _lastAnswerCorrect = null;
  }

  void checkAnswer(int selectedAnswer) {
    setState(() {
      if (selectedAnswer == correctAnswer) {
        score++; // Increment score if the answer is correct
        _lastAnswerCorrect = true;
      } else {
        _lastAnswerCorrect = false;
      }
    });

    // Delay to show feedback (Correct! or Oops!) before generating the next question
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        generateProblem(); // Generates the next problem after the delay
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Math Wizard',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple[400],
        elevation: 0,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Score Display
              Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple[50],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Score: $score',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple[800],
                      ),
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 500.ms)
                  .slide(begin: const Offset(0, -0.5)),

              const SizedBox(height: 30),

              // Math Problem
              Text(
                '$num1 $operation $num2 = ?',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  color: Colors.deepPurple[700],
                ),
              ).animate().scale(duration: 300.ms),

              const SizedBox(height: 30),

              // Answer Options
              Wrap(
                spacing: 15,
                runSpacing: 15,
                children:
                    options
                        .map(
                          (answer) => ElevatedButton(
                                onPressed: () => checkAnswer(answer),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _getButtonColor(answer),
                                  minimumSize: const Size(100, 100),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  elevation: 5,
                                ),
                                child: Text(
                                  answer.toString(),
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                              .animate(key: ValueKey(answer))
                              .shimmer(delay: 300.ms, duration: 800.ms)
                              .shake(delay: 300.ms),
                        )
                        .toList(),
              ),

              // Feedback Area
              if (_lastAnswerCorrect != null)
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color:
                        _lastAnswerCorrect!
                            ? Colors.green[100]
                            : Colors.red[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _lastAnswerCorrect!
                        ? 'Correct! Great job!'
                        : 'Oops! Try again.',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color:
                          _lastAnswerCorrect!
                              ? Colors.green[800]
                              : Colors.red[800],
                    ),
                  ),
                ).animate().fadeIn().slide(begin: const Offset(0, 0.5)),
            ],
          ),
        ),
      ),
    );
  }

  Color _getButtonColor(int answer) {
    if (_lastAnswerCorrect == null) {
      return Colors.deepPurple[300]!;
    }

    if (answer == correctAnswer) {
      return _lastAnswerCorrect! ? Colors.green[500]! : Colors.deepPurple[300]!;
    }

    return _lastAnswerCorrect! ? Colors.deepPurple[300]! : Colors.red[500]!;
  }
}

// Corrected Shape and Pattern Recognition
class ShapePatternActivity extends StatefulWidget {
  const ShapePatternActivity({super.key});

  @override
  _ShapePatternActivityState createState() => _ShapePatternActivityState();
}

class _ShapePatternActivityState extends State<ShapePatternActivity> {
  List<Color> pattern = [];
  List<Color> availableColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
  ];
  List<Color> selectedColors = [];
  int score = 0;

  @override
  void initState() {
    super.initState();
    generatePattern();
  }

  void generatePattern() {
    final random = Random();
    pattern = List.generate(
      4,
      (_) => availableColors[random.nextInt(availableColors.length)],
    );
    selectedColors = []; // Reset selected colors
  }

  void selectColor(Color color) {
    setState(() {
      selectedColors.add(color);

      // Check pattern when 4 colors are selected
      if (selectedColors.length == 4) {
        checkPattern();
      }
    });
  }

  void checkPattern() {
    if (selectedColors.toString() == pattern.toString()) {
      setState(() {
        score++;
        generatePattern();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Incorrect pattern. Try again!'),
          backgroundColor: Colors.red,
        ),
      );
      // Reset selected colors if incorrect
      selectedColors = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shape & Pattern'),
        backgroundColor: Colors.orange[300],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Repeat the Pattern',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // Show the pattern to remember
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
                  pattern
                      .map(
                        (color) => Container(
                          width: 50,
                          height: 50,
                          margin: EdgeInsets.all(5),
                          color: color,
                        ),
                      )
                      .toList(),
            ),
            SizedBox(height: 20),
            // Show selected colors
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
                  selectedColors
                      .map(
                        (color) => Container(
                          width: 50,
                          height: 50,
                          margin: EdgeInsets.all(5),
                          color: color,
                        ),
                      )
                      .toList(),
            ),
            SizedBox(height: 20),
            Text('Score: $score', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            // Color selection buttons
            Wrap(
              spacing: 10,
              children:
                  availableColors
                      .map(
                        (color) => ElevatedButton(
                          onPressed: () {
                            if (selectedColors.length < 4) {
                              selectColor(color);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(80, 80),
                            backgroundColor: Colors.white,
                            padding: EdgeInsets.all(0),
                          ),
                          child: Container(width: 50, height: 50, color: color),
                        ),
                      )
                      .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// Measurement and Comparison Activity (Unchanged)
class MeasurementActivity extends StatefulWidget {
  const MeasurementActivity({super.key});

  @override
  _MeasurementActivityState createState() => _MeasurementActivityState();
}

class _MeasurementActivityState extends State<MeasurementActivity> {
  final List<String> measurementOptions = ['🐭', '🐘', '🐍', '🐜', '🦏', '🦠'];
  String targetMeasurement = '';
  List<String> visualOptions = [];
  int score = 0;

  @override
  void initState() {
    super.initState();
    generateChallenge();
  }

  void generateChallenge() {
    final random = Random();
    setState(() {
      targetMeasurement =
          measurementOptions[random.nextInt(measurementOptions.length)];

      // Create visual options with the target measurement
      visualOptions = List.generate(
        4,
        (_) => measurementOptions[random.nextInt(measurementOptions.length)],
      );
      if (!visualOptions.contains(targetMeasurement)) {
        visualOptions[random.nextInt(4)] = targetMeasurement;
      }
      visualOptions.shuffle();
    });
  }

  void checkAnswer(String selectedMeasurement) {
    if (selectedMeasurement == targetMeasurement) {
      setState(() {
        score++;
        generateChallenge();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Incorrect. The right measurement was $targetMeasurement',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red[400],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Determine responsive layout based on screen width
        bool isNarrow = constraints.maxWidth < 600;

        return Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            title: Text(
              'Measurement Challenge',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.deepPurple[400],
            elevation: 0,
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Select the $targetMeasurement Object',
                          style: TextStyle(
                            fontSize: isNarrow ? 20 : 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.deepPurple[700],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Score: $score',
                          style: TextStyle(
                            fontSize: isNarrow ? 18 : 22,
                            fontWeight: FontWeight.w500,
                            color: Colors.deepPurple[600],
                          ),
                        ),
                        SizedBox(height: 30),
                        Wrap(
                          spacing: 15,
                          runSpacing: 15,
                          alignment: WrapAlignment.center,
                          children:
                              visualOptions.map((measurement) {
                                return ElevatedButton(
                                  onPressed: () => checkAnswer(measurement),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepPurple[100],
                                    minimumSize: Size(
                                      isNarrow ? 100 : 120,
                                      isNarrow ? 80 : 100,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 3,
                                  ),
                                  child: Text(
                                    measurement,
                                    style: TextStyle(
                                      fontSize: isNarrow ? 22 : 28,
                                      color: Colors.deepPurple[800],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                );
                              }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Main Learning Activities Screen (Unchanged)
class LearningActivitiesScreen extends StatelessWidget {
  const LearningActivitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Learning Activities'),
        backgroundColor: Colors.deepPurple,
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(16),
        children: [
          _buildActivityCard(
            context,
            'Number Recognition',
            Icons.book,
            Colors.blue,
            NumberRecognitionActivity(),
          ),
          _buildActivityCard(
            context,
            'Math Operations',
            Icons.calculate,
            Colors.green,
            MathOperationsActivity(),
          ),
          _buildActivityCard(
            context,
            'Shape & Pattern',
            Icons.style,
            Colors.orange,
            ShapePatternActivity(),
          ),
          _buildActivityCard(
            context,
            'Measurement',
            Icons.straighten,
            Colors.purple,
            MeasurementActivity(),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    Widget activityScreen,
  ) {
    return Card(
      color: color,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => activityScreen),
          );
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: Colors.white),
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
