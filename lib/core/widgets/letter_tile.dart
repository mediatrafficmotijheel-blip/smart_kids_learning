import 'package:flutter/material.dart';

/// A colorful tile showing a Bangla letter.
class LetterTile extends StatefulWidget {
  const LetterTile({
    super.key,
    required this.letter,
    required this.color,
    this.onTap,
    this.size = 96,
  });

  final String letter;
  final Color color;
  final VoidCallback? onTap;
  final double size;

  @override
  State<LetterTile> createState() => _LetterTileState();
}

class _LetterTileState extends State<LetterTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 150),
    lowerBound: 0,
    upperBound: 0.12,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) async {
        await _controller.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final scale = 1.0 - _controller.value;
          return Transform.scale(scale: scale, child: child);
        },
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.8),
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha: 0.55),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            widget.letter,
            style: const TextStyle(
              fontFamily: 'NotoBengali',
              fontSize: 44,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1.1,
              shadows: [
                Shadow(
                  color: Colors.black26,
                  offset: Offset(1, 2),
                  blurRadius: 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}