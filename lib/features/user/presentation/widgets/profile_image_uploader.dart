import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';

class ProfileImageUploader extends StatelessWidget {
  final File? imageFile;
  final String? currentImageUrl;
  final bool isLoading;
  final VoidCallback onPickImage;
  final VoidCallback onDeleteImage;

  const ProfileImageUploader({
    Key? key,
    this.imageFile,
    this.currentImageUrl,
    this.isLoading = false,
    required this.onPickImage,
    required this.onDeleteImage,
  }) : super(key: key);

  bool get _hasImage =>
      imageFile != null ||
      (currentImageUrl != null && currentImageUrl!.isNotEmpty);

  ImageProvider? get _imageProvider {
    if (imageFile != null) return FileImage(imageFile!);
    if (currentImageUrl != null && currentImageUrl!.isNotEmpty) {
      return NetworkImage(currentImageUrl!);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final double radius = 72.r;

    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          _buildAvatar(context, radius),
          Positioned(
            bottom: 0,
            right: 15.w,
            child: _buildActionButton(context),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context, double radius) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      backgroundImage: _imageProvider,
      child:
          isLoading
              ? CircularProgressIndicator(
                strokeWidth: 2,
                color: Theme.of(context).colorScheme.primary,
              )
              : _imageProvider == null
              ? Icon(
                HugeIcons.strokeRoundedUser03,
                size: radius * 0.8,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              )
              : null,
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      transitionBuilder:
          (child, animation) => ScaleTransition(scale: animation, child: child),
      child: GestureDetector(
        key: ValueKey(_hasImage),
        onTap: isLoading ? null : (_hasImage ? onDeleteImage : onPickImage),
        child: Container(
          width: 28.r,
          height: 28.r,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            shape: BoxShape.circle,
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant,
              width: 1,
            ),
          ),
          child: Icon(
            _hasImage ? Icons.close_rounded : Icons.add_rounded,
            size: 16.r,
            color:
                _hasImage
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
