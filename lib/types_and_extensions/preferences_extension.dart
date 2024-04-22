enum Preferences {
  token,
  refreshToken,
}

extension getTypeExtension on Preferences {
  Type get getType {
    switch (this) {
      case Preferences.token:
        return String;
      case Preferences.refreshToken:
        return String;
    }
  }
}
