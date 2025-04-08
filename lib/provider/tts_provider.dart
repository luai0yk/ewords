import 'package:flutter/material.dart';

import '../utils/tts.dart';

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
  int currentPlayingWordID = -1;

  void play({bool listen = true, int currentPlayingWordID = -1}) {
    this.currentPlayingWordID = currentPlayingWordID;

    if (currentPlayingWordID == -1) {
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
    currentPlayingWordID = -1;
    if (listen) {
      notifyListeners();
    }
  }

  void setCompletionHandler() {
    TTS.instance.setCompletionHandler(() {
      TTS.instance.stop();
      stop();
      updateCurrentWordStartEnd(0, 0);
    });
  }

  void setProgressHandler() {
    TTS.instance.setProgressHandler(
      (text, start, end, word) {
        updateCurrentWordStartEnd(start, end);
      },
    );
  }
}
