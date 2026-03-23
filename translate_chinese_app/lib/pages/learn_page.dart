import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:translate_chinese_app/widgets/top_bar.dart';

import '../mock/hanzii_mock_data.dart';
import '../theme/app_colors.dart';
import 'character_study_page.dart';

typedef OnTranslated =
    void Function({required String input, required String output});

class LearnPage extends StatefulWidget {
  final OnTranslated onTranslated;

  const LearnPage({super.key, required this.onTranslated});

  @override
  State<LearnPage> createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage> {
  final TextEditingController _inputController = TextEditingController();
  bool _isConverting = false;
  String _output = '';
  bool _showStudy = false;

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  int get _characterCount => _inputController.text.characters.length;

  Future<void> _convert() async {
    final input = _inputController.text.trim();
    if (input.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter some text first.')),
      );
      return;
    }

    setState(() => _isConverting = true);

    // Placeholder conversion. Replace with a real Stitch/translation call later.
    await Future.delayed(const Duration(milliseconds: 450));
    final output = _fakeTranslateToChinese(input);

    setState(() {
      _isConverting = false;
      _output = output;
    });

    widget.onTranslated(input: input, output: output);

    // For UI preview: after converting, switch to the Hanzi study screen.
    setState(() {
      _showStudy = true;
    });
  }

  String _fakeTranslateToChinese(String input) {
    final normalized = input.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (RegExp(r'^[\x00-\x7F]*$').hasMatch(normalized)) {
      return 'CN: $normalized';
    }
    return 'CN (placeholder): $normalized';
  }

  void _copyInput() {
    final text = _inputController.text;
    if (text.trim().isEmpty) return;
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Copied input.')));
  }

  @override
  Widget build(BuildContext context) {
    if (_showStudy) {
      return CharacterStudyPage(
        onBack: () => setState(() => _showStudy = false),
        items: hanziPhraseItems,
      );
    }

    return SafeArea(
      bottom: false,

      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTopBar(
                title: 'The Luminous Bridge',
                streak: 7,
                avatarUrl: null, // hoặc link ảnh
                onSettingsTap: () {
                  setState(() => _showStudy = true);
                },
              ),

              const SizedBox(height: 14),

              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.chipBlush,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text(
                    'Tiếng Việt ⇔ Hán Tự',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // ENTER TEXT takes remaining vertical space.
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(18),
                  margin: const EdgeInsets.symmetric(horizontal: 18),
                  decoration: BoxDecoration(
                    color: AppColors.fieldInput,
                    boxShadow: const [AppColors.shadowFieldInput],
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'ENTER TEXT',
                        style: TextStyle(
                          letterSpacing: 1.5,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textFieldLabel,
                        ),
                      ),
                      const SizedBox(height: 10),

                      Expanded(
                        child: TextField(
                          controller: _inputController,
                          expands: true,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          textAlignVertical: TextAlignVertical.top,
                          style: const TextStyle(fontSize: 18),
                          decoration: InputDecoration(
                            hintText: 'Nhập văn bản tiếng Việt hoặc chữ Hán...',
                            hintStyle: const TextStyle(
                              color: AppColors.textHint,
                              fontSize: 18,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                          ),
                          onChanged: (_) {
                            // Trigger rebuild for character counter.
                            setState(() {});
                          },
                        ),
                      ),

                      const SizedBox(height: 18),
                      Divider(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        height: 1,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            '$_characterCount characters',
                            style: TextStyle(
                              color: AppColors.primary.withValues(alpha: 0.5),
                              fontSize: 12,
                            ),
                          ),
                          const Spacer(),
                          const Icon(Icons.mic_none, color: AppColors.primary),
                          const SizedBox(width: 14),
                          IconButton(
                            onPressed: _copyInput,
                            icon: const Icon(
                              Icons.copy_rounded,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 18),

              InkWell(
                onTap: _isConverting ? null : _convert,
                borderRadius: BorderRadius.circular(999),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 18),
                  height: 64,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryDark],
                    ),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.translate_rounded,
                        color: AppColors.surface.withValues(alpha: 0.95),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Convert Now',
                        style: const TextStyle(
                          color: AppColors.surface,
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 18),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  children: [
                    Expanded(
                      child: _featureTile(
                        icon: Icons.history_rounded,
                        title: 'Review Recent Bridge',
                        onTap: () {
                          // Switch tab in parent via callback if needed.
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Review will open on the next tab.',
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _featureTile(
                        icon: Icons.tips_and_updates_rounded,
                        title: 'Pinyin & Stroke Order Tips',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Tips screen coming soon.'),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Optional conversion result (not shown in your screenshot).
              if (_output.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 14),
                  child: Text(
                    _output,
                    style: const TextStyle(color: AppColors.textFieldLabel),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _featureTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
        decoration: BoxDecoration(
          color: AppColors.tileCream,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: AppColors.textFieldLabel.withValues(alpha: 0.9),
                  fontWeight: FontWeight.w700,
                  fontSize: 12.5,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
