import 'package:equatable/equatable.dart';
import 'section_type.dart';

class LyricSection extends Equatable {
  final String id;
  final String title;
  final String content;
  final SectionType type;
  final String? customType;
  final int order;
  final DateTime createdAt;
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