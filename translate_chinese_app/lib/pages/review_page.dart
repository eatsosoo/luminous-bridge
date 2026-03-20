import 'package:flutter/material.dart';

import '../models/translation_entry.dart';
import '../screens/history_tab.dart';

class ReviewPage extends StatelessWidget {
  final List<TranslationEntry> history;

  const ReviewPage({
    super.key,
    required this.history,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF7E8E5),
      child: HistoryTab(history: history),
    );
  }
}

