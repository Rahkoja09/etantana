import 'package:flutter/material.dart';

class CustomSwipeButton extends StatefulWidget {
  final String text;
  final VoidCallback onSwipe;
  final Color backgroundColor;
  final Color sliderColor;
  final Color iconColor;
  final Color textColor;
  final double width;
  final double height;
  final IconData icon;

  const CustomSwipeButton({
    super.key,
    required this.text,
    required this.onSwipe,
    this.backgroundColor = const Color(0xFFF1F1F1),
    this.sliderColor = Colors.blue,
    this.iconColor = Colors.white,
    this.textColor = Colors.black54,
    this.width = double.infinity,
    this.height = 60,
    this.icon = Icons.arrow_forward_ios,
  });

  @override
  State<CustomSwipeButton> createState() => _CustomSwipeButtonState();
}

class _CustomSwipeButtonState extends State<CustomSwipeButton> {
  double _dragValue = 0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth =
            widget.width == double.infinity
                ? constraints.maxWidth
                : widget.width;

        final double sliderSize = widget.height - 8;
        final double maxDrag = maxWidth - sliderSize - 8;

        return Container(
          width: maxWidth,
          height: widget.height,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(widget.height / 2),
          ),
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Center(
                child: Text(
                  widget.text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: widget.textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              Positioned(
                left: _dragValue + 4,
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    setState(() {
                      _dragValue += details.delta.dx;
                      if (_dragValue < 0) _dragValue = 0;
                      if (_dragValue > maxDrag) _dragValue = maxDrag;
                    });
                  },
                  onHorizontalDragEnd: (details) {
                    if (_dragValue >= maxDrag * 0.9) {
                      setState(() => _dragValue = maxDrag);
                      widget.onSwipe();
                      print("BOOM ! Action déclenchée");
                    }
                    Future.delayed(const Duration(milliseconds: 300), () {
                      if (mounted) {
                        setState(() => _dragValue = 0);
                      }
                    });
                  },
                  child: Container(
                    width: sliderSize,
                    height: sliderSize,
                    decoration: BoxDecoration(
                      color: widget.sliderColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: widget.sliderColor.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      widget.icon,
                      color: widget.iconColor,
                      size: sliderSize * 0.4,
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
