import 'package:ewords/db/words_helper.dart';
import 'package:flutter/material.dart';

import '../models/word_model.dart';

class DictionaryProvider extends ChangeNotifier {
  // List to store the original word data fetched from the database
  List<WordModel> _wordData = [];

  // List to store the current filtered word list for display
  List<WordModel> _wordList = [];

  // To track loading state
  bool _isLoading = true;

  // Expose loading state for the UI
  bool get isLoading => _isLoading;

  // Constructor that initiates the fetching of words
  DictionaryProvider() {
    _fetchWords();
  }

  // Asynchronous method to fetch words from the database
  Future<void> _fetchWords() async {
    try {
      // Fetch words from the database using DBHelper
      _wordData = await WordsHelper.instance.getWords();
      _wordList = _wordData; // Initialize wordList with fetched data
    } catch (e) {
      // Handle errors (e.g., log or notify) and set wordList to empty
      _wordList = [];
    } finally {
      // Update loading state and notify listeners to update the UI
      _isLoading = false;
      notifyListeners();
    }
  }

  // Getter to retrieve the current word list for display
  List<WordModel> get wordList => _wordList;

  // Method to search words based on the query
  void search(String query) {
    if (query.isEmpty) {
      // If query is empty, reset wordList to original data
      _wordList = _wordData;
    } else {
      // Filter _wordData based on the query and update wordList
      _wordList = _wordData.where((word) {
        return word.word.toLowerCase().contains(query.toLowerCase().trim());
      }).toList();
    }
    notifyListeners();
    // Notify listeners to update the UI with the new filtered list
  }

  void close() {
    _wordList = _wordData;
  }
}
