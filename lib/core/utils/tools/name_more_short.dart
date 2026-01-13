class NameMoreShort {
  // Shorten name : nom plus court si le nom est trop long pour l'affichage ------
  String shortenName(String fullName, int maxLength) {
    if (fullName.length <= maxLength) {
      return fullName;
    }
    List<String> nameParts = fullName.split(' ');

    if (nameParts.length == 1) {
      return fullName;
    }

    String shortenedName = nameParts[0];

    for (int i = 1; i < nameParts.length; i++) {
      String part = nameParts[i];
      if (('$shortenedName $part').length > maxLength) {
        shortenedName += ' ${part[0]}.';
      } else {
        shortenedName += ' $part';
      }
    }

    return shortenedName;
  }

  // retourne les initiales suivi d'un point -----
  String initialsOnly(String fullName) {
    List<String> nameParts = fullName.trim().split(RegExp(r'\s+'));
    String initials = '';
    for (var part in nameParts) {
      if (part.isNotEmpty) {
        initials += part[0].toUpperCase();
      }
    }
    return initials;
  }
}
