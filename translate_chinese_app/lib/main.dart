import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'models/translation_entry.dart';
import 'theme/app_colors.dart';
import 'pages/library_page.dart';
import 'pages/learn_page.dart';
import 'pages/profile_page.dart';
import 'pages/review_page.dart';
import 'widgets/bottom_nav_bar.dart';

void main() {
  runApp(const TranslateToChineseApp());
}

class TranslateToChineseApp extends StatelessWidget {
  const TranslateToChineseApp({super.key});

  @override
  Widget build(BuildContext context) {
    final baseTextTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.seed),
      useMaterial3: true,
    ).textTheme;
    final notoSansSc = GoogleFonts.notoSansSc();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Luminous Bridge',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.seed),
        useMaterial3: true,
        textTheme: GoogleFonts.notoSansTextTheme(baseTextTheme),
        fontFamily: GoogleFonts.notoSans().fontFamily,
        fontFamilyFallback: [
          if (notoSansSc.fontFamily != null) notoSansSc.fontFamily!,
        ],
      ),
      home: const TranslateHome(),
    );
  }
}

class TranslateHome extends StatefulWidget {
  const TranslateHome({super.key});

  @override
  State<TranslateHome> createState() => _TranslateHomeState();
}

class _TranslateHomeState extends State<TranslateHome> {
  int _selectedIndex = 0;
  final List<TranslationEntry> _history = [];

  void _handleTranslated({
    required String input,
    required String output,
  }) {
    setState(() {
      _history.insert(
        0,
        TranslationEntry(
          at: DateTime.now(),
          input: input,
          output: output,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      LearnPage(onTranslated: _handleTranslated),
      ReviewPage(history: _history),
      const LibraryPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onSelected: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}
