import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AlphabetSongsPage extends StatefulWidget {
  const AlphabetSongsPage({super.key});

  @override
  _AlphabetSongsPageState createState() => _AlphabetSongsPageState();
}

class _AlphabetSongsPageState extends State<AlphabetSongsPage>
    with SingleTickerProviderStateMixin {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  int currentSongIndex = 0;
  late AnimationController _animationController;

  // Progress indicator for song playback
  double _progress = 0.0;

  final List<Map<String, dynamic>> songs = [
    {
      'title': 'ABC Song',
      'description': 'Classic alphabet song',
      'icon': Icons.music_note,
      'color': Colors.blue[400]!,
      'audioPath': 'audio/abc_song.mp3',
      'lyrics': '🎵 A-B-C-D-E-F-G... 🎵',
    },
    {
      'title': 'Phonics Song',
      'description': 'Learn letter sounds',
      'icon': Icons.record_voice_over,
      'color': Colors.red[400]!,
      'audioPath': 'audio/phonics.mp3',
      'lyrics': '🎵 A is for Apple, B is for Ball... 🎵',
    },
    {
      'title': 'Letter Sounds',
      'description': 'Pronounce each letter',
      'icon': Icons.volume_up,
      'color': Colors.green[400]!,
      'audioPath': 'audio/learning_sound.mp3',
      'lyrics': '🎵 Ah, Buh, Cuh, Duh... 🎵',
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Set up audio player listeners
    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        isPlaying = false;
        _progress = 0.0;
        _animationController.reset();
      });
    });

    _audioPlayer.onPositionChanged.listen((Duration position) {
      // Update progress indicator (mock implementation)
      // In a real app, you'd use the actual duration
      setState(() {
        _progress = (position.inSeconds % 60) / 60;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _togglePlayPause() async {
    final currentSong = songs[currentSongIndex];

    if (isPlaying) {
      await _audioPlayer.pause();
      _animationController.stop();
    } else {
      try {
        await _audioPlayer.play(AssetSource(currentSong['audioPath']));
        _animationController.repeat(reverse: true);
      } catch (e) {
        print('Error playing audio: $e');
      }
    }

    setState(() {
      isPlaying = !isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentSong = songs[currentSongIndex];
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Alphabet Songs",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.pink[400]!, Colors.purple[300]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.lightBlue[50]!, Colors.lightBlue[100]!],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header with current song details
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 24,
                ),
                child: Row(
                  children: [
                    Text(
                      "Learning Songs",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.library_music_outlined,
                            size: 16,
                            color: Colors.pink[400],
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "${songs.length} Songs",
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Song list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: songs.length,
                  itemBuilder: (context, index) {
                    final song = songs[index];
                    final isSelected = index == currentSongIndex;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow:
                            isSelected
                                ? [
                                  BoxShadow(
                                    color: song['color'].withOpacity(0.3),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                                : [],
                      ),
                      child: Material(
                        color:
                            isSelected
                                ? song['color'].withOpacity(0.2)
                                : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            setState(() {
                              currentSongIndex = index;
                              isPlaying = false;
                              _progress = 0.0;
                              _audioPlayer.stop();
                              _animationController.reset();
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                // Song icon
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    color: song['color'],
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: song['color'].withOpacity(0.4),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    song['icon'],
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                                const SizedBox(width: 16),

                                // Song info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        song['title'],
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              isSelected
                                                  ? song['color']
                                                  : Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        song['description'],
                                        style: TextStyle(
                                          fontSize: 14,
                                          color:
                                              isSelected
                                                  ? song['color']
                                                  : Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Play indicator
                                if (isSelected && isPlaying)
                                  AnimatedBuilder(
                                    animation: _animationController,
                                    builder: (context, child) {
                                      return Container(
                                        height: 40,
                                        width: 40,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                        ),
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            ...List.generate(3, (i) {
                                              return Transform.translate(
                                                offset: Offset(
                                                  0,
                                                  (_animationController.value *
                                                          4) -
                                                      2 * i,
                                                ),
                                                child: Container(
                                                  height: 2,
                                                  width: 2 + i * 3,
                                                  decoration: BoxDecoration(
                                                    color: song['color'],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          2,
                                                        ),
                                                  ),
                                                ),
                                              );
                                            }),
                                          ],
                                        ),
                                      );
                                    },
                                  )
                                else if (isSelected)
                                  Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: song['color'].withOpacity(0.2),
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.play_arrow_rounded,
                                      color: song['color'],
                                      size: 28,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Playback controls
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Song progress bar
                    Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.centerLeft,
                      children: [
                        // Progress background
                        Container(
                          height: 4,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),

                        // Progress indicator - FIXED CALCULATION
                        if (_progress > 0)
                          Container(
                            height: 4,
                            width: (screenWidth - 48) * _progress,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  currentSong['color'],
                                  Color.lerp(
                                    currentSong['color'],
                                    Colors.white,
                                    0.5,
                                  )!,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),

                        // Thumb
                        if (isPlaying)
                          Positioned(
                            left: ((screenWidth - 48) * _progress).clamp(
                              0,
                              screenWidth - 48,
                            ),
                            child: Container(
                              height: 12,
                              width: 12,
                              decoration: BoxDecoration(
                                color: currentSong['color'],
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: currentSong['color'].withOpacity(
                                      0.4,
                                    ),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // Now playing info
                    Column(
                      children: [
                        Text(
                          "NOW PLAYING",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[500],
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          currentSong['title'],
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: currentSong['color'],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          currentSong['description'],
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Playback controls
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Previous button
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.skip_previous_rounded,
                              size: 32,
                            ),
                            color: Colors.grey[800],
                            onPressed: () {
                              setState(() {
                                if (currentSongIndex > 0) {
                                  currentSongIndex--;
                                } else {
                                  currentSongIndex = songs.length - 1;
                                }
                                isPlaying = false;
                                _progress = 0.0;
                                _audioPlayer.stop();
                                _animationController.reset();
                              });
                            },
                          ),
                        ),

                        // Play/Pause button
                        GestureDetector(
                          onTap: _togglePlayPause,
                          child: Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  currentSong['color'],
                                  Color.lerp(
                                    currentSong['color'],
                                    Colors.white,
                                    0.2,
                                  )!,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: currentSong['color'].withOpacity(0.4),
                                  blurRadius: 15,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Icon(
                              isPlaying
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded,
                              size: 48,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        // Next button
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.skip_next_rounded, size: 32),
                            color: Colors.grey[800],
                            onPressed: () {
                              setState(() {
                                if (currentSongIndex < songs.length - 1) {
                                  currentSongIndex++;
                                } else {
                                  currentSongIndex = 0;
                                }
                                isPlaying = false;
                                _progress = 0.0;
                                _audioPlayer.stop();
                                _animationController.reset();
                              });
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Lyrics animation when playing
                    if (isPlaying)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        margin: const EdgeInsets.only(top: 10),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: currentSong['color'].withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.music_note_outlined,
                              color: currentSong['color'],
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: AnimatedBuilder(
                                animation: _animationController,
                                builder: (context, child) {
                                  return Text(
                                    currentSong['lyrics'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontStyle: FontStyle.italic,
                                      color: currentSong['color'],
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
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
