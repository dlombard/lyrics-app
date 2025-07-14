import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'section_type.dart';

part 'lyric_section.g.dart';

@HiveType(typeId: 1)
class LyricSection extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String content;
  @HiveField(3)
  final SectionType type;
  @HiveField(4)
  final String? customType;
  @HiveField(5)
  final int order;
  @HiveField(6)
  final DateTime createdAt;
  @HiveField(7)
  final DateTime updatedAt;

  const LyricSection({
    required this.id,
    required this.title,
    required this.content,
    required this.type,
    this.customType,
    required this.order,
    required this.createdAt,
    required this.updatedAt,
  });

  LyricSection copyWith({
    String? id,
    String? title,
    String? content,
    SectionType? type,
    String? customType,
    int? order,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LyricSection(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      type: type ?? this.type,
      customType: customType ?? this.customType,
      order: order ?? this.order,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        content,
        type,
        customType,
        order,
        createdAt,
        updatedAt,
      ];
}