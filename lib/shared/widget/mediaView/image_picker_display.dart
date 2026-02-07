import 'dart:io';

import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:e_tantana/shared/widget/button/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';

class ImagePickerDisplay extends StatelessWidget {
  final dynamic imageFile;
  final VoidCallback onPickImage;
  final VoidCallback onRemoveImage;

  const ImagePickerDisplay({
    super.key,
    required this.imageFile,
    required this.onPickImage,
    required this.onRemoveImage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: imageFile == null ? onPickImage : null,
          child: Container(
            width: double.infinity,
            height: 250.h,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child:
                imageFile != null
                    ? Stack(
                      fit: StackFit.expand,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(11),
                          child:
                              imageFile is File
                                  ? Image.file(imageFile!, fit: BoxFit.cover)
                                  : Image.network(imageFile, fit: BoxFit.cover),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: onRemoveImage,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                    : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(
                                  context,
                                ).colorScheme.surfaceContainerHighest,
                            shape: BoxShape.circle,
                          ),
                          child: HugeIcon(
                            icon: HugeIcons.strokeRoundedImageAdd02,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.6),
                            size: 20.sp,
                          ),
                        ),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: onPickImage,
                          child: Text(
                            "Importer une image du produit",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                              fontFamily: "Nonito",
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.blue,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Taille de l'image inférieur ou égale à 50 Mo",
                          style: TextStyles.bodyMedium(
                            context: context,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          "ou",
                          style: TextStyles.bodyMedium(
                            context: context,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.5),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Button(
                          onTap: onPickImage,
                          btnColor: Colors.blue,
                          btnText: "Importer",
                          btnTextColor: Colors.white,
                        ),
                      ],
                    ),
          ),
        ),
      ],
    );
  }
}
