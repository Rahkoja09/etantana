import 'dart:io';

class FileUtils {
  static String getFileName(File file) {
    return file.path.split('/').last;
  }
}
