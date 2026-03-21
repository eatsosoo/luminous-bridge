import 'package:flutter/material.dart';

import '../models/translation_entry.dart';
import '../theme/app_colors.dart';
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
      color: AppColors.scaffoldBackground,
      child: HistoryTab(history: history),
    );
  }
}

