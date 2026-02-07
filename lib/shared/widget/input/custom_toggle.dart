import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:flutter/material.dart';

class CustomToggle extends StatefulWidget {
  final Function(bool isStock) onChanged;
  final bool desableOnDefaultValue;
  final bool? isFuture;

  const CustomToggle({
    super.key,
    required this.onChanged,
    this.isFuture,
    required this.desableOnDefaultValue,
  });

  @override
  State<CustomToggle> createState() => _CustomToggleState();
}

class _CustomToggleState extends State<CustomToggle> {
  late bool isTransit;

  @override
  void initState() {
    super.initState();
    isTransit = widget.isFuture ?? false;
  }

  @override
  void didUpdateWidget(CustomToggle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFuture != null && widget.isFuture != oldWidget.isFuture) {
      setState(() {
        isTransit = widget.isFuture!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          widget.desableOnDefaultValue
              ? null
              : () {
                setState(() => isTransit = !isTransit);
                widget.onChanged(isTransit);
              },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 100,
        height: 35,
        decoration: BoxDecoration(
          color: isTransit ? Colors.blue.shade50 : Colors.green.shade50,
          borderRadius: BorderRadius.circular(StylesConstants.borderRadius),
          border: Border.all(
            color: isTransit ? Colors.blue.shade200 : Colors.green.shade200,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(
                  Icons.directions_boat,
                  size: 14,
                  color: isTransit ? Colors.blue : Colors.grey,
                ),
                Icon(
                  Icons.warehouse,
                  size: 14,
                  color: !isTransit ? Colors.green : Colors.grey,
                ),
              ],
            ),
            AnimatedAlign(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutBack,
              alignment:
                  isTransit ? Alignment.centerLeft : Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: Container(
                  width: 46,
                  height: 28,
                  decoration: BoxDecoration(
                    color: isTransit ? Colors.blue : Colors.green,
                    borderRadius: BorderRadius.circular(
                      StylesConstants.borderRadius - 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    isTransit ? Icons.directions_boat : Icons.warehouse,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
