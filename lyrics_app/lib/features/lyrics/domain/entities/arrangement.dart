import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'arrangement.g.dart';

@HiveType(typeId: 2)
class Arrangement extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String lyricId;
  @HiveField(3)
  final List<String> sectionOrder;
  @HiveField(4)
  final bool isDefault;
  @HiveField(5)
  final DateTime createdAt;
  @HiveField(6)
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