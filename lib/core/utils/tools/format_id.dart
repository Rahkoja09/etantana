class FormatId {
  static String shortenIdLenght(String longId) {
    return longId..substring(0, 8).toUpperCase();
  }
}
