import 'package:e_tantana/core/utils/tools/variante_parser.dart';
import 'package:e_tantana/shared/widget/input/number_input.dart';
import 'package:e_tantana/shared/widget/input/simple_input.dart';
import 'package:e_tantana/shared/widget/popup/show_custom_popup.dart';
import 'package:e_tantana/shared/widget/text/horizontal_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:e_tantana/config/constants/styles_constants.dart';

class ProductVariant {
  final String key;
  final String size;
  final int quantity;

  ProductVariant({
    required this.key,
    required this.size,
    required this.quantity,
  });
}

class ItemManagerSection extends StatefulWidget {
  final String? varianteInString;
  final Function(String) onChanged;

  const ItemManagerSection({
    super.key,
    required this.onChanged,
    this.varianteInString,
  });

  @override
  State<ItemManagerSection> createState() => _ItemManagerSectionState();
}

class _ItemManagerSectionState extends State<ItemManagerSection> {
  List<ProductVariant> _items = [];
  @override
  void initState() {
    super.initState();
    if (widget.varianteInString != null) {
      setState(() {
        _items = VariantParser.parse(widget.varianteInString!);
      });
    }
  }

  void _notifyParent() {
    final formattedString = VariantParser.stringify(_items);
    widget.onChanged(formattedString);
  }

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _detailController = TextEditingController();
  int _currentQty = 1;

  void _openAddPopup() {
    _nameController.clear();
    _detailController.clear();
    _currentQty = 1;

    showCustomPopup(
      context: context,
      title: "AJOUTER UN ÉLÉMENT",
      description: "Remplissez les détails ci-dessous",
      isError: false,
      child: Column(
        children: [
          SimpleInput(
            textHint: "clé (ex: rouge/carré/..)",
            iconData: HugeIcons.strokeRoundedTag01,
            textEditControlleur: _nameController,
            maxLines: 1,
          ),
          SizedBox(height: 12.h),
          SimpleInput(
            textHint: "prop (ex: 11x24cm/tête/..)",
            iconData: HugeIcons.strokeRoundedInformationCircle,
            textEditControlleur: _detailController,
            maxLines: 1,
          ),
          SizedBox(height: 16.h),
          NumberInput(
            title: "Quantité",
            value: _currentQty,
            onValueChanged: (val) => _currentQty = val,
          ),
          SizedBox(height: 24.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              onPressed: () {
                setState(() {
                  _items.add(
                    ProductVariant(
                      key:
                          _nameController.text.isEmpty
                              ? "-"
                              : _nameController.text,
                      size:
                          _detailController.text.isEmpty
                              ? "-"
                              : _detailController.text,
                      quantity: _currentQty,
                    ),
                  );
                });
                _notifyParent();
                Navigator.pop(context);
              },
              child: const Text("VALIDER"),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Column(
      children: [
        InkWell(
          onTap: _openAddPopup,
          borderRadius: BorderRadius.circular(StylesConstants.borderRadius),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
              ),
              borderRadius: BorderRadius.circular(StylesConstants.borderRadius),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_circle_outline,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(width: 8.w),
                Text(
                  "AJOUTER UNE VARIANTE",
                  style: TextStyles.bodyText(
                    context: context,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 12.h),
        if (_items.isNotEmpty)
          HorizontalDivider(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.3),
            width: size.width - StylesConstants.spacerContent * 2,
          ),
        SizedBox(height: 8.h),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _items.length,
          separatorBuilder: (_, __) => SizedBox(height: 8.h),
          itemBuilder: (context, index) {
            final item = _items[index];
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(
                  StylesConstants.borderRadius,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.key.toUpperCase(),
                          style: TextStyles.bodyMedium(
                            context: context,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${item.size} • Qté: ${item.quantity}",
                          style: TextStyles.bodySmall(
                            context: context,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      HugeIcons.strokeRoundedDelete04,
                      size: 20,
                      color: Colors.redAccent,
                    ),
                    onPressed: () {
                      setState(() => _items.removeAt(index));
                      _notifyParent();
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
