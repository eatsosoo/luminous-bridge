import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stroke_order_animator/stroke_order_animator.dart';

import '../mock/hanzii_mock_data.dart';
import 'stroke_animation.dart';

class HanziDetailPopup extends StatelessWidget {
  final CharacterStudyItem item;
  final VoidCallback onClose;

  const HanziDetailPopup({
    super.key,
    required this.item,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      item.character,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 46,
                        fontWeight: FontWeight.w900,
                        height: 1,
                        color: Color(0xFF8B4C44),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: onClose,
                    icon: const Icon(Icons.close_rounded),
                    color: const Color(0xFF8B4C44),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                item.meaning,
                style: TextStyle(
                  color: Colors.brown.shade700,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Pinyin: ${item.pinyin}',
                style: TextStyle(
                  color: Colors.brown.withValues(alpha: 0.85),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: 240,
                height: 240,
                child: HanziStrokeOrder(character: item.character, strokes: item.strokes),
              ),
              const SizedBox(height: 10),
              const Text(
                'Tap a character to view strokes.',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 8),
              FilledButton(
                onPressed: onClose,
                child: const Text('Done'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HanziStrokeOrder extends StatefulWidget {
  final String character;
  final List<List<Offset>> strokes; // used as fallback

  const HanziStrokeOrder({
    super.key,
    required this.character,
    required this.strokes,
  });

  @override
  State<HanziStrokeOrder> createState() => _HanziStrokeOrderState();
}

class _HanziStrokeOrderState extends State<HanziStrokeOrder>
    with TickerProviderStateMixin {
  final http.Client _httpClient = http.Client();
  StrokeOrderAnimationController? _controller;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final strokeOrderJson = await downloadStrokeOrder(widget.character, _httpClient);
      final controller = StrokeOrderAnimationController(
        StrokeOrder(strokeOrderJson),
        this,
        showStroke: true,
        showOutline: true,
        showBackground: false,
      );
      if (!mounted) return;
      setState(() {
        _controller = controller;
        _error = null;
      });
      controller.startAnimation();
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _httpClient.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || _error != null) {
      return StrokeByStrokeAnimation(strokes: widget.strokes);
    }

    return StrokeOrderAnimator(
      _controller!,
      size: const Size(240, 240),
      // UniqueKey ensures the widget rebuilds the animation when character changes.
      key: ValueKey(widget.character),
    );
  }
}

