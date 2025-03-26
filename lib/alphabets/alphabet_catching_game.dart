import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/particles.dart';
import 'dart:math';

class AlphabetCatchingGamePage extends StatelessWidget {
  const AlphabetCatchingGamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF4A148C), // Deep Purple
                  Color(0xFF6A1B9A), // Slightly Lighter Purple
                ],
              ),
            ),
          ),
          // Game Widget
          SafeArea(child: GameWidget(game: AlphabetCatchingGame())),
        ],
      ),
    );
  }
}

class AlphabetCatchingGame extends FlameGame
    with HasCollisionDetection, TapDetector {
  late Character character;
  Letter? currentLetter;

  int currentLetterIndex = 0;
  bool isGameOver = false;

  late TextComponent instructionText;
  late TextComponent currentLetterText;

  @override
  Color backgroundColor() => Colors.transparent;

  @override
  Future<void> onLoad() async {
    // Add background
    add(BackgroundComponent());

    // Add character
    character = Character();
    add(character);

    // Add instruction text
    instructionText = TextComponent(
      text: 'Catch Alphabets in Order!',
      textRenderer: TextPaint(
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      position: Vector2(size.x / 2, 50),
      anchor: Anchor.center,
    );
    add(instructionText);

    // Add current letter tracking
    currentLetterText = TextComponent(
      text: 'Next: A',
      textRenderer: TextPaint(
        style: TextStyle(
          color: Colors.white70,
          fontSize: 36,
          fontWeight: FontWeight.w900,
        ),
      ),
      position: Vector2(size.x / 2, 100),
      anchor: Anchor.center,
    );
    add(currentLetterText);

    // Spawn first letter
    spawnNextLetter();
  }

  void spawnNextLetter() {
    // If game is over, don't spawn new letters
    if (isGameOver) return;

    // Remove previous letter if exists
    if (currentLetter != null) {
      remove(currentLetter!);
    }

    // Create new letter
    currentLetter = Letter(
      gameRef: this,
      letter: String.fromCharCode(65 + currentLetterIndex),
      onCaught: () {
        // Correct catch
        currentLetterIndex++;
        currentLetterText.text =
            'Next: ${String.fromCharCode(65 + currentLetterIndex)}';

        // Check if all letters caught
        if (currentLetterIndex >= 26) {
          showWinScreen();
        } else {
          spawnNextLetter();
        }
      },
      onMissed: () {
        gameOver();
      },
    );
    add(currentLetter!);
  }

  void gameOver() {
    if (isGameOver) return;
    isGameOver = true;

    // Remove current game elements
    removeAll(children);

    // Add game over screen
    add(
      GameOverComponent(
        score: currentLetterIndex,
        onRestart: () {
          // Reset game
          isGameOver = false;
          currentLetterIndex = 0;
          onLoad();
        },
      ),
    );
  }

  void showWinScreen() {
    // Remove current game elements
    removeAll(children);

    // Add win screen
    add(
      WinComponent(
        onRestart: () {
          // Reset game
          isGameOver = false;
          currentLetterIndex = 0;
          onLoad();
        },
      ),
    );
  }

  @override
  void onTapDown(TapDownInfo info) {
    if (!isGameOver) {
      character.move(info.eventPosition.global.x);
    }
  }
}

class BackgroundComponent extends Component with HasGameRef {
  @override
  void render(Canvas canvas) {
    // Create starry background
    final paint = Paint()..color = Colors.black.withOpacity(0.2);
    final random = Random();

    for (int i = 0; i < 100; i++) {
      final x = random.nextDouble() * gameRef.size.x;
      final y = random.nextDouble() * gameRef.size.y;
      final radius = random.nextDouble() * 2;

      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }
}

class Character extends SpriteComponent with HasGameRef, DragCallbacks {
  Character() : super(size: Vector2(150, 150));

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('character.png');
    position = Vector2(
      gameRef.size.x / 2 - size.x / 2,
      gameRef.size.y - size.y - 20,
    );
    anchor = Anchor.bottomCenter;
  }

  void move(double targetX) {
    final newX = targetX.clamp(size.x / 2, gameRef.size.x - size.x / 2);
    position.x = newX;
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    move(event.canvasPosition.x);
  }
}

class Letter extends TextComponent with HasGameRef, CollisionCallbacks {
  final String letter;
  final Function onCaught;
  final Function onMissed;
  bool shouldRemove = false;

  Letter({
    required FlameGame gameRef,
    required this.letter,
    required this.onCaught,
    required this.onMissed,
  }) : super(
         text: letter,
         textRenderer: TextPaint(
           style: TextStyle(
             fontSize: 60,
             fontWeight: FontWeight.w900,
             color: Colors.white,
             shadows: [
               Shadow(
                 blurRadius: 10.0,
                 color: Colors.black54,
                 offset: Offset(3.0, 3.0),
               ),
             ],
           ),
         ),
         size: Vector2(80, 80),
       );

  @override
  void onLoad() {
    position = Vector2(Random().nextDouble() * (gameRef.size.x - size.x), 0);
    anchor = Anchor.topCenter;
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y += 200 * dt; // Falling speed

    // Check if letter is missed
    if (position.y > gameRef.size.y) {
      onMissed();
      shouldRemove = true;
    }

    // Check collision with character
    final character = gameRef.children.whereType<Character>().first;
    if (checkCollision(character)) {
      onCaught();
      _addCatchParticles();
      shouldRemove = true;
    }
  }

  void _addCatchParticles() {
    final particle = Particle.generate(
      count: 40,
      generator:
          (i) => AcceleratedParticle(
            speed: Vector2.random() * 300,
            acceleration: Vector2(0, 100),
            position: position.clone(),
            lifespan: 0.7,
            child: CircleParticle(
              radius: 7,
              paint: Paint()..color = Colors.white.withOpacity(0.8),
            ),
          ),
    );

    gameRef.add(ParticleSystemComponent(particle: particle));
  }

  bool checkCollision(Character character) {
    return x < character.x + character.width &&
        x + width > character.x &&
        y < character.y + character.height &&
        y + height > character.y;
  }
}

class GameOverComponent extends PositionComponent with HasGameRef {
  final int score;
  final VoidCallback onRestart;

  GameOverComponent({required this.score, required this.onRestart});

  @override
  void render(Canvas canvas) {
    // Background
    final backgroundPaint = Paint()..color = Colors.black.withOpacity(0.7);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, gameRef.size.x, gameRef.size.y),
      backgroundPaint,
    );

    // Game Over Text
    final textStyle = TextStyle(
      color: Colors.white,
      fontSize: 48,
      fontWeight: FontWeight.bold,
    );
    final textSpan = TextSpan(text: 'Game Over!', style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: gameRef.size.x);
    textPainter.paint(
      canvas,
      Offset((gameRef.size.x - textPainter.width) / 2, gameRef.size.y / 3),
    );

    // Score Text
    final scoreStyle = TextStyle(
      color: Colors.white70,
      fontSize: 32,
      fontWeight: FontWeight.w500,
    );
    final scoreSpan = TextSpan(
      text: 'You caught: ${score - 1} letters',
      style: scoreStyle,
    );
    final scorePainter = TextPainter(
      text: scoreSpan,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: gameRef.size.x);
    scorePainter.paint(
      canvas,
      Offset((gameRef.size.x - scorePainter.width) / 2, gameRef.size.y / 2),
    );

    // Restart Button
    final buttonPaint = Paint()..color = Colors.white.withOpacity(0.2);
    final buttonRect = Rect.fromCenter(
      center: Offset(gameRef.size.x / 2, gameRef.size.y * 2 / 3),
      width: 200,
      height: 60,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(buttonRect, Radius.circular(15)),
      buttonPaint,
    );

    // Restart Text
    final buttonTextStyle = TextStyle(
      color: Colors.white,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    );
    final buttonTextSpan = TextSpan(text: 'Restart', style: buttonTextStyle);
    final buttonTextPainter = TextPainter(
      text: buttonTextSpan,
      textDirection: TextDirection.ltr,
    )..layout();
    buttonTextPainter.paint(
      canvas,
      Offset(
        (gameRef.size.x - buttonTextPainter.width) / 2,
        gameRef.size.y * 2 / 3 - buttonTextPainter.height / 2,
      ),
    );
  }

  @override
  void update(double dt) {
    // Check for tap to restart
    gameRef.children.whereType<TapDownEvent>().forEach((event) {
      if (_isButtonTapped(event.canvasPosition)) {
        onRestart();
      }
    });
  }

  bool _isButtonTapped(Vector2 tapPosition) {
    final buttonRect = Rect.fromCenter(
      center: Offset(gameRef.size.x / 2, gameRef.size.y * 2 / 3),
      width: 200,
      height: 60,
    );
    return buttonRect.contains(Offset(tapPosition.x, tapPosition.y));
  }
}

class WinComponent extends PositionComponent with HasGameRef {
  final VoidCallback onRestart;

  WinComponent({required this.onRestart});

  @override
  void render(Canvas canvas) {
    // Background
    final backgroundPaint = Paint()..color = Colors.black.withOpacity(0.7);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, gameRef.size.x, gameRef.size.y),
      backgroundPaint,
    );

    // Win Text
    final textStyle = TextStyle(
      color: Colors.white,
      fontSize: 48,
      fontWeight: FontWeight.bold,
    );
    final textSpan = TextSpan(text: 'Congratulations!', style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: gameRef.size.x);
    textPainter.paint(
      canvas,
      Offset((gameRef.size.x - textPainter.width) / 2, gameRef.size.y / 3),
    );

    // Sub Text
    final subTextStyle = TextStyle(
      color: Colors.white70,
      fontSize: 32,
      fontWeight: FontWeight.w500,
    );
    final subTextSpan = TextSpan(
      text: 'You caught all letters!',
      style: subTextStyle,
    );
    final subTextPainter = TextPainter(
      text: subTextSpan,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: gameRef.size.x);
    subTextPainter.paint(
      canvas,
      Offset((gameRef.size.x - subTextPainter.width) / 2, gameRef.size.y / 2),
    );

    // Restart Button
    final buttonPaint = Paint()..color = Colors.white.withOpacity(0.2);
    final buttonRect = Rect.fromCenter(
      center: Offset(gameRef.size.x / 2, gameRef.size.y * 2 / 3),
      width: 200,
      height: 60,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(buttonRect, Radius.circular(15)),
      buttonPaint,
    );

    // Restart Text
    final buttonTextStyle = TextStyle(
      color: Colors.white,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    );
    final buttonTextSpan = TextSpan(text: 'Play Again', style: buttonTextStyle);
    final buttonTextPainter = TextPainter(
      text: buttonTextSpan,
      textDirection: TextDirection.ltr,
    )..layout();
    buttonTextPainter.paint(
      canvas,
      Offset(
        (gameRef.size.x - buttonTextPainter.width) / 2,
        gameRef.size.y * 2 / 3 - buttonTextPainter.height / 2,
      ),
    );
  }

  @override
  void update(double dt) {
    // Check for tap to restart
    gameRef.children.whereType<TapDownEvent>().forEach((event) {
      if (_isButtonTapped(event.canvasPosition)) {
        onRestart();
      }
    });
  }

  bool _isButtonTapped(Vector2 tapPosition) {
    final buttonRect = Rect.fromCenter(
      center: Offset(gameRef.size.x / 2, gameRef.size.y * 2 / 3),
      width: 200,
      height: 60,
    );
    return buttonRect.contains(Offset(tapPosition.x, tapPosition.y));
  }
}
