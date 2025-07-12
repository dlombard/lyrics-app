import 'package:equatable/equatable.dart';

class Arrangement extends Equatable {
  final String id;
  final String name;
  final String lyricId;
  final List<String> sectionOrder;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Arrangement({
    required this.id,
    required this.name,
    required this.lyricId,
    required this.sectionOrder,
    this.isDefault = false,
    required this.createdAt,
    required this.updatedAt,
  });

  Arrangement copyWith({
    String? id,
    String? name,
    String? lyricId,
    List<String>? sectionOrder,
    bool? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Arrangement(
      id: id ?? this.id,
      name: name ?? this.name,
      lyricId: lyricId ?? this.lyricId,
      sectionOrder: sectionOrder ?? this.sectionOrder,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object> get props => [
        id,
        name,
        lyricId,
        sectionOrder,
        isDefault,
        createdAt,
        updatedAt,
      ];
}