import 'dart:io';
import 'package:e_tantana/core/error/exceptions.dart';
import 'package:e_tantana/core/network/network_info.dart';
import 'package:e_tantana/core/utils/tools/isUrl.dart';
import 'package:e_tantana/shared/media/media_services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:video_compress/video_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class MediaServiceImpl implements MediaServices {
  final SupabaseClient _supabase;
  final NetworkInfo _networkInfo;
  final ImagePicker _picker;

  MediaServiceImpl(this._supabase, this._networkInfo, this._picker);

  // --- PICKING -------

  @override
  Future<File?> pickImage({required bool fromGallery}) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: fromGallery ? ImageSource.gallery : ImageSource.camera,
    );
    return pickedFile != null ? File(pickedFile.path) : null;
  }

  @override
  Future<List<File>> pickMultiImages() async {
    final List<XFile> pickedFiles = await _picker.pickMultiImage();
    return pickedFiles.map((xFile) => File(xFile.path)).toList();
  }

  @override
  Future<File?> pickVideo({required bool fromGallery}) async {
    final XFile? pickedFile = await _picker.pickVideo(
      source: fromGallery ? ImageSource.gallery : ImageSource.camera,
    );
    return pickedFile != null ? File(pickedFile.path) : null;
  }

  // --- PROCESSING & VALIDATION -------

  @override
  Future<File> compressImage(File file, {int quality = 80}) async {
    try {
      final String targetPath = p.join(
        file.parent.path,
        "${p.basenameWithoutExtension(file.path)}_comp.webp",
      );

      final XFile? result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: quality,
        format: CompressFormat.webp,
      );

      return result != null ? File(result.path) : file;
    } catch (e) {
      return file;
    }
  }

  @override
  Future<File?> compressVideo(File file) async {
    try {
      final MediaInfo? mediaInfo = await VideoCompress.compressVideo(
        file.path,
        quality: VideoQuality.MediumQuality,
        includeAudio: true,
      );
      return mediaInfo?.file ?? file;
    } catch (e) {
      return file;
    }
  }

  @override
  void validateMedia(File file, AppMediaType type) {
    final String path = file.path;
    final String? mimeType = lookupMimeType(path);
    final int fileSize = file.lengthSync();

    final bool isImage = mimeType?.startsWith('image/') ?? false;
    final bool isVideo = mimeType?.startsWith('video/') ?? false;
    if ((type != AppMediaType.product && type != AppMediaType.invoice) &&
        !isImage) {
      throw ApiException(message: "Le fichier doit être une image.");
    }

    // Validation Taille (5MB image / 50MB video) ---------
    final int maxSize = isVideo ? 50 * 1024 * 1024 : 5 * 1024 * 1024;
    if (fileSize > maxSize) {
      throw ApiException(
        message: "Fichier trop lourd. Max: ${maxSize ~/ (1024 * 1024)}MB",
      );
    }
  }

  // --- UPLOAD OPERATIONS ---

  @override
  Future<String> uploadMedia({
    required File file,
    required String uid,
    required AppMediaType type,
    String? entityId,
    String bucketName = 'agency',
  }) async {
    if (!(await _networkInfo.isConnected)) {
      throw NetworkException(message: "Pas de connexion internet");
    }

    validateMedia(file, type);
    final String extension = p.extension(file.path);
    final String fileName = _getFileNameByType(type, extension);
    final String filePath =
        entityId != null ? '$uid/$entityId/$fileName' : '$uid/$fileName';
    final String? contentType = lookupMimeType(file.path);
    try {
      await _supabase.storage
          .from(bucketName)
          .upload(
            filePath,
            file,
            fileOptions: FileOptions(contentType: contentType, upsert: true),
          );

      return getPublicUrl(filePath, bucketName);
    } catch (e) {
      throw ApiException(message: "Échec de l'upload: $e");
    }
  }

  @override
  Future<String> uploadMultipleMedia({
    required List<File> files,
    required String uid,
    required AppMediaType type,
    String? entityId,
    String bucketName = 'agency',
  }) async {
    final List<String> urls = [];

    for (int i = 0; i < files.length; i++) {
      try {
        final String url = await uploadMedia(
          file: files[i],
          uid: uid,
          type: type,
          entityId: entityId,
          bucketName: bucketName,
        );
        urls.add(url);
      } catch (e) {
        continue;
      }
    }

    if (urls.isEmpty) {
      throw ApiException(message: "Aucun fichier n'a pu être uploadé");
    }
    return urls.join(',');
  }

  @override
  Future<File?> generateVideoThumbnail(dynamic videoFile) async {
    try {
      final isRemote = isUrl(videoFile);
      final videoPath =
          isRemote ? videoFile as String : (videoFile as File).path;

      final bytes = await VideoThumbnail.thumbnailData(
        video: videoPath,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 200,
        quality: 75,
      );

      if (bytes == null) return null;

      final tempDir = await getTemporaryDirectory();
      final fileName =
          isRemote
              ? Uri.parse(videoPath).pathSegments.last
              : videoPath.split('/').last;

      final thumbFile = File('${tempDir.path}/$fileName.jpg');

      await thumbFile.writeAsBytes(bytes);
      return thumbFile;
    } catch (e) {
      print('Erreur génération thumbnail : $e');
      return null;
    }
  }

  // --- UTILS ----

  @override
  String getPublicUrl(String filePath, String bucketName) {
    return _supabase.storage.from(bucketName).getPublicUrl(filePath);
  }

  @override
  Future<void> deleteFile(String filePath, String bucketName) async {
    try {
      await _supabase.storage.from(bucketName).remove([filePath]);
    } catch (_) {}
  }

  @override
  Future<void> clearTemporaryCache() async {
    await VideoCompress.deleteAllCache();
  }

  // --- PRIVATE NAMING LOGIC---------------------

  String _getFileNameByType(AppMediaType type, String extension, {int? index}) {
    final suffix = index != null ? '_$index' : '';
    final now = DateTime.now();
    final String timestamp =
        "${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}_${now.hour}${now.minute}${now.second}";

    switch (type) {
      case AppMediaType.product:
        return 'product_$timestamp$suffix$extension';
      case AppMediaType.invoice:
        return 'invoice_$timestamp$suffix$extension';
    }
  }
}
