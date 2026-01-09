import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kiosk/features/utility/enum/enum_welcome_feature.dart';

import '../../../../../features/utility/const/constant_color.dart';
import '../../../../../features/utility/const/constant_string.dart';
import '../../cubit/patient_login_cubit.dart';

class BouncingBallsPage extends StatefulWidget {
  final Color color;
  const BouncingBallsPage({super.key, required this.color});

  @override
  State<BouncingBallsPage> createState() => _BouncingBallsPageState();
}

class _BouncingBallsPageState extends State<BouncingBallsPage>
    with SingleTickerProviderStateMixin {
  // Animation controller used only to drive the dashed-outline rotation.
  late final AnimationController _controller;

  final List<_Ball> _balls = [];
  Size? _screenSize;

  final double _centerRadius = 100; // ortadaki sabit yuvarlak
  // hareket eden küçük yuvarlaklar WelcomeFeature enum'undaki elemanları temsil edecek
  late final List<WelcomeFeature> _features;

  @override
  void initState() {
    super.initState();
    // features/balls will be placed statically based on their enum-defined positions
    // but we keep a controller running to animate the dashed-outline rotation.
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 8))
          ..addListener(() {
            // repaint to update dashed outline phase
            setState(() {});
          });
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _initBallsIfNeeded() {
    if (_screenSize == null || _balls.isNotEmpty) return;

    final size = _screenSize!;
    _features = WelcomeFeature.values;

    for (int i = 0; i < _features.length; i++) {
      // Fixed ball radius for visibility
      final radius = 110.0;

      // Place each feature at the percentage position defined in the enum
      final percent = _features[i].positionPercent;
      final position = Offset(
        size.width * percent.dx,
        size.height * percent.dy,
      );

      _balls.add(
        _Ball(
          position: position,
          // static: no movement
          velocity: Offset.zero,
          radius: radius,
          // store an opaque copy of the provided color to avoid accidental
          // translucency coming from earlier code paths (ensure alpha = 255)
          color: widget.color.withOpacity(1.0),
          feature: _features[i],
        ),
      );
    }
  }

  // No per-frame physics needed since features are static; _tick removed.

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _screenSize = Size(constraints.maxWidth, constraints.maxHeight);
        _initBallsIfNeeded();

        // center button size (increased for better visibility)
        final centerButtonSize = 200.0;

        return Scaffold(
          body: Stack(
            children: [
              // background painter (pass controller.value as dash phase)
              CustomPaint(
                painter: _BallsPainter(
                  balls: _balls,
                  centerRadius: _centerRadius,
                  dashPhase: _controller.value,
                ),
                child: const SizedBox.expand(),
              ),

              // overlay icons and labels for each moving ball (rendered as widgets so
              // we can use the enum's Widget-returning icon function)
              ..._balls.map((ball) {
                final left = ball.position.dx - ball.radius;
                final top = ball.position.dy - ball.radius;
                return Positioned(
                  left: left,
                  top: top,
                  width: ball.radius * 2,
                  height: ball.radius * 2,
                  child: IgnorePointer(
                    ignoring: true,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // icon widget from enum
                          ball.feature.icon(widget.color),
                          const SizedBox(height: 6),
                          Text(
                            ball.feature.label,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: widget.color,
                              fontSize: max(10, ball.radius / 5),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),

              // centered circular button on top of the painted center circle
              Center(
                child: SizedBox(
                  width: centerButtonSize,
                  height: centerButtonSize,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: EdgeInsets.zero,
                      foregroundColor: widget.color,
                      side: BorderSide(color: widget.color, width: 2),
                    ),
                    onPressed: () {
                      try {
                        context.read<PatientLoginCubit>().gotoAuth();
                      } catch (_) {}
                    },
                    icon: Icon(Icons.play_circle_fill, size: 40),
                    label: Text(
                      ConstantString().start,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: widget.color,
                          ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Ball {
  _Ball({
    required this.position,
    required this.velocity,
    required this.radius,
    required this.color,
    required this.feature,
  });

  Offset position;
  Offset velocity;
  double radius;
  Color color;
  WelcomeFeature feature;
}

class _BallsPainter extends CustomPainter {
  _BallsPainter({
    required this.balls,
    required this.centerRadius,
    this.dashPhase = 0.0,
  });

  final List<_Ball> balls;
  final double centerRadius;

  /// Phase in range [0..1) used to rotate the dashed outline; 1.0 -> full turn
  final double dashPhase;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Ortadaki sabit yuvarlak
    final centerPaint = Paint()
      ..color = ConstColor.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, centerRadius, centerPaint);

    // Kenar çizgisi
    final borderPaint = Paint()
      ..color = ConstColor.grey700
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(center, centerRadius, borderPaint);

    // Hareketli toplar
    for (final ball in balls) {
      // draw a dashed connecting line from the center button edge to the ball edge
      final diffLine = ball.position - center;
      final distLine = diffLine.distance;
      if (distLine > 0.0) {
        final dir = diffLine / distLine;
        final startPoint = center + dir * centerRadius; // from center edge
        final endPoint = ball.position - dir * ball.radius; // to ball edge
        final effectiveColor = ball.color.withOpacity(1.0);
        final linePaint = Paint()
          ..color = effectiveColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = max(1.0, ball.radius * 0.06);
        final dashLen = max(6.0, ball.radius * 0.12);
        final gapLen = dashLen * 0.6;
        _drawDashedLine(
          canvas,
          startPoint,
          endPoint,
          linePaint,
          dashLen,
          gapLen,
        );
      }

      final paint = Paint()
        ..color = ConstColor.white
        ..style = PaintingStyle.fill;

      canvas.drawCircle(ball.position, ball.radius, paint);

      // Draw the dashed outline around the ball
      final outlinePaint = Paint()
        // ensure outline uses the fully opaque provided color
        ..color = ball.color.withOpacity(1.0)
        ..style = PaintingStyle.stroke
        ..strokeWidth = max(2.0, ball.radius * 0.08);
      final dashForCircle = max(8.0, ball.radius * 0.18);
      final gapForCircle = dashForCircle * 0.6;
      _drawDashedCircle(
        canvas,
        ball.position,
        ball.radius + 2.0,
        outlinePaint,
        dashForCircle,
        gapForCircle,
        phase: dashPhase,
      );

      // Icon and label are rendered as overlay widgets (Positioned) above the painter.
    }
  }

  void _drawDashedLine(
    Canvas canvas,
    Offset p1,
    Offset p2,
    Paint paint,
    double dashLength,
    double gapLength,
  ) {
    final diff = p2 - p1;
    final dist = diff.distance;
    if (dist == 0) return;
    final dir = diff / dist;
    double drawn = 0.0;
    while (drawn < dist) {
      final start = p1 + dir * drawn;
      final segLen = min(dashLength, dist - drawn);
      final end = start + dir * segLen;
      canvas.drawLine(start, end, paint);
      drawn += segLen + gapLength;
    }
  }

  void _drawDashedCircle(
    Canvas canvas,
    Offset center,
    double radius,
    Paint paint,
    double dashLength,
    double gapLength, {
    double phase = 0.0,
  }) {
    // phase is 0..1 representing rotation of the dash pattern around the circle
    final circumference = 2 * pi * radius;
    if (circumference <= 0) return;
    final step = dashLength + gapLength;
    final segments = (circumference / step).floor();
    if (segments <= 0) return;
    final rect = Rect.fromCircle(center: center, radius: radius);
    final phaseOffset = (phase % 1.0) * 2 * pi;
    for (int i = 0; i < segments; i++) {
      final startAngle = (i * step) / circumference * 2 * pi + phaseOffset;
      final sweep = (dashLength / circumference) * 2 * pi;
      canvas.drawArc(rect, startAngle, sweep, false, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _BallsPainter oldDelegate) {
    return true; // her frame çiz
  }
}
