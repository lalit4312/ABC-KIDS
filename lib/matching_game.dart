import 'package:flutter/material.dart';

class MatchingGamePage extends StatefulWidget {
  @override
  _MatchingGamePageState createState() => _MatchingGamePageState();
}

class _MatchingGamePageState extends State<MatchingGamePage> {
  List<Map<String, dynamic>> letters = [];
  List<Map<String, dynamic>> cards = [];
  List<int> selectedCards = [];
  List<int> matchedCards = [];
  int score = 0;
  bool gameCompleted = false;

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  void _initGame() {
    // Reset game state
    selectedCards = [];
    matchedCards = [];
    score = 0;
    gameCompleted = false;

    // Initialize letters (using only a subset for the game)
    letters = [
      {'letter': 'A', 'color': Colors.red},
      {'letter': 'B', 'color': Colors.blue},
      {'letter': 'C', 'color': Colors.orange},
      {'letter': 'D', 'color': Colors.green},
      {'letter': 'E', 'color': Colors.purple},
      {'letter': 'F', 'color': Colors.teal},
    ];

    // Create pairs of cards
    cards = [];
    for (var letter in letters) {
      // Add uppercase letter
      cards.add({
        'value': letter['letter'],
        'isUppercase': true,
        'color': letter['color'],
      });

      // Add lowercase letter
      cards.add({
        'value': letter['letter'].toLowerCase(),
        'isUppercase': false,
        'color': letter['color'],
      });
    }

    // Shuffle the cards
    cards.shuffle();
  }

  void _checkMatch() {
    if (selectedCards.length == 2) {
      final card1 = cards[selectedCards[0]];
      final card2 = cards[selectedCards[1]];

      // Check if the cards match (same letter, different case)
      if (card1['value'].toUpperCase() == card2['value'].toUpperCase() &&
          card1['isUppercase'] != card2['isUppercase']) {
        // Cards match
        matchedCards.addAll(selectedCards);
        score += 10;

        // Check if game is completed
        if (matchedCards.length == cards.length) {
          gameCompleted = true;
        }
      }

      // Clear selected cards after a short delay
      Future.delayed(Duration(milliseconds: 800), () {
        setState(() {
          selectedCards = [];
        });
      });
    }
  }

  void _onCardTap(int index) {
    // Ignore if card is already matched or selected
    if (matchedCards.contains(index) || selectedCards.contains(index)) {
      return;
    }

    // Ignore if already have 2 cards selected
    if (selectedCards.length >= 2) {
      return;
    }

    setState(() {
      selectedCards.add(index);
      _checkMatch();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[400],
        elevation: 0,
        title: Text("Match the Letters"),
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      backgroundColor: Colors.lightBlue[50],
      body: SafeArea(
        child: Column(
          children: [
            // Score display
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Score: $score",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple[700],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _initGame();
                      });
                    },
                    child: Text("Restart", style: TextStyle(fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Game completed message
            if (gameCompleted)
              Container(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.green, width: 2),
                ),
                child: Column(
                  children: [
                    Text(
                      "Great Job!",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800],
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "You matched all the letters!",
                      style: TextStyle(fontSize: 20, color: Colors.green[800]),
                    ),
                  ],
                ),
              ),

            // Card grid
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.all(16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: cards.length,
                itemBuilder: (context, index) {
                  final isSelected = selectedCards.contains(index);
                  final isMatched = matchedCards.contains(index);

                  return GestureDetector(
                    onTap: () => _onCardTap(index),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        color:
                            isMatched || isSelected
                                ? cards[index]['color']
                                : Colors.indigo[100],
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child:
                            isMatched || isSelected
                                ? Text(
                                  cards[index]['value'],
                                  style: TextStyle(
                                    fontSize: 50,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                )
                                : Icon(
                                  Icons.star,
                                  size: 40,
                                  color: Colors.indigo[300],
                                ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
