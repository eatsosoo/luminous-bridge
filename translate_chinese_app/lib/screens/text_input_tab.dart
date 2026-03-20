import 'package:flutter/material.dart';

typedef OnTranslated = void Function({
  required String input,
  required String output,
});

class TextInputTab extends StatefulWidget {
  final OnTranslated onTranslated;

  const TextInputTab({
    super.key,
    required this.onTranslated,
  });

  @override
  State<TextInputTab> createState() => _TextInputTabState();
}

class _TextInputTabState extends State<TextInputTab> {
  final TextEditingController _inputController = TextEditingController();

  String _output = '';
  bool _isTranslating = false;

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  Future<void> _translate() async {
    final input = _inputController.text.trim();
    if (input.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter some text first.')),
      );
      return;
    }

    setState(() => _isTranslating = true);
    // Simulate a network translation call.
    await Future.delayed(const Duration(milliseconds: 450));

    final output = _fakeTranslateToChinese(input);
    setState(() {
      _output = output;
      _isTranslating = false;
    });

    widget.onTranslated(input: input, output: output);
  }

  // Placeholder for Stitch-generated styling + your eventual translation backend.
  // For now, it creates a deterministic "translation-looking" result.
  String _fakeTranslateToChinese(String input) {
    final normalized = input.replaceAll(RegExp(r'\s+'), ' ').trim();

    // If it looks ASCII-only, keep it stable/predictable.
    if (RegExp(r'^[\x00-\x7F]*$').hasMatch(normalized)) {
      return 'CN: $normalized';
    }

    return 'CN (placeholder): $normalized';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Tab 1: Text Input',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: _inputController,
                        minLines: 6,
                        maxLines: 10,
                        decoration: const InputDecoration(
                          labelText: 'Enter text',
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        onPressed: _isTranslating ? null : _translate,
                        icon: const Icon(Icons.translate),
                        label: Text(
                          _isTranslating ? 'Translating...' : 'Translate to Chinese',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Result',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        constraints: const BoxConstraints(minHeight: 90),
                        child: _output.isEmpty
                            ? const Text(
                                'Your translated text will appear here.',
                                style: TextStyle(color: Colors.grey),
                              )
                            : SelectableText(
                                _output,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

