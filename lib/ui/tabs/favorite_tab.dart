import 'package:ewords/db/favorite_word_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hidable/hidable.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';

import '../../models/favorite_word_model.dart';
import '../../provider/favorite_words_provider.dart';
import '../../theme/my_colors.dart';
import '../../theme/my_theme.dart';
import '../my_widgets/my_list_tile.dart';

class FavoriteListPage extends StatelessWidget {
  final ScrollController scrollController;

  const FavoriteListPage({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    MyTheme.initialize(context);

    return Scaffold(
      appBar: Hidable(
        deltaFactor: 0.06,
        preferredWidgetSize: Size.fromHeight(75.sp),
        controller: scrollController,
        child: AppBar(
          title: Text('favorites'.toUpperCase()), // Title of the app bar
          titleTextStyle: TextStyle(
            color: MyColors.themeColors[300],
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ),
      body: Consumer<FavoriteWordsProvider>(
        builder: (context, favoriteWordsProvider, child) {
          return FutureBuilder<List<FavoriteWordModel>>(
            future: FavoriteWordHelper.instance
                .getFavorites(), // Fetch favorites from database
            builder: (context, snapshot) {
              // Handle loading state
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(strokeWidth: 10),
                );
              }
              // Handle error state
              else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Sorry, something went wrong!',
                    style: TextStyle(
                      color: MyColors.themeColors[300],
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }
              // Handle empty favorites
              else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                    'No favorites yet!',
                    style: TextStyle(
                      color: MyColors.themeColors[300],
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }

              // List of favorite words
              final favoriteList = snapshot.data;

              return ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.all(10),
                itemCount: favoriteList!.length, // Count of favorite words
                itemBuilder: (context, index) {
                  final favorite = favoriteList[index];

                  return MyListTile(
                    onTap: () {
                      // Define action when a list item is tapped
                    },
                    isTrailingVisible: true,
                    trailing: [
                      // Icon button to delete favorite
                      IconButton(
                        onPressed: () async {
                          await favoriteWordsProvider.deleteFavorite(
                            id: favorite.id,
                          );
                        },
                        tooltip: 'Delete',
                        icon: HugeIcon(
                          icon: HugeIcons.strokeRoundedDelete01,
                          color: MyColors.themeColors[300]!,
                        ),
                      ),
                    ],
                    leadingText: favorite.word, // Leading text (word)
                    title: favorite.word, // Title in uppercase
                    text: favorite.definition, // Definition of the word
                    subText: favorite.example, // Example usage
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
