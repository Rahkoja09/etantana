import 'package:e_tantana/core/utils/tools/variante_parser.dart';
import 'package:e_tantana/shared/widget/input/number_input.dart';
import 'package:e_tantana/shared/widget/input/simple_input.dart';
import 'package:e_tantana/shared/widget/show_custom_popup.dart';
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
  final Function(String) onChanged;

  const ItemManagerSection({super.key, required this.onChanged});

  @override
  State<ItemManagerSection> createState() => _ItemManagerSectionState();
}

class _ItemManagerSectionState extends State<ItemManagerSection> {
  final List<ProductVariant> _items = [];
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
            textHint: "clé (ex: rouge)",
            iconData: HugeIcons.strokeRoundedTag01,
            textEditControlleur: _nameController,
            maxLines: 1,
          ),
          SizedBox(height: 12.h),
          SimpleInput(
            textHint: "taille (ex: 11x24 ou 11cm)",
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
    return Column(
      children: [
        // Bouton Ajouter
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

        // Liste des éléments ajoutés
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _items.length,
          separatorBuilder: (_, __) => SizedBox(height: 8.h),
          itemBuilder: (context, index) {
            final item = _items[index];
            return Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(
                  StylesConstants.borderRadius,
                ),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
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
                          style: TextStyles.bodySmall(
                            context: context,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${item.size} • Qté: ${item.quantity}",
                          style: TextStyles.bodyMedium(context: context),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
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
