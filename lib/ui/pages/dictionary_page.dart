import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';

import '../../provider/dictionary_provider.dart';
import '../../theme/my_colors.dart';
import '../../theme/my_theme.dart';
import '../my_widgets/my_list_tile.dart';

class DictionaryPage extends StatefulWidget {
  const DictionaryPage({super.key});

  @override
  State<DictionaryPage> createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage> {
  late final TextEditingController _controller; // Controller for search input
  DictionaryProvider? dictionaryProvider;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(); // Initialize controller

    // Listener to handle search input changes (commented out for now)
    _controller.addListener(() {
      context.read<DictionaryProvider>().search(_controller.text);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    dictionaryProvider = context.read<DictionaryProvider>();
  }

  @override
  void dispose() {
    super.dispose();
    dictionaryProvider!.close();
  }

  @override
  Widget build(BuildContext context) {
    MyTheme.initialize(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // SliverAppBar for the header with a search field
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
                    controller: _controller,
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
                            return Padding(
                              padding:
                                  EdgeInsets.only(left: 10.sp, right: 10.sp),
                              child: MyListTile(
                                onTap: () {
                                  // Define what happens when a list item is tapped
                                },
                                leadingText: provider.wordList[index]
                                    .word, // Word as leading text
                                title: provider
                                    .wordList[index].word, // Title with word
                                text: provider.wordList[index]
                                    .definition, // Definition of the word
                                subText: provider
                                    .wordList[index].example, // Example usage
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
