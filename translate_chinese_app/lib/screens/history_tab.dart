import 'package:flutter/material.dart';

import '../models/translation_entry.dart';
import '../theme/app_colors.dart';

class HistoryTab extends StatelessWidget {
  final List<TranslationEntry> history;

  const HistoryTab({
    super.key,
    required this.history,
  });

  String _formatTime(DateTime dt) {
    final hh = dt.hour.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: history.isEmpty
            ? const Center(
                child: Text(
                  'No translations yet.',
                  style: TextStyle(color: AppColors.captionMuted),
                ),
              )
            : ListView.separated(
                itemCount: history.length,
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final entry = history[index];
                  return Card(
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.output.isEmpty ? '(empty)' : entry.output,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Input: ${entry.input}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _formatTime(entry.at),
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

