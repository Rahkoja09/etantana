bool isUrl(String text) {
  final urlPattern = RegExp(
    r'^(https?:\/\/|ftp:\/\/|www\.)',
    caseSensitive: false,
  );
  return urlPattern.hasMatch(text);
}
