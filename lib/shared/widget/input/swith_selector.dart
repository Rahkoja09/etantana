import 'package:flutter/material.dart';

class SwithSelector<T> extends StatefulWidget {
  final List<T> options;
  final T initialValue;
  final String Function(T) labelBuilder;
  final ValueChanged<T> onChanged;
  final Color? themeColor;

  const SwithSelector({
    super.key,
    required this.options,
    required this.initialValue,
    required this.labelBuilder,
    required this.onChanged,
    this.themeColor,
  });

  @override
  State<SwithSelector<T>> createState() => _SwithSelectorState<T>();
}

class _SwithSelectorState<T> extends State<SwithSelector<T>> {
  late T selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    final activeColor =
        widget.themeColor ?? Theme.of(context).colorScheme.primary;

    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerLowest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(4),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final itemWidth = (constraints.maxWidth) / widget.options.length;

          return Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                left: widget.options.indexOf(selectedValue) * itemWidth,
                top: 0,
                bottom: 0,
                width: itemWidth,
                child: Container(
                  decoration: BoxDecoration(
                    color: activeColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: activeColor.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children:
                    widget.options.map((option) {
                      final isSelected = selectedValue == option;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() => selectedValue = option);
                            widget.onChanged(option);
                          },
                          behavior: HitTestBehavior.opaque,
                          child: Center(
                            child: AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 200),
                              style: TextStyle(
                                color:
                                    isSelected
                                        ? Colors.white
                                        : Theme.of(
                                          context,
                                        ).colorScheme.onSurface,
                                fontWeight:
                                    isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                fontSize: 13,
                              ),
                              child: Text(widget.labelBuilder(option)),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ],
          );
        },
      ),
    );
  }
}
