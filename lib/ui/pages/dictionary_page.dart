import 'package:ewords/models/word_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';

import '../../db/favorite_word_helper.dart';
import '../../models/favorite_word_model.dart';
import '../../provider/dictionary_provider.dart';
import '../../provider/favorite_words_provider.dart';
import '../../provider/tts_provider.dart';
import '../../theme/my_colors.dart';
import '../../theme/my_theme.dart';
import '../../utils/helpers/dialog_helper.dart';
import '../../utils/tts.dart';
import '../dialogs/app_dialog.dart';
import '../my_widgets/my_list_tile.dart';
import '../my_widgets/word_detail.dart';

class DictionaryPage extends StatefulWidget {
  const DictionaryPage({super.key});

  @override
  State<DictionaryPage> createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage> {
  late final TextEditingController _textEditingController;
  DictionaryProvider? _dictionaryProvider;
  FlutterTts? _flutterTts;

  TTSProvider? _ttsProvider;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _flutterTts = TTS.instance;

    _textEditingController.addListener(() {
      context.read<DictionaryProvider>().search(_textEditingController.text);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _ttsProvider = context.read<TTSProvider>();
    _dictionaryProvider = context.read<DictionaryProvider>();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _dictionaryProvider!.close();
    _flutterTts!.stop();

    _ttsProvider!.stop(listen: false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MyTheme.initialize(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 90.sp,
            collapsedHeight: 110.sp,
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              tooltip: 'Back',
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedArrowLeft01,
                color: MyColors.themeColors[300]!,
              ),
            ),
            snap: true,
            floating: true,
            pinned: false,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              titlePadding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top, left: 10, right: 10),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'word dictionary'.toUpperCase(), // Title of the page
                    style: MyTheme().appBarTitleStyle,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    cursorColor: MyColors.themeColors[100],
                    cursorWidth: 3,
                    style: MyTheme().mainTextStyle,
                    controller: _textEditingController,
                    cursorRadius: const Radius.circular(10),
                    // controller: _controller, // Uncomment to use the search functionality
                    decoration: InputDecoration(
                      hintText: 'SEARCH..', // Placeholder text
                      contentPadding: EdgeInsets.zero,
                      prefixIcon: HugeIcon(
                        icon: HugeIcons.strokeRoundedSearch01,
                        color: MyColors.themeColors[300]!,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: MyColors.themeColors[300]!),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Consumer widget to listen for changes in DictionaryProvider
          Consumer<DictionaryProvider>(
            builder: (context, provider, child) {
              // Show loading indicator while fetching data
              return provider.isLoading
                  ? const SliverFillRemaining(
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 10,
                        ),
                      ),
                    )
                  : provider.wordList.isEmpty
                      // Show message if no words are found
                      ? SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(
                            child: Text(
                              'Sorry, no words found!',
                              style: TextStyle(
                                color: MyColors.themeColors[300],
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      : SliverList.builder(
                          itemCount: provider.wordList.length,
                          // Number of words
                          itemBuilder: (context, index) {
                            WordModel word = provider.wordList[index];

                            return Padding(
                              padding:
                                  EdgeInsets.only(left: 10.sp, right: 10.sp),
                              child: MyListTile(
                                onTap: () {
                                  DialogHelper.show(
                                    context: context,
                                    pageBuilder: (context, animation,
                                        secondaryAnimation) {
                                      return AppDialog(
                                        customContent: WordDetail(
                                          word: word,
                                        ),
                                        cancelText: 'Hide',
                                        onCancel: () => null,
                                      );
                                    },
                                  );
                                },
                                trailing: [
                                  Selector<TTSProvider, int>(
                                    selector: (context, provider) =>
                                        provider.currentPlayingWordID,
                                    builder:
                                        (context, currentPlayingWordID, child) {
                                      return IconButton(
                                        onPressed: () async {
                                          if (currentPlayingWordID == word.id) {
                                            _flutterTts!.stop();
                                            _ttsProvider!.stop();
                                          } else {
                                            _flutterTts!.speak(
                                              '${word.word}\n${word.definition}\nexample\n${word.example}',
                                            );
                                            _ttsProvider!.play(
                                                currentPlayingWordID: word.id);
                                          }
                                        },
                                        tooltip: currentPlayingWordID == word.id
                                            ? 'Stop'
                                            : 'Speak',
                                        icon: HugeIcon(
                                          icon: currentPlayingWordID == word.id
                                              ? HugeIcons.strokeRoundedStop
                                              : HugeIcons
                                                  .strokeRoundedMegaphone02,
                                          color: MyColors.themeColors[300]!,
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
                                            await FavoriteWordHelper.instance
                                                .addFavorite(
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
                                        tooltip: isFavorite
                                            ? 'Remove from favorites'
                                            : 'Add to favorites',
                                        icon: HugeIcon(
                                          icon: isFavorite
                                              ? HugeIcons
                                                  .strokeRoundedHeartCheck
                                              : HugeIcons
                                                  .strokeRoundedFavourite,
                                          color: MyColors.themeColors[300]!,
                                        ),
                                        color: MyColors.themeColors[300],
                                      );
                                    },
                                  ),
                                ],
                                isTrailingVisible: true,
                                word: word,
                                isWordDetailVisible: true,
                              ),
                            );
                          },
                        );
            },
          ),
        ],
      ),
    );
  }
}
