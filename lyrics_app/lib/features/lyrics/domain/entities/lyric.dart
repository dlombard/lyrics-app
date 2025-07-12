import 'package:equatable/equatable.dart';
import 'lyric_section.dart';
import 'arrangement.dart';

class Lyric extends Equatable {
  final String id;
  final String title;
  final String? artist;
  final String? album;
  final List<LyricSection> sections;
  final List<Arrangement> arrangements;
  final String? defaultArrangementId;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isShared;
  final String? sharedById;
  final String? originalId;

  const Lyric({
    required this.id,
    required this.title,
    this.artist,
    this.album,
    required this.sections,
    required this.arrangements,
    this.defaultArrangementId,
    this.tags = const [],
    required this.createdAt,
    required this.updatedAt,
    this.isShared = false,
    this.sharedById,
    this.originalId,
  });

  Lyric copyWith({
    String? id,
    String? title,
    String? artist,
    String? album,
    List<LyricSection>? sections,
    List<Arrangement>? arrangements,
    String? defaultArrangementId,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isShared,
    String? sharedById,
    String? originalId,
  }) {
    return Lyric(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      album: album ?? this.album,
      sections: sections ?? this.sections,
      arrangements: arrangements ?? this.arrangements,
      defaultArrangementId: defaultArrangementId ?? this.defaultArrangementId,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isShared: isShared ?? this.isShared,
      sharedById: sharedById ?? this.sharedById,
      originalId: originalId ?? this.originalId,
    );
  }

  Arrangement? get defaultArrangement {
    if (defaultArrangementId == null) return null;
    try {
      return arrangements.firstWhere((arr) => arr.id == defaultArrangementId);
    } catch (e) {
      return null;
    }
  }

  List<LyricSection> getSectionsInOrder(String? arrangementId) {
    final arrangement = arrangementId != null
        ? arrangements.where((arr) => arr.id == arrangementId).firstOrNull
        : defaultArrangement;

    if (arrangement == null) {
      return sections..sort((a, b) => a.order.compareTo(b.order));
    }

    final orderedSections = <LyricSection>[];
    for (final sectionId in arrangement.sectionOrder) {
      final section = sections.where((s) => s.id == sectionId).firstOrNull;
      if (section != null) {
        orderedSections.add(section);
      }
    }

    return orderedSections;
  }

  @override
  List<Object?> get props => [
        id,
        title,
        artist,
        album,
        sections,
        arrangements,
        defaultArrangementId,
        tags,
        createdAt,
        updatedAt,
        isShared,
        sharedById,
        originalId,
      ];
}

extension ListExtensions<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
}