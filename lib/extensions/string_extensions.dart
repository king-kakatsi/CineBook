/// Extension to add casing utilities to the String class.
extension StringCasingExtension on String {

  /// Capitalizes the first letter of the string.
  /// 
  /// Example: `"hello"` becomes `"Hello"`.
  /// If the string is empty, returns it unchanged.
  String capitalize() => isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}
