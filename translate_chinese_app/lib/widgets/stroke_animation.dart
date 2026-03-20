import 'dart:ui';

import 'package:flutter/material.dart';

class StrokeByStrokeAnimation extends StatefulWidget {
  final List<List<Offset>> strokes;
  final Duration duration;
  final Color color;

  const StrokeByStrokeAnimation({
    super.key,
    required this.strokes,
    this.duration = const Duration(milliseconds: 1400),
    this.color = const Color(0xFF8B4C44),
  });

  @override
  State<StrokeByStrokeAnimation> createState() => _StrokeByStrokeAnimationState();
}

class _StrokeByStrokeAnimationState extends State<StrokeByStrokeAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _StrokePainter(
            strokes: widget.strokes,
            progress: _controller.value,
            color: widget.color,
          ),
        );
      },
    );
  }
}

class _StrokePainter extends CustomPainter {
  final List<List<Offset>> strokes;
  final double progress; // [0..1]
  final Color color;

  _StrokePainter({
    required this.strokes,
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (strokes.isEmpty) return;

    final n = strokes.length;
    final strokeWidth = size.shortestSide * 0.06;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    for (var i = 0; i < n; i++) {
      final start = i / n;
      final end = (i + 1) / n;
      final perStrokeT = _invLerpClamped(start, end, progress);
      if (perStrokeT <= 0) continue;

      _drawPartialPolyline(
        canvas: canvas,
        size: size,
        paint: paint,
        points: strokes[i],
        t: perStrokeT,
      );
    }
  }

  double _invLerpClamped(double a, double b, double t) {
    if (b - a == 0) return 0;
    return ((t - a) / (b - a)).clamp(0.0, 1.0);
  }

  void _drawPartialPolyline({
    required Canvas canvas,
    required Size size,
    required Paint paint,
    required List<Offset> points,
    required double t,
  }) {
    if (points.length < 2) return;

    final scaled = points
        .map((p) => Offset(p.dx * size.width, p.dy * size.height))
        .toList(growable: false);

    final segCount = scaled.length - 1;
    final floatSeg = t * segCount;
    final fullSegs = floatSeg.floor().clamp(0, segCount);
    final rem = (floatSeg - fullSegs).clamp(0.0, 1.0);

    for (var j = 0; j < fullSegs; j++) {
      canvas.drawLine(scaled[j], scaled[j + 1], paint);
    }

    if (fullSegs < segCount && rem > 0) {
      final a = scaled[fullSegs];
      final b = scaled[fullSegs + 1];
      final p = Offset(
        lerpDouble(a.dx, b.dx, rem)!,
        lerpDouble(a.dy, b.dy, rem)!,
      );
      canvas.drawLine(a, p, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _StrokePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.strokes != strokes ||
        oldDelegate.color != color;
  }
}

