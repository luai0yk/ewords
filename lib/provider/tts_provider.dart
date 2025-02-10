import 'package:flutter/material.dart';

class TTSProvider extends ChangeNotifier {
  Map<String, int> _currentWordStartEnd =
      {}; // Start and end positions for the current word

  // Getter for the currentWordStartEnd map
  Map<String, int> get currentWordStartEnd => _currentWordStartEnd;

  // Update the start and end positions for the current word being spoken
  void updateCurrentWordStartEnd(int start, int end) {
    _currentWordStartEnd = {'start': start, 'end': end}; // Set the positions
    notifyListeners(); // Notify listeners about the change
  }

  bool isPlaying = false;
  String currentPlayingWordID = "";

  void play({bool listen = true, String currentPlayingWordID = ""}) {
    this.currentPlayingWordID = currentPlayingWordID;

    if (currentPlayingWordID.isEmpty) {
      isPlaying = true;
    } else {
      isPlaying = false;
    }

    if (listen) {
      notifyListeners();
    }
  }

  void stop({bool listen = true}) {
    isPlaying = false;
    currentPlayingWordID = "";
    if (listen) {
      notifyListeners();
    }
  }
}
