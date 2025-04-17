import 'package:hive/hive.dart';

part 'settings_entity.g.dart';

@HiveType(typeId: 1)
class SettingsEntity {
  @HiveField(0)
  final bool darkMode;

  @HiveField(1)
  final double fontSize;

  const SettingsEntity({
    required this.darkMode,
    required this.fontSize,
  });

  SettingsEntity copyWith({
    bool? darkMode,
    double? fontSize,
  }) {
    return SettingsEntity(
      darkMode: darkMode ?? this.darkMode,
      fontSize: fontSize ?? this.fontSize,
    );
  }
}
