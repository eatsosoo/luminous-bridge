import 'package:flutter/material.dart';

import '../mock/hanzii_mock_data.dart';
import '../widgets/hanzi_popup.dart';

class CharacterStudyPage extends StatelessWidget {
  final VoidCallback onBack;
  final List<CharacterStudyItem> items;

  const CharacterStudyPage({
    super.key,
    required this.onBack,
    required this.items,
  });

  void _showPopup(BuildContext context, CharacterStudyItem item) {
    showDialog<void>(
      context: context,
      builder: (context) => HanziDetailPopup(
        item: item,
        onClose: () => Navigator.of(context).pop(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const pinkCard = Color(0xFFFBEAE6);
    const brown = Color(0xFF8B4C44);

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  color: Colors.white,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: onBack,
                        icon: const Icon(Icons.arrow_back_rounded),
                        color: brown,
                      ),
                      const SizedBox(width: 2),
                      const Expanded(
                        child: Text(
                          'The Luminous Bridge',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: brown,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.more_horiz_rounded),
                        color: brown,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  'Current',
                  style: TextStyle(
                    fontSize: 12,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFB0907F),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Intermediate',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF3B2B27),
                  ),
                ),

                const SizedBox(height: 18),

                Center(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: items.map((it) {
                          return GestureDetector(
                            onTap: () => _showPopup(context, it),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              child: Column(
                                children: [
                                  Text(
                                    it.character,
                                    style: const TextStyle(
                                      fontSize: 56,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF3B2B27),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    it.pinyin,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: brown.withValues(alpha: 0.8),
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
                        children: const [
                          Icon(Icons.play_arrow_rounded, color: brown),
                          SizedBox(width: 8),
                          Text(
                            'Full Breakdown',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: brown,
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
                        big: '04',
                        bg: pinkCard,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _infoCard(
                        icon: Icons.speed_rounded,
                        title: 'FLUENCY SCORE',
                        big: '82%',
                        bg: pinkCard,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: pinkCard,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF2D8D0),
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
                                color: Color(0xFF8B4C44),
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              'The character 在 (zài) is often used before verbs to indicate an action in progress, similar to “-ing” in English.',
                              style: TextStyle(
                                fontSize: 13,
                                height: 1.4,
                                color: Color(0xFF6B4A43),
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
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoCard({
    required IconData icon,
    required String title,
    required String big,
    required Color bg,
  }) {
    const brown = Color(0xFF8B4C44);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: brown.withValues(alpha: 0.9)),
          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              color: brown.withValues(alpha: 0.9),
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
              color: Color(0xFF3B2B27),
            ),
          ),
        ],
      ),
    );
  }
}

