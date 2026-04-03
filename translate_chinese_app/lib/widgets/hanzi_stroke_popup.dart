import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stroke_order_animator/stroke_order_animator.dart';
import 'package:translate_chinese_app/theme/app_colors.dart';

class HanziStrokePopup extends StatefulWidget {
  final String text; // có thể nhiều ký tự
  final String? pinyin;

  const HanziStrokePopup({super.key, required this.text, this.pinyin});

  @override
  State<HanziStrokePopup> createState() => _HanziStrokePopupState();
}

class _HanziStrokePopupState extends State<HanziStrokePopup>
    with TickerProviderStateMixin {
  final _httpClient = http.Client();

  StrokeOrderAnimationController? _controller;
  late Future<void> _future;

  int _currentIndex = 0;

  String get _currentChar => widget.text.characters.elementAt(_currentIndex);

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<void> _load() async {
    final data = await downloadStrokeOrder(_currentChar, _httpClient);

    _controller?.dispose();

    _controller = StrokeOrderAnimationController(
      StrokeOrder(data),
      this,
      strokeAnimationSpeed: 2,
      strokeColor: Colors.black87,
    );

    setState(() {});

    _controller!.startAnimation();
  }

  void _changeChar(int index) {
    setState(() {
      _currentIndex = index;
      _future = _load();
    });
  }

  void _rewrite() {
    _controller!.reset();
    _controller!.startAnimation();
  }

  void _startAudio() {}

  @override
  void dispose() {
    _controller?.dispose();
    _httpClient.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chars = widget.text.characters.toList();

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: 240,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: FutureBuilder<void>(
          future: _future,
          builder: (context, snapshot) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🔥 TOP: nhiều ký tự
                Container(
                  decoration: BoxDecoration(color: AppColors.titleBar),
                  padding: EdgeInsetsGeometry.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Wrap(
                            alignment: WrapAlignment.start,
                            spacing: 2,
                            children: List.generate(chars.length, (index) {
                              final isActive = index == _currentIndex;

                              return GestureDetector(
                                onTap: () => _changeChar(index),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 0,
                                    horizontal: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isActive
                                        ? Colors.orange.withOpacity(0.2)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    chars[index],
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: isActive
                                          ? Colors.orange
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                          const SizedBox(height: 4),
                          // 🔤 Pinyin
                          if (widget.pinyin != null)
                            Text(
                              widget.pinyin!,
                              style: const TextStyle(color: Colors.grey),
                            ),
                        ],
                      ),

                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppColors.cardPink,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: IconButton(
                          onPressed: () => _startAudio(),
                          icon: Icon(Icons.volume_up, size: 16),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                Padding(
                  padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Stroke Order'.toUpperCase(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      IconButton(
                        onPressed: () => _rewrite(),
                        icon: Icon(
                          Icons.replay_outlined,
                          color: AppColors.textSecondary,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 4),

                // ✍️ Animation
                if (_controller == null)
                  const SizedBox(
                    height: 200,
                    child: Center(child: CircularProgressIndicator()),
                  )
                else
                  SizedBox(
                    width: 240,
                    height: 240,
                    child: HanziGrid(
                      child: StrokeOrderAnimator(
                        _controller!,
                        size: const Size(240, 240),
                      ),
                    ),
                  ),

                const SizedBox(height: 16),
              ],
            );
          },
        ),
      ),
    );
  }
}

class HanziGrid extends StatelessWidget {
  final Widget child;

  const HanziGrid({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _HanziGridPainter(), child: child);
  }
}

class _HanziGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..strokeWidth = 1;

    final w = size.width;
    final h = size.height;

    final bgPaint = Paint()
      ..color = AppColors.cardPink
      ..strokeWidth = 1;

    // 🔲 khung ngoài
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), bgPaint);

    // ➕ dọc
    canvas.drawLine(Offset(w / 2, 0), Offset(w / 2, h), paint);

    // ➖ ngang
    canvas.drawLine(Offset(0, h / 2), Offset(w, h / 2), paint);

    // ✖️ chéo
    canvas.drawLine(Offset(0, 0), Offset(w, h), paint);
    canvas.drawLine(Offset(w, 0), Offset(0, h), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
