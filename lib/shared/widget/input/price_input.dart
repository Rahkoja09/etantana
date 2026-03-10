import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';

class PriceInput extends StatefulWidget {
  final String textHint;
  final IconData iconData;
  final TextEditingController textEditController;
  final bool? isPrice;
  final String currencySymbol;

  const PriceInput({
    super.key,
    required this.textHint,
    required this.iconData,
    required this.textEditController,
    this.currencySymbol = '€',
    this.isPrice = true,
  });

  @override
  State<PriceInput> createState() => _PriceInputState();
}

class _PriceInputState extends State<PriceInput> {
  String _rawValue = '';
  bool _isFormatting = false;

  @override
  void initState() {
    super.initState();
    widget.textEditController.addListener(_formatPriceInput);
  }

  void _formatPriceInput() {
    if (_isFormatting) return;

    final currentText = widget.textEditController.text;

    if (currentText.isEmpty) {
      _rawValue = '';
      return;
    }

    String cleanedInput = currentText.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanedInput.isEmpty) {
      _rawValue = '';
      _isFormatting = true;
      widget.textEditController.text = '';
      _isFormatting = false;
      return;
    }

    _rawValue = cleanedInput;

    if (widget.isPrice == true) {
      int value = int.tryParse(_rawValue) ?? 0;
      final formatter = NumberFormat('#,###', 'en_US');
      String formatted = formatter.format(value).replaceAll(',', '.');

      if (currentText != formatted) {
        _isFormatting = true;
        widget.textEditController.value = TextEditingValue(
          text: formatted,
          selection: TextSelection.collapsed(offset: formatted.length),
        );
        _isFormatting = false;
      }
    } else {
      if (currentText != _rawValue) {
        _isFormatting = true;
        widget.textEditController.value = TextEditingValue(
          text: _rawValue,
          selection: TextSelection.collapsed(offset: _rawValue.length),
        );
        _isFormatting = false;
      }
    }
  }

  @override
  void dispose() {
    widget.textEditController.removeListener(_formatPriceInput);
    super.dispose();
  }

  String get rawValue => _rawValue;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textAlignVertical: TextAlignVertical.center,
      controller: widget.textEditController,
      style: TextStyles.bodyText(
        context: context,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      cursorColor: Theme.of(context).colorScheme.primary,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceContainer,
        prefixIcon: HugeIcon(
          icon: widget.iconData,
          color: Theme.of(context).colorScheme.onSurface,
          size: 20.w,
        ),
        prefixText: '${widget.currencySymbol} ',
        contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
        hintText: widget.textHint,
        hintStyle: TextStyles.bodyText(
          context: context,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(StylesConstants.borderRadius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
          ),
          borderRadius: BorderRadius.circular(StylesConstants.borderRadius),
        ),
      ),
    );
  }
}
