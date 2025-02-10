

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  String? _themeState; // Variable to hold the current theme state
  String? _speechAccentCode; // Variable to hold the speech accent code
  double? _speechRate; // Variable to hold the speech rate
  SharedPreferences? prefs; // Instance of SharedPreferences

  SettingsProvider() {
    // Initialize settings when the provider is created
    init();
  }

  /* Initialize SharedPreferences and load saved settings */
  Future<void> init() async {
    prefs =
        await SharedPreferences.getInstance(); // Get SharedPreferences instance
    // Load saved theme or default is 'System default'
    _themeState = prefs!.getString('theme_state') ?? 'System default';
    // Load saved speech rate or default is (0.5)
    _speechRate = prefs!.getDouble('tts_speech_rate') ?? 0.5;
    // Load saved accent or language code or default is 'en-US'
    _speechAccentCode = prefs!.getString('tts_speech_accent') ?? 'en-US';
    // Notify listeners after loading settings
    notifyListeners();
  }

  /* Getter for the saved theme mode state */
  String? get themeState => _themeState;

  /* Getter for the saved speech rate */
  double? get speechRate => _speechRate;

  /* Getter for the saved language or accent code */
  String? get speechAccentCode => _speechAccentCode;

  /* Change the theme mode state */
  void changeTheme(String val) async {
    _themeState = val; // Update the theme state
    // Save the new theme state into SharedPreferences
    await prefs!.setString('theme_state', _themeState!);
    // Notify listeners about the theme change
    notifyListeners();
  }

  /* Change the speech accent or language code */
  void setAccent(String accentCode) async {
    _speechAccentCode = accentCode; // Update the speech accent code
    // Save the new accent code into SharedPreferences
    await prefs!.setString('tts_speech_accent', _speechAccentCode!);
    // Notify listeners about the accent change
    notifyListeners();
  }

  /* Change the speech rate value */
  void setSpeechRate(double rate) {
    _speechRate = rate; // Update the speech rate
    // Save the new speech rate value into SharedPreferences
    prefs!.setDouble('tts_speech_rate', _speechRate!);
    // Notify listeners about the speech rate change
    notifyListeners();
  }
}
