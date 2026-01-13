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
  final String currencySymbol;

  const PriceInput({
    super.key,
    required this.textHint,
    required this.iconData,
    required this.textEditController,
    this.currencySymbol = '€',
  });

  @override
  State<PriceInput> createState() => _PriceInputState();
}

class _PriceInputState extends State<PriceInput> {
  String _rawValue = '';

  @override
  void initState() {
    super.initState();
    widget.textEditController.addListener(_formatPriceInput);
  }

  void _formatPriceInput() {
    final currentText = widget.textEditController.text;

    // 🔹 On ne fait rien si le champ est vide
    if (currentText.isEmpty) {
      _rawValue = '';
      return;
    }

    // 🔹 Nettoyer le texte : ne garder que les chiffres
    String cleanedInput = currentText.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanedInput.isEmpty) {
      _rawValue = '';
      widget.textEditController.text = '';
      return;
    }

    _rawValue = cleanedInput;

    // 🔹 Formater avec des points comme séparateurs de milliers
    int value = int.tryParse(_rawValue) ?? 0;
    final formatter = NumberFormat('#,###', 'en_US');
    String formatted = formatter.format(value).replaceAll(',', '.');

    // 🔹 Met à jour uniquement si différent (évite les boucles infinies)
    if (currentText != formatted) {
      final selection = widget.textEditController.selection;
      widget.textEditController.text = formatted;
      widget.textEditController.selection = TextSelection.collapsed(
        offset:
            selection.baseOffset >= 0 ? selection.baseOffset : formatted.length,
      );
    }
  }

  @override
  void dispose() {
    widget.textEditController.removeListener(_formatPriceInput);
    super.dispose();
  }

  /// Retourne la valeur sans format (ex : 50000)
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
        fillColor: Theme.of(context).colorScheme.surface,
        prefixIcon: HugeIcon(
          icon: widget.iconData,
          color: Theme.of(context).colorScheme.onSurface,
          size: 20.w,
        ),
        prefixText: '${widget.currencySymbol} ',
        contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
        hintText: widget.textHint.toUpperCase(),
        hintStyle: TextStyles.bodyText(
          context: context,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(StylesConstants.borderRadius),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.onSurface,
          ),
          borderRadius: BorderRadius.circular(StylesConstants.borderRadius),
        ),
      ),
    );
  }
}
