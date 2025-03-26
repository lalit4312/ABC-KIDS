import 'package:flutter/material.dart';

class SimpleWordsPage extends StatefulWidget {
  @override
  _SimpleWordsPageState createState() => _SimpleWordsPageState();
}

class _SimpleWordsPageState extends State<SimpleWordsPage> {
  // final audioPlayer = AudioPlayer();
  int currentWordIndex = 0;

  final List<Map<String, dynamic>> words = [
    {
      'word': 'CAT',
      'letters': ['C', 'A', 'T'],
      'color': Colors.orange[400]!,
    },
    {
      'word': 'DOG',
      'letters': ['D', 'O', 'G'],
      'color': Colors.brown[400]!,
    },
    {
      'word': 'SUN',
      'letters': ['S', 'U', 'N'],
      'color': Colors.amber[400]!,
    },
    {
      'word': 'BUS',
      'letters': ['B', 'U', 'S'],
      'color': Colors.red[400]!,
    },
    {
      'word': 'FOX',
      'letters': ['F', 'O', 'X'],
      'color': Colors.orange[600]!,
    },
    {
      'word': 'PIG',
      'letters': ['P', 'I', 'G'],
      'color': Colors.pink[300]!,
    },
  ];

  List<String> shuffledLetters = [];
  List<String?> currentWord = [];
  bool wordCompleted = false;

  @override
  void initState() {
    super.initState();
    _initWord();
  }

  @override
  void dispose() {
    // audioPlayer.dispose();
    super.dispose();
  }

  void _initWord() {
    final word = words[currentWordIndex];

    // Create empty slots for the word
    currentWord = List.filled(word['letters'].length, null);

    // Create shuffled letters
    shuffledLetters = List.from(word['letters']);
    shuffledLetters.shuffle();

    wordCompleted = false;
  }

  void _onLetterSelected(String letter, int index) {
    // Find first empty slot in the word
    final emptySlotIndex = currentWord.indexOf(null);

    if (emptySlotIndex != -1) {
      setState(() {
        // Place letter in empty slot
        currentWord[emptySlotIndex] = letter;

        // Remove letter from shuffled letters
        shuffledLetters[index] = '';

        // Check if word is completed
        if (!currentWord.contains(null)) {
          // Check if the word is correct
          final correctWord = words[currentWordIndex]['word'];
          final currentWordString = currentWord.join();

          wordCompleted = correctWord == currentWordString;

          if (wordCompleted) {
            // In a real app, you'd play a success sound
          }
        }
      });
    }
  }

  void _resetCurrentWord() {
    setState(() {
      _initWord();
    });
  }

  void _nextWord() {
    setState(() {
      if (currentWordIndex < words.length - 1) {
        currentWordIndex++;
      } else {
        currentWordIndex = 0;
      }
      _initWord();
    });
  }

  @override
  Widget build(BuildContext context) {
    final word = words[currentWordIndex];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[400],
        title: Text("Simple Words"),
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      backgroundColor: Colors.lightBlue[50],
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Spell the Word",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple[700],
                ),
              ),
            ),

            // Word slots
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  word['letters'].length,
                  (index) => Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color:
                          currentWord[index] != null
                              ? word['color']
                              : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: word['color'], width: 2),
                    ),
                    child: Center(
                      child: Text(
                        currentWord[index] ?? '',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Word completion message
            if (wordCompleted)
              Container(
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.green, width: 2),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 36),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Great job! You spelled ${word['word']} correctly!",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[800],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            Spacer(),

            // Letter options
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  shuffledLetters.length,
                  (index) => GestureDetector(
                    onTap:
                        shuffledLetters[index].isEmpty
                            ? null
                            : () => _onLetterSelected(
                              shuffledLetters[index],
                              index,
                            ),
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color:
                            shuffledLetters[index].isEmpty
                                ? Colors.transparent
                                : Colors.blue[400],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          shuffledLetters[index],
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Control buttons
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: _resetCurrentWord,
                    icon: Icon(Icons.refresh),
                    label: Text("Reset", style: TextStyle(fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[400],
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: wordCompleted ? _nextWord : null,
                    icon: Icon(Icons.arrow_forward),
                    label: Text("Next", style: TextStyle(fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[400],
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
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
