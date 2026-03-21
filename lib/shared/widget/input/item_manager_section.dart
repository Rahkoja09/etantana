import 'dart:io';

import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:e_tantana/core/di/injection_container.dart';
import 'package:e_tantana/features/product/presentation/pages/add_variant_page.dart';
import 'package:e_tantana/shared/media/media_services.dart';
import 'package:e_tantana/shared/widget/input/number_input.dart';
import 'package:e_tantana/shared/widget/input/price_input.dart';
import 'package:e_tantana/shared/widget/input/simple_input.dart';
import 'package:e_tantana/shared/widget/mediaView/image_picker_display.dart';
import 'package:e_tantana/shared/widget/popup/show_custom_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

class ItemManagerSection extends StatefulWidget {
  final List<Map<String, dynamic>>? initialVariants;
  final Function(List<Map<String, dynamic>> variants, List<File?> images)
  onChanged;

  const ItemManagerSection({
    super.key,
    required this.onChanged,
    this.initialVariants,
  });

  @override
  State<ItemManagerSection> createState() => _ItemManagerSectionState();
}

class _ItemManagerSectionState extends State<ItemManagerSection> {
  List<Map<String, dynamic>> _variants = [];
  List<File?> _variantImages = [];

  final _mediaService = sl<MediaServices>();

  @override
  void initState() {
    super.initState();
    if (widget.initialVariants != null && widget.initialVariants!.isNotEmpty) {
      _variants = List.from(widget.initialVariants!);
      _variantImages = List.filled(_variants.length, null);
    }
  }

  void _notify() {
    widget.onChanged(_variants, _variantImages);
  }

  void _openAddOrEdit({int? editIndex}) async {
    final result = await context.push<AddVariantResult>(
      '/product/add-variant',
      extra:
          editIndex != null
              ? {
                'variant': _variants[editIndex],
                'image': _variantImages[editIndex],
              }
              : null,
    );

    if (result == null) return;

    setState(() {
      if (editIndex != null) {
        _variants[editIndex] = result.variant;
        _variantImages[editIndex] = result.image;
      } else {
        _variants.add(result.variant);
        _variantImages.add(result.image);
      }
    });
    _notify();
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => _openAddOrEdit(),
          borderRadius: BorderRadius.circular(StylesConstants.borderRadius),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
            decoration: BoxDecoration(
              border: Border.all(color: primary.withValues(alpha: 0.4)),
              borderRadius: BorderRadius.circular(StylesConstants.borderRadius),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_circle_outline, color: primary, size: 18.sp),
                SizedBox(width: 8.w),
                Text(
                  "AJOUTER UN VARIANT",
                  style: TextStyles.bodyText(
                    context: context,
                    fontWeight: FontWeight.bold,
                    color: primary,
                  ),
                ),
              ],
            ),
          ),
        ),

        if (_variants.isNotEmpty) ...[
          SizedBox(height: 14.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _variants.length,
            separatorBuilder: (_, __) => SizedBox(height: 8.h),
            itemBuilder: (context, index) {
              final v = _variants[index];
              final localImage = _variantImages[index];
              final hasImage =
                  localImage != null ||
                  (v['image'] != null && v['image'].toString().isNotEmpty);

              return Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(
                    StylesConstants.borderRadius,
                  ),
                ),
                child: Row(
                  children: [
                    if (hasImage)
                      Container(
                        width: 40.r,
                        height: 40.r,
                        margin: EdgeInsets.only(right: 10.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image:
                              localImage != null
                                  ? DecorationImage(
                                    image: FileImage(localImage),
                                    fit: BoxFit.cover,
                                  )
                                  : DecorationImage(
                                    image: NetworkImage(v['image'].toString()),
                                    fit: BoxFit.cover,
                                  ),
                        ),
                      ),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                v['name']?.toString().toUpperCase() ?? "-",
                                style: TextStyles.bodyMedium(
                                  context: context,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(width: 6.w),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 6.w,
                                  vertical: 2.h,
                                ),
                                decoration: BoxDecoration(
                                  color: primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  v['variant_type']?.toString() ?? "-",
                                  style: TextStyle(
                                    fontSize: 9.sp,
                                    color: primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2.h),

                          Text(
                            _buildSubtitle(v),
                            style: TextStyles.bodySmall(
                              context: context,
                              color: onSurface.withValues(alpha: 0.45),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: HugeIcon(
                            icon: HugeIcons.strokeRoundedPencilEdit01,
                            color: onSurface.withValues(alpha: 0.4),
                            size: 18,
                          ),
                          onPressed: () => _openAddOrEdit(editIndex: index),
                        ),
                        IconButton(
                          icon: const HugeIcon(
                            icon: HugeIcons.strokeRoundedDelete04,
                            color: Colors.redAccent,
                            size: 18,
                          ),
                          onPressed: () {
                            setState(() {
                              _variants.removeAt(index);
                              _variantImages.removeAt(index);
                            });
                            _notify();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ],
    );
  }

  String _buildSubtitle(Map<String, dynamic> v) {
    final parts = <String>[];

    final property = v['property']?.toString();
    final propertyType = v['property_type']?.toString();
    if (property != null && property != '-') {
      parts.add(
        propertyType != null && propertyType != '-'
            ? "$propertyType: $property"
            : property,
      );
    }

    final qty = v['quantity'];
    if (qty != null) parts.add("Qté: $qty");

    final price = v['price'];
    if (price != null) parts.add("${price.toString()} Ar");

    return parts.join("  •  ");
  }
}
