/*import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fonenako_/config/theme/text_styles.dart';
import 'package:fonenako_/core/constants/styles_constants.dart';
import 'package:fonenako_/features/mediaFiles/data/dataSource/local/media_local.dart';
import 'package:video_player/video_player.dart';

class ImportVideoCard extends StatefulWidget {
  final ValueChanged<File> onVideoFileChanged;
  final String? title;
  final String? subtitle;
  final String placeholderImage;

  const ImportVideoCard({
    super.key,
    required this.onVideoFileChanged,
    this.title,
    this.subtitle,
    this.placeholderImage = "assets/medias/images/defaultImage.png",
  });

  @override
  State<ImportVideoCard> createState() => _ImportVideoCardState();
}

class _ImportVideoCardState extends State<ImportVideoCard> {
  File? _selectedVideo;
  VideoPlayerController? _videoController;

  final MediaLocal _mediaLocal = MediaLocal();

  Future<void> _importVideo() async {
    final video = await _mediaLocal.pickVideoFromGallery();
    if (video != null) {
      setState(() {
        _selectedVideo = video;
      });
      widget.onVideoFileChanged(video);
      _initializeVideoPlayer(video);
    }
  }

  Future<void> _initializeVideoPlayer(File videoFile) async {
    _videoController?.dispose();
    _videoController = VideoPlayerController.file(videoFile)
      ..initialize()
          .then((_) {
            if (mounted) {
              setState(() {});
              _videoController!.play();
            }
          })
          .catchError((e) {
            print('Erreur initialisation vidéo : $e');
          });
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 100.h,
          width: 180.w,
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.4),
            ),
            borderRadius: BorderRadius.circular(StylesConstants.borderRadius),
          ),
          child:
              _selectedVideo != null
                  ? ClipRRect(
                    borderRadius: BorderRadius.circular(
                      StylesConstants.borderRadius,
                    ),
                    child:
                        _videoController != null &&
                                _videoController!.value.isInitialized
                            ? VideoPlayer(_videoController!)
                            : const Center(child: CircularProgressIndicator()),
                  )
                  : ClipRRect(
                    borderRadius: BorderRadius.circular(
                      StylesConstants.borderRadius,
                    ),
                    child: Image.asset(
                      widget.placeholderImage,
                      fit: BoxFit.cover,
                    ),
                  ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                widget.subtitle ?? "Importez une vidéo de votre offre",
                textAlign: TextAlign.center,
                style: TextStyles.bodyMedium(
                  context: context,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 10.h),
              ElevatedButton(
                onPressed: _importVideo,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(10),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      StylesConstants.borderRadius + 10,
                    ),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  "Importer",
                  style: TextStyles.buttonText(
                    context: context,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}*/
