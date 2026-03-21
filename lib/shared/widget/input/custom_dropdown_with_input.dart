import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';

class CustomDropdownWithInput extends StatefulWidget {
  final String textHint;
  final IconData iconData;
  final List<String> suggestions;
  final String? value;
  final Function(String?) onChanged;

  const CustomDropdownWithInput({
    super.key,
    required this.textHint,
    required this.iconData,
    required this.suggestions,
    required this.onChanged,
    this.value,
  });

  @override
  State<CustomDropdownWithInput> createState() =>
      _CustomDropdownWithInputState();
}

class _CustomDropdownWithInputState extends State<CustomDropdownWithInput> {
  static const String _otherKey = "__autre__";

  late List<String> _items;
  String? _selectedValue;
  bool _showCustomInput = false;
  final TextEditingController _customCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _items = List.from(widget.suggestions);

    // Si la valeur initiale n'est pas dans les suggestions — c'est une valeur custom
    if (widget.value != null && !_items.contains(widget.value)) {
      _items.add(widget.value!);
      _selectedValue = widget.value;
    } else {
      _selectedValue = widget.value;
    }
  }

  @override
  void dispose() {
    _customCtrl.dispose();
    super.dispose();
  }

  void _handleChange(String? val) {
    if (val == _otherKey) {
      setState(() {
        _showCustomInput = true;
        _selectedValue = null;
      });
      widget.onChanged(null);
    } else {
      setState(() {
        _showCustomInput = false;
        _selectedValue = val;
      });
      widget.onChanged(val);
    }
  }

  void _confirmCustom() {
    final custom = _customCtrl.text.trim();
    if (custom.isEmpty) return;

    setState(() {
      if (!_items.contains(custom)) _items.add(custom);
      _selectedValue = custom;
      _showCustomInput = false;
      _customCtrl.clear();
    });
    widget.onChanged(custom);
  }

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final primary = Theme.of(context).colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Dropdown ────────────────────────────────────
        DropdownButtonFormField<String>(
          value: _selectedValue,
          isExpanded: true,
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedArrowDown01,
            color: onSurface.withValues(alpha: 0.6),
            size: 18.w,
          ),
          style: TextStyles.bodyText(context: context, color: onSurface),
          decoration: InputDecoration(
            filled: true,
            fillColor: Theme.of(context).colorScheme.surfaceContainerLow,
            prefixIcon: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: HugeIcon(
                icon: widget.iconData,
                color: onSurface,
                size: 18.w,
              ),
            ),
            prefixIconConstraints: BoxConstraints(minWidth: 40.w),
            contentPadding: EdgeInsets.symmetric(
              vertical: 12.h,
              horizontal: 12.w,
            ),
            hintText: widget.textHint.toUpperCase(),
            hintStyle: TextStyles.bodyText(
              context: context,
              color: onSurface.withValues(alpha: 0.4),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(StylesConstants.borderRadius),
              borderSide: BorderSide(
                color: onSurface.withValues(alpha: 0.4),
                width: 0.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(StylesConstants.borderRadius),
              borderSide: BorderSide(
                color: onSurface.withValues(alpha: 0.0),
                width: 0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: onSurface, width: 1.5),
              borderRadius: BorderRadius.circular(StylesConstants.borderRadius),
            ),
          ),
          items: [
            // Suggestions
            ..._items.map(
              (item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: TextStyles.bodyText(
                    context: context,
                    color: onSurface,
                  ),
                ),
              ),
            ),
            // Option "Autre..."
            DropdownMenuItem<String>(
              value: _otherKey,
              child: Row(
                children: [
                  Icon(Icons.edit_outlined, size: 14.sp, color: primary),
                  SizedBox(width: 6.w),
                  Text(
                    "Autre...",
                    style: TextStyles.bodyText(
                      context: context,
                      color: primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
          onChanged: _handleChange,
          dropdownColor: Theme.of(context).colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(StylesConstants.borderRadius),
        ),

        // ── Champ libre si "Autre..." sélectionné ────────
        if (_showCustomInput) ...[
          SizedBox(height: 8.h),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _customCtrl,
                  autofocus: true,
                  style: TextStyles.bodyText(
                    context: context,
                    color: onSurface,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor:
                        Theme.of(context).colorScheme.surfaceContainerLow,
                    hintText: "Saisir votre propre valeur...",
                    hintStyle: TextStyles.bodyText(
                      context: context,
                      color: onSurface.withValues(alpha: 0.4),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 10.h,
                      horizontal: 14.w,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        StylesConstants.borderRadius,
                      ),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        StylesConstants.borderRadius,
                      ),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        StylesConstants.borderRadius,
                      ),
                      borderSide: BorderSide(color: primary, width: 1.5),
                    ),
                  ),
                  onSubmitted: (_) => _confirmCustom(),
                ),
              ),
              SizedBox(width: 8.w),
              GestureDetector(
                onTap: _confirmCustom,
                child: Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.circular(
                      StylesConstants.borderRadius,
                    ),
                  ),
                  child: Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 18.sp,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
