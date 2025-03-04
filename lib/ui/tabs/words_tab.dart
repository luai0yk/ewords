import 'package:ewords/db/favorite_word_helper.dart';
import 'package:ewords/models/unit_model.dart';
import 'package:ewords/utils/tts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';

import '../../models/favorite_word_model.dart';
import '../../models/word_model.dart';
import '../../provider/favorite_words_provider.dart';
import '../../provider/tts_provider.dart';
import '../../theme/my_colors.dart';
import '../my_widgets/my_list_tile.dart';

//BuildContext? myContext;

class WordsTab extends StatefulWidget {
  final UnitModel unit;
  final ScrollController scrollController;

  const WordsTab({
    super.key,
    required this.unit,
    required this.scrollController,
  });

  @override
  State<WordsTab> createState() => _WordsTabState();
}

class _WordsTabState extends State<WordsTab> {
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
    // myContext = context; // Set the global context

    return ListView.builder(
      controller: widget.scrollController,
      padding: const EdgeInsets.all(10),
      itemCount: widget.unit.words.length,
      itemBuilder: (context, index) {
        final WordModel word = widget.unit.words[index];
        context.read<FavoriteWordsProvider>().checkFavorites(word.id);

        return MyListTile(
          onTap: () {},
          trailing: [
            Selector<TTSProvider, int>(
              selector: (context, provider) => provider.currentPlayingWordID,
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
                  icon: HugeIcon(
                    icon: currentPlayingWordID == word.id
                        ? HugeIcons.strokeRoundedStop
                        : HugeIcons.strokeRoundedMegaphone02,
                    color: MyColors.themeColors[300]!,
                  ),
                );
              },
            ),
            // Favorite icon button
            Selector<FavoriteWordsProvider, bool>(
              selector: (context, provider) => provider.isFavorite(word.id),
              builder: (context, isFavorite, child) {
                return IconButton(
                  onPressed: () async {
                    if (isFavorite) {
                      await FavoriteWordHelper.instance.deleteFavorite(word.id);
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
                    context
                        .read<FavoriteWordsProvider>()
                        .checkFavorites(word.id);
                  },
                  icon: HugeIcon(
                    icon: isFavorite
                        ? HugeIcons.strokeRoundedHeartCheck
                        : HugeIcons.strokeRoundedFavourite,
                    color: MyColors.themeColors[300]!,
                  ),
                  color: MyColors.themeColors[300],
                );
              },
            ),
          ],
          isTrailingVisible: true,
          word: word,
        );
      },
    );
  }
}
