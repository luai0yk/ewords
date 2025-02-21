import 'package:flutter/cupertino.dart';

import '../db/favorite_word_helper.dart';
import '../models/favorite_word_model.dart';

class FavoriteWordsProvider extends ChangeNotifier {
  // A set to hold the IDs of favorite words
  final Set<int> _favoriteIds = <int>{};

  // Check if a word ID is in the favorites
  bool isFavorite(int id) => _favoriteIds.contains(id);

  // Check if a word is marked as favorite and update the state
  Future<void> checkFavorites(int id) async {
    // Check if the ID exists in favorites in the database
    bool isInFavorite = await FavoriteWordHelper.instance.isFavorite(id);
    if (isInFavorite) {
      _favoriteIds.add(id); // Add ID to favorites if it exists
    } else {
      _favoriteIds.remove(id); // Remove ID from favorites if it doesn't
    }

    print('checked favs');
    // Notify listeners to update UI
    notifyListeners();
  }

  // Delete a word from favorites and notify listeners
  Future<void> deleteFavorite({required int id}) async {
    await FavoriteWordHelper.instance
        .deleteFavorite(id); // Remove from the database
    _favoriteIds.remove(id); // Remove from local set
    notifyListeners(); // Notify listeners to update UI
  }

  // Check if a word ID is in favorites and return a boolean
  Future<bool> isFav(String id) async {
    List<FavoriteWordModel> favorites =
        await FavoriteWordHelper.instance.getFavorites();
    // Check if the word ID is in the list of favorites
    return favorites.map((favorite) => favorite.id).contains(id);
  }

// bool _isFav = false;
//
// bool isFav(String id) => _isFav;
//
// Future<void> checkFavorites(String id) async {
//   _isFav = await FavoriteDBHelper().isInFavorite(id);
//   notifyListeners();
// }
}
