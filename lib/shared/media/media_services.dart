import 'dart:io';

import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';

enum AppMediaType { product, invoice }

abstract class MediaServices {
  // --- PICKING ---
  Future<File?> pickImage({required bool fromGallery});
  Future<List<File>> pickMultiImages();
  Future<File?> pickVideo({required bool fromGallery});
  Future<File?> generateVideoThumbnail(dynamic videoFile);

  // --- PROCESSING & VALIDATION ---
  Future<File> compressImage(File file, {int quality = 80});
  Future<File?> compressVideo(File file);

  void validateMedia(File file, AppMediaType type);

  // --- UPLOAD OPERATIONS ---

  Future<String> uploadMedia({
    required File file,
    required String uid,
    required AppMediaType type,
    String? entityId,
    String bucketName = 'agency',
  });

  Future<String> uploadMultipleMedia({
    required List<File> files,
    required String uid,
    required AppMediaType type,
    String? entityId,
    String bucketName = 'agency',
  });

  Future<void> screenshotAndShareMedia(
    BuildContext context,
    String id,
    String ownerName,
    ScreenshotController screenshotController,
    Widget widget,
  );

  Future<void> sendInvoiceWhatsApp({
    required String message,
    required String phoneNumber,
  });
  Future<File> takeScreenshot(
    BuildContext context,
    String id,
    ScreenshotController screenshotController,
    Widget widget,
  );

  // --- UTILS ---
  String getPublicUrl(String filePath, String bucketName);
  Future<void> deleteFile(String filePath, String bucketName);
  Future<void> clearTemporaryCache();
}
