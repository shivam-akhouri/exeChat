class Utils {
  static String getUsername(String email) {
    return "${email.split('@')[0]}";
  }
}
