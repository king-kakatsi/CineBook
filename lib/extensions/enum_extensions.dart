import 'package:first_project/extensions/string_extensions.dart';

extension EnumFormatExtension on Enum {
  String get formattedName {
    final raw = name; // works only in Dart >= 2.15
    return raw.replaceAllMapped(
      RegExp(r'([a-z])([A-Z])'),
      (match) => '${match.group(1)} ${match.group(2)}',
    ).capitalize();
  }
}


T? enumFromFormatted<T extends Enum>(List<T> values, String formatted) {

    try{
        return values.firstWhere((e) => (e as Enum).formattedName == formatted);
    } catch (_) {
        return null;
    }
}