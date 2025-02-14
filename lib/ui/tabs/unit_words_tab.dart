import 'package:ewords/args/passage_args.dart';
import 'package:ewords/db/favorite_word_helper.dart';
import 'package:ewords/db/words_helper.dart';
import 'package:ewords/utils/tts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';

import '../../models/favorite_word_model.dart';
import '../../models/word_model.dart';
import '../../provider/favorite_words_provider.dart';
import '../../provider/tts_provider.dart';
import '../../theme/my_colors.dart';
import '../my_widgets/my_list_tile.dart';

BuildContext? myContext;

class UnitWordListPage extends StatefulWidget {
  final PassageArgs passageArgs;
  final ScrollController scrollController;

  const UnitWordListPage({
    super.key,
    required this.passageArgs,
    required this.scrollController,
  });

  @override
  State<UnitWordListPage> createState() => _UnitWordListPageState();
}

class _UnitWordListPageState extends State<UnitWordListPage> {
  FlutterTts? flutterTts;

  TTSProvider? ttsProvider;

  @override
  void initState() {
    super.initState();

    flutterTts = TTS.instance;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    ttsProvider = context.read<TTSProvider>();
  }

  @override
  Widget build(BuildContext context) {
    myContext = context; // Set the global context

    return FutureBuilder<List<WordModel>>(
      future: WordsHelper.instance.getWords(
          bookId: widget.passageArgs.bookId, unitId: widget.passageArgs.unitId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(strokeWidth: 10));
        } else if (snapshot.hasError) {
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
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              'Sorry, no data available!',
              style: TextStyle(
                color: MyColors.themeColors[300],
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        } else {
          final wordList = snapshot.data!;

          // Check if words are favorites and update the state
          for (var word in wordList) {
            context.read<FavoriteWordsProvider>().checkFavorites(word.id);
          }

          return ListView.builder(
            controller: widget.scrollController,
            padding: const EdgeInsets.all(10),
            itemCount: wordList.length,
            itemBuilder: (context, index) {
              final word = wordList[index];

              return MyListTile(
                onTap: () {},
                trailing: [
                  Selector<TTSProvider, String>(
                    selector: (context, provider) =>
                        provider.currentPlayingWordID,
                    builder: (context, currentPlayingWordID, child) {
                      return IconButton(
                        onPressed: () async {
                          if (currentPlayingWordID == word.id) {
                            flutterTts!.stop();
                            ttsProvider!.stop();
                          } else {
                            flutterTts!.speak(
                              '${word.word}\n${word.definition}\nexample\n${word.example}',
                            );
                            ttsProvider!.play(currentPlayingWordID: word.id);
                          }
                        },
                        icon: Icon(
                          currentPlayingWordID == word.id
                              ? Icons.stop_rounded
                              : Icons.volume_up_rounded,
                          color: MyColors.themeColors[300],
                        ),
                      );
                    },
                  ),
                  // Favorite icon button
                  Selector<FavoriteWordsProvider, bool>(
                    selector: (context, provider) =>
                        provider.isFavorite(word.id),
                    builder: (context, isFavorite, child) {
                      return IconButton(
                        onPressed: () async {
                          if (isFavorite) {
                            await FavoriteWordHelper.instance
                                .deleteFavorite(word.id);
                          } else {
                            await FavoriteWordHelper.instance.addFavorite(
                              FavoriteWordModel(
                                id: word.id,
                                unitId: word.unitId,
                                bookId: word.bookId,
                                word: word.word,
                                definition: word.definition,
                                example: word.example,
                              ),
                            );
                          }
                          myContext!
                              .read<FavoriteWordsProvider>()
                              .checkFavorites(word.id);
                        },
                        icon: Icon(
                          isFavorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_outline_rounded,
                        ),
                        color: MyColors.themeColors[300],
                      );
                    },
                  ),
                ],
                isTrailingVisible: true,
                leadingText: word.word,
                title: word.word,
                text: word.definition,
                subText: word.example,
              );
            },
          );
        }
      },
    );
  }
}
