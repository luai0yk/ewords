import 'package:ewords/db/favorite_word_helper.dart';
import 'package:ewords/ui/dialogs/app_dialog.dart';
import 'package:ewords/ui/my_widgets/word_detail.dart';
import 'package:ewords/utils/helpers/dialog_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hidable/hidable.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';

import '../../models/favorite_word_model.dart';
import '../../provider/favorite_words_provider.dart';
import '../../provider/settings_provider.dart';
import '../../provider/tts_provider.dart';
import '../../theme/my_colors.dart';
import '../../theme/my_theme.dart';
import '../../utils/tts.dart';
import '../my_widgets/my_list_tile.dart';

class FavoriteTab extends StatefulWidget {
  const FavoriteTab({super.key});

  @override
  State<FavoriteTab> createState() => _FavoriteTabState();
}

class _FavoriteTabState extends State<FavoriteTab> {
  FlutterTts? _flutterTts;
  TTSProvider? _ttsProvider;
  ScrollController? _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _flutterTts = TTS.instance;

    _ttsProvider = context.read<TTSProvider>();

    /*The speech rate or speed
    * its value comes from the settings page (Slider's value)*/
    _flutterTts!.setSpeechRate(context.read<SettingsProvider>().speechRate!);

    /*The speech language or accent
    * its value comes from the settings page (Accent's ListTile>>RadioListTile)*/
    _flutterTts!
        .setLanguage(context.read<SettingsProvider>().speechAccentCode!);

    _ttsProvider!.setCompletionHandler();
  }

  @override
  void dispose() {
    _flutterTts!.stop();
    _ttsProvider!.stop(listen: false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MyTheme.initialize(context);

    return Scaffold(
      appBar: Hidable(
        deltaFactor: 0.06,
        preferredWidgetSize: Size.fromHeight(75.sp),
        controller: _scrollController!,
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
                controller: _scrollController,
                padding: const EdgeInsets.all(10),
                itemCount: favoriteList!.length, // Count of favorite words
                itemBuilder: (context, index) {
                  final favorite = favoriteList[index];

                  return MyListTile(
                    onTap: () {
                      DialogHelper.show(
                        context: context,
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return AppDialog(
                            customContent: WordDetail(word: favorite),
                            cancelText: 'Hide',
                            onCancel: () => null,
                          );
                        },
                      );
                    },
                    isTrailingVisible: true,
                    trailing: [
                      Selector<TTSProvider, int>(
                        selector: (context, provider) =>
                            provider.currentPlayingWordID,
                        builder: (context, currentPlayingWordID, child) {
                          return IconButton(
                            onPressed: () async {
                              if (currentPlayingWordID == favorite.id) {
                                _flutterTts!.stop();
                                _ttsProvider!.stop();
                              } else {
                                _flutterTts!.speak(
                                  '${favorite.word}\n${favorite.definition}\nexample\n${favorite.example}',
                                );
                                _ttsProvider!
                                    .play(currentPlayingWordID: favorite.id);
                              }
                            },
                            tooltip: currentPlayingWordID == favorite.id
                                ? 'Stop'
                                : 'Speak',
                            icon: HugeIcon(
                              icon: currentPlayingWordID == favorite.id
                                  ? HugeIcons.strokeRoundedStop
                                  : HugeIcons.strokeRoundedMegaphone02,
                              color: MyColors.themeColors[300]!,
                            ),
                          );
                        },
                      ),
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
                    isWordDetailVisible: true,
                    word: favorite,
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
