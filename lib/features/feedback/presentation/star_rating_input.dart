import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StarRatingInput extends StatefulWidget {
  final int initialRating;
  final int maxRating;
  final ValueChanged<int> onRatingChanged;
  final String? label;

  const StarRatingInput({
    Key? key,
    this.initialRating = 0,
    this.maxRating = 5,
    required this.onRatingChanged,
    this.label,
  }) : super(key: key);

  @override
  State<StarRatingInput> createState() => _StarRatingInputState();
}

class _StarRatingInputState extends State<StarRatingInput> {
  late int _rating;

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          SizedBox(height: 8.h),
        ],
        Row(
          children: List.generate(widget.maxRating, (index) {
            final filled = index < _rating;
            return GestureDetector(
              onTap: () {
                setState(() => _rating = index + 1);
                widget.onRatingChanged(index + 1);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                margin: EdgeInsets.only(right: 8.w),
                child: Icon(
                  filled ? Icons.star_rounded : Icons.star_outline_rounded,
                  size: 28.sp,
                  color:
                      filled
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.2),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
