// lib/presentation/widgets/pintig_icons.dart
// Pintig icon set: rounded strokes and one coral dot, drawn to echo the logo's
// loop-and-dot mark. Paths use absolute M, L, C, Z on a 24x24 grid and are the
// same data as portal_web/src/components/PintigIcons.tsx.
import 'package:flutter/material.dart';
import '../theme/pintig_tokens.dart';

enum PintigIconName {
  prenatal,
  child,
  vaccine,
  send,
  saved,
  waiting,
  alert,
  calendar,
  chevronR,
  chevronL,
  pin,
  check,
  refer,
  map,
  report,
  search,
  standing,
  recumbent,
  info,
}

class _IconSpec {
  final List<String> paths;
  final List<List<double>> dots;
  const _IconSpec(this.paths, this.dots);
}

const Map<PintigIconName, _IconSpec> _specs = {
  PintigIconName.prenatal: _IconSpec(
    [
      'M12.5 5 C12.5 6.38075 11.380749999999999 7.5 10 7.5 C8.619250000000001 7.5 7.5 6.38075 7.5 5 C7.5 3.61925 8.619250000000001 2.5 10 2.5 C11.380749999999999 2.5 12.5 3.61925 12.5 5 Z',
      'M10 9.5 C7.5 10.5 7 13 8 16 L8.5 21',
      'M10 9.5 C13 9.5 16.5 12 16.5 15.5 C16.5 18 14.5 19.5 12.5 19.5 L12.5 21',
    ],
    [[13.2, 14.6, 1.3]],
  ),
  PintigIconName.child: _IconSpec(
    [
      'M14.5 5.5 C14.5 6.88075 13.380749999999999 8.0 12 8.0 C10.619250000000001 8.0 9.5 6.88075 9.5 5.5 C9.5 4.11925 10.619250000000001 3.0 12 3.0 C13.380749999999999 3.0 14.5 4.11925 14.5 5.5 Z',
      'M12 9.5 C9 9.5 7.5 12 7.5 14.5 L7.5 21 L16.5 21 L16.5 14.5 C16.5 12 15 9.5 12 9.5 Z',
    ],
    [[12, 15.3, 1.3]],
  ),
  PintigIconName.vaccine: _IconSpec(
    [
      'M7 13 L11 17 L17.5 10.5 L13.5 6.5 Z',
      'M9 15 L4.5 19.5',
      'M15.5 8.5 L18.5 5.5',
      'M17 4 L20 7',
    ],
    [[12.25, 11.75, 1.1]],
  ),
  PintigIconName.send: _IconSpec(
    [
      'M19 12 C19 8 15.5 5 12 5 C9.5 5 7.5 6.2 6.2 8',
      'M6 4.5 L6.2 8 L9.8 8.3',
      'M5 12 C5 16 8.5 19 12 19 C14.5 19 16.5 17.8 17.8 16',
      'M18 19.5 L17.8 16 L14.2 15.7',
    ],
    [[12, 12, 1.6]],
  ),
  PintigIconName.saved: _IconSpec(
    [
      'M7 3 L17 3 C18.1 3 19 3.9 19 5 L19 19 C19 20.1 18.1 21 17 21 L7 21 C5.9 21 5 20.1 5 19 L5 5 C5 3.9 5.9 3 7 3 Z',
      'M8.8 11.3 L11 13.5 L15.4 8.8',
    ],
    [[12, 17.6, 1]],
  ),
  PintigIconName.waiting: _IconSpec(
    [
      'M20.5 12 C20.5 16.69455 16.69455 20.5 12 20.5 C7.3054499999999996 20.5 3.5 16.69455 3.5 12 C3.5 7.3054499999999996 7.3054499999999996 3.5 12 3.5 C16.69455 3.5 20.5 7.3054499999999996 20.5 12 Z',
      'M12 12 L12 7.5',
      'M12 12 L15.2 14',
    ],
    [[12, 12, 1.5]],
  ),
  PintigIconName.alert: _IconSpec(
    [
      'M8.5 8.5 C6.2 10.8 6.2 13.2 8.5 15.5',
      'M5.5 5.5 C1.8 9.3 1.8 14.7 5.5 18.5',
      'M15.5 8.5 C17.8 10.8 17.8 13.2 15.5 15.5',
      'M18.5 5.5 C22.2 9.3 22.2 14.7 18.5 18.5',
    ],
    [[12, 12, 2.2]],
  ),
  PintigIconName.calendar: _IconSpec(
    [
      'M5 6 L19 6 C20.1 6 21 6.9 21 8 L21 19 C21 20.1 20.1 21 19 21 L5 21 C3.9 21 3 20.1 3 19 L3 8 C3 6.9 3.9 6 5 6 Z',
      'M3 10.5 L21 10.5',
      'M8 3.5 L8 7.5',
      'M16 3.5 L16 7.5',
    ],
    [[12, 15.5, 1.4]],
  ),
  PintigIconName.chevronR: _IconSpec(
    [
      'M9 5 C11.5 8 14 10 15.5 12 C14 14 11.5 16 9 19',
    ],
    [],
  ),
  PintigIconName.chevronL: _IconSpec(
    [
      'M15 5 C12.5 8 10 10 8.5 12 C10 14 12.5 16 15 19',
    ],
    [],
  ),
  PintigIconName.pin: _IconSpec(
    [
      'M12 21 C12 21 5.5 15 5.5 10 C5.5 6.4 8.4 3.5 12 3.5 C15.6 3.5 18.5 6.4 18.5 10 C18.5 15 12 21 12 21 Z',
    ],
    [[12, 10, 2.2]],
  ),
  PintigIconName.check: _IconSpec(
    [
      'M5 12.5 L10 17.5 L19 7',
    ],
    [],
  ),
  PintigIconName.refer: _IconSpec(
    [
      'M14 4 L20 4 L20 10',
      'M20 4 L11 13',
      'M17 14 L17 18 C17 19.1 16.1 20 15 20 L6 20 C4.9 20 4 19.1 4 18 L4 9 C4 7.9 4.9 7 6 7 L10 7',
    ],
    [[8.5, 16, 1.2]],
  ),
  PintigIconName.map: _IconSpec(
    [
      'M3 6 L9 4 L15 6 L21 4 L21 18 L15 20 L9 18 L3 20 Z',
      'M9 4 L9 18',
      'M15 6 L15 20',
    ],
    [[12, 12, 1.4]],
  ),
  PintigIconName.report: _IconSpec(
    [
      'M7 3 L14.5 3 L19 7.5 L19 19 C19 20.1 18.1 21 17 21 L7 21 C5.9 21 5 20.1 5 19 L5 5 C5 3.9 5.9 3 7 3 Z',
      'M14 3 L14 8 L19 8',
      'M8.5 12.5 L15.5 12.5',
    ],
    [[11, 16.5, 1.2]],
  ),
  PintigIconName.search: _IconSpec(
    [
      'M16.5 10.5 C16.5 13.8138 13.8138 16.5 10.5 16.5 C7.1861999999999995 16.5 4.5 13.8138 4.5 10.5 C4.5 7.1861999999999995 7.1861999999999995 4.5 10.5 4.5 C13.8138 4.5 16.5 7.1861999999999995 16.5 10.5 Z',
      'M15 15 L20 20',
    ],
    [[10.5, 10.5, 1.5]],
  ),
  PintigIconName.standing: _IconSpec(
    [
      'M14 4.5 C14 5.6046 13.1046 6.5 12 6.5 C10.8954 6.5 10 5.6046 10 4.5 C10 3.3954 10.8954 2.5 12 2.5 C13.1046 2.5 14 3.3954 14 4.5 Z',
      'M12 8 L12 15',
      'M8.5 10 L15.5 10',
      'M12 15 L9.5 21',
      'M12 15 L14.5 21',
    ],
    [],
  ),
  PintigIconName.recumbent: _IconSpec(
    [
      'M7 12.5 C7 13.6046 6.1046 14.5 5 14.5 C3.8954 14.5 3 13.6046 3 12.5 C3 11.3954 3.8954 10.5 5 10.5 C6.1046 10.5 7 11.3954 7 12.5 Z',
      'M8 12.5 L16 12.5',
      'M16 12.5 L21 10.5',
      'M16 12.5 L21 15.5',
      'M3 19 L21 19',
    ],
    [],
  ),
  PintigIconName.info: _IconSpec(
    [
      'M20.5 12 C20.5 16.69455 16.69455 20.5 12 20.5 C7.3054499999999996 20.5 3.5 16.69455 3.5 12 C3.5 7.3054499999999996 7.3054499999999996 3.5 12 3.5 C16.69455 3.5 20.5 7.3054499999999996 20.5 12 Z',
      'M12 11 L12 16.5',
    ],
    [[12, 7.6, 1.2]],
  ),
};

final Map<String, Path> _pathCache = {};

Path _pathFor(String d) {
  return _pathCache.putIfAbsent(d, () {
    final path = Path();
    final tokens = RegExp(r'[MLCZ]|-?\d*\.?\d+')
        .allMatches(d)
        .map((m) => m.group(0)!)
        .toList();
    var i = 0;
    while (i < tokens.length) {
      final cmd = tokens[i++];
      if (cmd == 'M') {
        path.moveTo(double.parse(tokens[i]), double.parse(tokens[i + 1]));
        i += 2;
      } else if (cmd == 'L') {
        path.lineTo(double.parse(tokens[i]), double.parse(tokens[i + 1]));
        i += 2;
      } else if (cmd == 'C') {
        path.cubicTo(
          double.parse(tokens[i]),
          double.parse(tokens[i + 1]),
          double.parse(tokens[i + 2]),
          double.parse(tokens[i + 3]),
          double.parse(tokens[i + 4]),
          double.parse(tokens[i + 5]),
        );
        i += 6;
      } else if (cmd == 'Z') {
        path.close();
      }
    }
    return path;
  });
}

class _PintigIconPainter extends CustomPainter {
  final PintigIconName name;
  final Color color;
  final Color dotColor;
  final bool showDot;
  final double strokeWidth;

  const _PintigIconPainter({
    required this.name,
    required this.color,
    required this.dotColor,
    required this.showDot,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final spec = _specs[name]!;
    canvas.save();
    canvas.scale(size.width / 24.0);

    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    for (final p in spec.paths) {
      canvas.drawPath(_pathFor(p), stroke);
    }

    if (showDot) {
      final fill = Paint()
        ..color = dotColor
        ..style = PaintingStyle.fill;
      for (final dot in spec.dots) {
        canvas.drawCircle(Offset(dot[0], dot[1]), dot[2], fill);
      }
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _PintigIconPainter old) =>
      old.name != name ||
      old.color != color ||
      old.dotColor != dotColor ||
      old.showDot != showDot ||
      old.strokeWidth != strokeWidth;
}

/// Pintig icon. Decorative by default; wrap in Semantics or a labelled button
/// when it carries meaning on its own.
class PintigIcon extends StatelessWidget {
  final PintigIconName name;
  final double size;
  final Color color;
  final Color dotColor;
  final bool showDot;
  final double strokeWidth;

  const PintigIcon(
    this.name, {
    super.key,
    this.size = 24.0,
    this.color = PintigTokens.ink,
    this.dotColor = PintigTokens.pintigCoral,
    this.showDot = true,
    this.strokeWidth = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: _PintigIconPainter(
            name: name,
            color: color,
            dotColor: dotColor,
            showDot: showDot,
            strokeWidth: strokeWidth,
          ),
        ),
      ),
    );
  }
}
