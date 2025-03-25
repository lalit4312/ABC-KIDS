import 'package:alphabet_learning_app/alphabate_leaning.dart';
import 'package:alphabet_learning_app/alphabate_song.dart';
import 'package:alphabet_learning_app/alphabet_catching_game.dart';
import 'package:alphabet_learning_app/letter_tracing.dart';
import 'package:alphabet_learning_app/matching_game.dart';
import 'package:alphabet_learning_app/simple_word.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flame/game.dart';

class HomePage extends StatelessWidget {
  final List<Map<String, dynamic>> activities = [
    {
      'title': 'Learn Alphabet',
      'icon': Icons.abc,
      'gradient': [Color.fromARGB(255, 243, 57, 63), Color(0xFFFAD0C4)],
      'route': AlphabetLearningPage(),
    },
    {
      'title': 'Trace Letters',
      'icon': Icons.edit,
      'gradient': [Color.fromARGB(255, 9, 223, 38), Color(0xFFD4FC79)],
      'route': LetterTracingPage(),
    },
    {
      'title': 'Match Game',
      'icon': Icons.games,
      'gradient': [Color.fromARGB(255, 226, 160, 74), Color(0xFFFFAB73)],
      'route': MatchingGamePage(),
    },
    {
      'title': 'Alphabet Songs',
      'icon': Icons.music_video,
      'gradient': [Color(0xFF90CAF9), Color(0xFF64B5F6)],
      'route': AlphabetSongsPage(),
    },
    {
      'title': 'Simple Words',
      'icon': Icons.book,
      'gradient': [Color(0xFF80CBC4), Color(0xFF4DB6AC)],
      'route': SimpleWordsPage(),
    },
    {
      'title': 'Catch Me',
      'icon': Icons.gamepad,
      'gradient': [Color.fromARGB(255, 190, 68, 178), Color(0xFF4DB6AC)],
      'route': AlphabetCatchingGamePage(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE0F7FA), Color(0xFFB2EBF2)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildWelcomeCard(),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                  ),
                  itemCount: activities.length,
                  itemBuilder: (context, index) {
                    return _buildActivityCard(context, activities[index]);
                  },
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Fun Learning",
            style: GoogleFonts.fredoka(
              textStyle: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5C6BC0),
              ),
            ),
          ),
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 24,
            child: Icon(Icons.child_care, size: 30, color: Color(0xFFEC407A)),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFEC407A), Color(0xFFF48FB1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hello Childrens!",
                  style: GoogleFonts.fredoka(
                    textStyle: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Choose a fun activity to begin your learning adventure today!",
                  style: GoogleFonts.nunito(
                    textStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10),
          CircleAvatar(
            backgroundColor: Colors.white.withOpacity(0.2),
            radius: 30,
            child: Icon(Icons.school, size: 32, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(
    BuildContext context,
    Map<String, dynamic> activity,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => activity['route']),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: activity['gradient'],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              spreadRadius: 0,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              splashColor: Colors.white.withOpacity(0.2),
              highlightColor: Colors.transparent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => activity['route']),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        activity['icon'],
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      activity['title'],
                      style: GoogleFonts.fredoka(
                        textStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
