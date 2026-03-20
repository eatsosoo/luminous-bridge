import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../mock/hanzii_mock_data.dart';
import 'character_study_page.dart';

typedef OnTranslated = void Function({
  required String input,
  required String output,
});

class LearnPage extends StatefulWidget {
  final OnTranslated onTranslated;

  const LearnPage({
    super.key,
    required this.onTranslated,
  });

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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied input.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_showStudy) {
      return CharacterStudyPage(
        onBack: () => setState(() => _showStudy = false),
        items: hanziPhraseItems,
      );
    }

    const gradientStart = Color(0xFF8B4C44);
    const gradientEnd = Color(0xFF6F3A33);

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 90),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE4E0),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.auto_awesome, color: Color(0xFF8B4C44)),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'The Luminous Bridge',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF8B4C44),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                onPressed: () => setState(() => _showStudy = true),
                    icon: const Icon(Icons.settings_outlined),
                    color: const Color(0xFF8B4C44),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD0CB),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text(
                    'Tiếng Việt ⇔ Hàn Tự',
                    style: TextStyle(
                      color: Color(0xFF8B4C44),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.55),
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
                        color: Colors.brown.shade700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _inputController,
                      minLines: 6,
                      maxLines: 10,
                      style: const TextStyle(fontSize: 18),
                      decoration: InputDecoration(
                        hintText: 'Nhập văn bản tiếng Việt hoặc chữ Hàn...',
                        hintStyle: const TextStyle(color: Colors.black26, fontSize: 18),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                      onChanged: (_) {
                        // Trigger rebuild for character counter.
                        setState(() {});
                      },
                    ),

                    const SizedBox(height: 18),
                    Divider(color: Colors.brown.withValues(alpha: 0.15), height: 1),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          '$_characterCount characters',
                          style: TextStyle(
                            color: Colors.brown.withValues(alpha: 0.5),
                            fontSize: 12,
                          ),
                        ),
                        const Spacer(),
                        const Icon(Icons.mic_none, color: Color(0xFF8B4C44)),
                        const SizedBox(width: 14),
                        IconButton(
                          onPressed: _copyInput,
                          icon: const Icon(Icons.copy_rounded, color: Color(0xFF8B4C44)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              InkWell(
                onTap: _isConverting ? null : _convert,
                borderRadius: BorderRadius.circular(999),
                child: Container(
                  height: 64,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [gradientStart, gradientEnd],
                    ),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.translate_rounded,
                        color: Colors.white.withValues(alpha: 0.95),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '转换 Convert Now',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 18),

              Row(
                children: [
                  Expanded(
                    child: _featureTile(
                      icon: Icons.history_rounded,
                      title: 'Review Recent Bridge',
                      onTap: () {
                        // Switch tab in parent via callback if needed.
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Review will open on the next tab.')),
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
                          const SnackBar(content: Text('Tips screen coming soon.')),
                        );
                      },
                    ),
                  ),
                ],
              ),

              // Optional conversion result (not shown in your screenshot).
              if (_output.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 14),
                  child: Text(
                    _output,
                    style: TextStyle(color: Colors.brown.shade700),
                  ),
                ),
            ],
          ),
        ),
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
          color: const Color(0xFFFFF0EF),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF8B4C44)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.brown.withValues(alpha: 0.9),
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

