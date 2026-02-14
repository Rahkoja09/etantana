import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/shared/widget/title/medium_title_with_degree.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InputNumberOnlyMinus extends StatefulWidget {
  final String title;
  final int initialValue;
  final ValueChanged<int> onValueChanged;
  final int minimumValue;
  final bool showTitle;
  final bool showDegree;
  final int degree;

  const InputNumberOnlyMinus({
    super.key,
    required this.title,
    this.initialValue = 0,
    required this.onValueChanged,
    required this.minimumValue,
    this.showTitle = false,
    this.showDegree = false,
    this.degree = 1,
  });

  @override
  State<InputNumberOnlyMinus> createState() => _InputNumberOnlyMinusState();
}

class _InputNumberOnlyMinusState extends State<InputNumberOnlyMinus> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateValue(int newValue) {
    if (newValue < widget.minimumValue) return;

    setState(() {
      _controller.text = newValue.toString();
    });
    widget.onValueChanged(newValue);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showTitle) ...[
          MediumTitleWithDegree(
            showDegree: widget.showDegree,
            title: widget.title,
            degree: widget.degree,
          ),
          const SizedBox(height: 5),
        ],

        Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(StylesConstants.borderRadius),
            border: Border.all(
              color: Theme.of(
                context,
              ).colorScheme.outline.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  final current =
                      int.tryParse(_controller.text) ?? widget.minimumValue;
                  _updateValue(current - 1);
                },
                child: Container(
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.remove, size: 20, color: Colors.white),
                ),
              ),
              const SizedBox(width: 15),
              SizedBox(
                width: 60,
                child: Center(
                  child: TextFormField(
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    onChanged: (val) {
                      final parsed = int.tryParse(val);
                      if (parsed != null) {
                        widget.onValueChanged(parsed);
                      }
                    },
                    decoration: const InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
