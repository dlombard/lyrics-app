import 'package:equatable/equatable.dart';

class PresentationSettings extends Equatable {
  final int linesPerScreen;
  final double fontSize;
  final String fontFamily;
  final bool autoScroll;
  final int autoScrollSpeed;
  final bool darkMode;

  const PresentationSettings({
    this.linesPerScreen = 2,
    this.fontSize = 18.0,
    this.fontFamily = 'Roboto',
    this.autoScroll = false,
    this.autoScrollSpeed = 5,
    this.darkMode = false,
  });

  PresentationSettings copyWith({
    int? linesPerScreen,
    double? fontSize,
    String? fontFamily,
    bool? autoScroll,
    int? autoScrollSpeed,
    bool? darkMode,
  }) {
    return PresentationSettings(
      linesPerScreen: linesPerScreen ?? this.linesPerScreen,
      fontSize: fontSize ?? this.fontSize,
      fontFamily: fontFamily ?? this.fontFamily,
      autoScroll: autoScroll ?? this.autoScroll,
      autoScrollSpeed: autoScrollSpeed ?? this.autoScrollSpeed,
      darkMode: darkMode ?? this.darkMode,
    );
  }

  @override
  List<Object> get props => [
        linesPerScreen,
        fontSize,
        fontFamily,
        autoScroll,
        autoScrollSpeed,
        darkMode,
      ];
}