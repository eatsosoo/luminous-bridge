import 'package:flutter/material.dart';
import 'package:translate_chinese_app/models/translate_model.dart';
import 'package:translate_chinese_app/theme/app_colors.dart';
import 'package:translate_chinese_app/widgets/hanzi_stroke_popup.dart';
import 'package:translate_chinese_app/widgets/top_bar.dart';

class CharacterStudyPage extends StatelessWidget {
  final TranslateResponse data;

  const CharacterStudyPage({super.key, required this.data});

  void _showTokenPopup(BuildContext context, Token token) {
    if (token.type != 'word') return;

    showDialog(
      context: context,
      builder: (_) =>
          HanziStrokePopup(text: token.text, pinyin: token.pinyin),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sentence = data.sentences.first;
    final tokens = sentence.tokens;

    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTopBar(
                title: 'The Luminous Bridge',
                streak: 7,
                avatarUrl: null, // hoặc link ảnh
                onSettingsTap: () => {},
              ),

              const SizedBox(height: 10),

              const Text(
                'Current',
                style: TextStyle(
                  fontSize: 12,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Intermediate',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 18),

              Text(
                sentence.meaning,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),

              Center(
                child: Column(
                  children: [
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 6,
                      children: tokens.map((token) {
                        if (token.type == 'punctuation') {
                          return Text(
                            token.text,
                            style: const TextStyle(fontSize: 28),
                          );
                        }

                        return GestureDetector(
                          onTap: () => _showTokenPopup(context, token),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Column(
                              children: [
                                Text(
                                  token.text,
                                  style: const TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  token.pinyin ?? '',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary.withValues(
                                      alpha: 0.8,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.play_arrow_rounded,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Full Breakdown',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _infoCard(
                      icon: Icons.auto_stories_rounded,
                      title: 'NEW WORDS',
                      big:
                          '${data.sentences.first.tokens.where((e) => e.type == "word").length}',
                      bg: AppColors.cardPink,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _infoCard(
                      icon: Icons.speed_rounded,
                      title: 'FLUENCY SCORE',
                      big: '82%',
                      bg: AppColors.cardPink,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardPink,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: AppColors.cardPinkAccent,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.lightbulb_outline_rounded),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Pro Tip',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              color: AppColors.primary,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'The character 在 (zài) is often used before verbs to indicate an action in progress, similar to “-ing” in English.',
                            style: TextStyle(
                              fontSize: 13,
                              height: 1.4,
                              color: AppColors.textOnTint,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }

  Widget _infoCard({
    required IconData icon,
    required String title,
    required String big,
    required Color bg,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary.withValues(alpha: 0.9)),
          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              color: AppColors.primary.withValues(alpha: 0.9),
              fontSize: 12,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            big,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
