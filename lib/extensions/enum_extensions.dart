import 'package:first_project/extensions/string_extensions.dart';


// %%%%%%%%%%%%%%%%%% ENUM TO TITLE %%%%%%%%%%%%%%%%%%
/// **Extension that adds a formatted name to any enum.**
/// 
/// The `formattedName` will insert a space between camelCase transitions
/// and capitalize the result. Example: `watchingNow` → `Watching Now`
extension EnumFormatExtension on Enum {
  /// Returns a more readable name for the enum value.
  /// Example: `watchingNow` becomes `Watching Now`
  String get formattedName {
    final raw = name; // works only in Dart >= 2.15
    return raw.replaceAllMapped(
      RegExp(r'([a-z])([A-Z])'),
      (match) => '${match.group(1)} ${match.group(2)}',
    ).capitalize();
  }
}
// %%%%%%%%%%%%%%%%%% END - ENUM TO TITLE %%%%%%%%%%%%%%%%%%




// %%%%%%%%%%%%%%%%%%%% TITLE TO ENUM %%%%%%%%%%%%%%%%%%%%
/// **Converts a formatted string back into an enum value.**
/// 
/// It tries to match the formatted name (like "Watching Now") to one of the enum values
/// using the `formattedName` extension. Returns `null` if not found.
T? enumFromFormatted<T extends Enum>(List<T> values, String formatted) {

    try{
        return values.firstWhere((e) => (e as Enum).formattedName == formatted);
    } catch (_) {
        return null;
    }
}
// %%%%%%%%%%%%%%%%%%%% END - TITLE TO ENUM %%%%%%%%%%%%%%%%%%%%




// %%%%%%%%%%%%%%%%%%%% NAME TO ENUM %%%%%%%%%%%%%%%%%%%%
/// **Converts an enum name back into an enum value.**
/// 
/// It tries to match the enum name (like "watching") to one of the enum values
/// using the `enum.name` extension. Returns `null` if not found.
T? enumFromName<T extends Enum>(List<T> values, String name) {

    try{
        return values.firstWhere((e) => (e as Enum).name == name);
    } catch (_) {
        return null;
    }
}
// %%%%%%%%%%%%%%%%%%%% END - TITLE TO ENUM %%%%%%%%%%%%%%%%%%%%
