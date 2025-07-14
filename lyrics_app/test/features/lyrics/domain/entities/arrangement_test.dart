import 'package:flutter_test/flutter_test.dart';
import 'package:lyrics_app/features/lyrics/domain/entities/arrangement.dart';

void main() {
  group('Arrangement Entity', () {
    final now = DateTime.now();

    test('should create a valid Arrangement instance', () {
      // Arrange & Act
      final arrangement = Arrangement(
        id: 'arr-1',
        name: 'Standard Arrangement',
        lyricId: 'lyric-1',
        sectionOrder: ['intro', 'verse1', 'chorus', 'verse2', 'chorus', 'bridge', 'chorus', 'outro'],
        isDefault: true,
        createdAt: now,
        updatedAt: now,
      );

      // Assert
      expect(arrangement.id, 'arr-1');
      expect(arrangement.name, 'Standard Arrangement');
      expect(arrangement.lyricId, 'lyric-1');
      expect(arrangement.sectionOrder, ['intro', 'verse1', 'chorus', 'verse2', 'chorus', 'bridge', 'chorus', 'outro']);
      expect(arrangement.isDefault, true);
      expect(arrangement.createdAt, now);
      expect(arrangement.updatedAt, now);
    });

    test('should support equality comparison', () {
      // Arrange
      final arrangement1 = Arrangement(
        id: 'arr-1',
        name: 'Standard',
        lyricId: 'lyric-1',
        sectionOrder: ['verse', 'chorus'],
        isDefault: true,
        createdAt: now,
        updatedAt: now,
      );

      final arrangement2 = Arrangement(
        id: 'arr-1',
        name: 'Standard',
        lyricId: 'lyric-1',
        sectionOrder: ['verse', 'chorus'],
        isDefault: true,
        createdAt: now,
        updatedAt: now,
      );

      final arrangement3 = Arrangement(
        id: 'arr-2',
        name: 'Standard',
        lyricId: 'lyric-1',
        sectionOrder: ['verse', 'chorus'],
        isDefault: true,
        createdAt: now,
        updatedAt: now,
      );

      // Act & Assert
      expect(arrangement1, equals(arrangement2));
      expect(arrangement1, isNot(equals(arrangement3)));
      expect(arrangement1.hashCode, equals(arrangement2.hashCode));
      expect(arrangement1.hashCode, isNot(equals(arrangement3.hashCode)));
    });

    test('should create copyWith correctly', () {
      // Arrange
      final originalArrangement = Arrangement(
        id: 'arr-1',
        name: 'Original',
        lyricId: 'lyric-1',
        sectionOrder: ['verse', 'chorus'],
        isDefault: false,
        createdAt: now,
        updatedAt: now,
      );

      final newTime = now.add(const Duration(minutes: 15));

      // Act
      final updatedArrangement = originalArrangement.copyWith(
        name: 'Updated Name',
        sectionOrder: ['intro', 'verse', 'chorus', 'outro'],
        isDefault: true,
        updatedAt: newTime,
      );

      // Assert
      expect(updatedArrangement.id, originalArrangement.id);
      expect(updatedArrangement.name, 'Updated Name');
      expect(updatedArrangement.sectionOrder, ['intro', 'verse', 'chorus', 'outro']);
      expect(updatedArrangement.isDefault, true);
      expect(updatedArrangement.createdAt, originalArrangement.createdAt);
      expect(updatedArrangement.updatedAt, newTime);
    });

    test('should handle empty section order', () {
      // Arrange & Act
      final arrangement = Arrangement(
        id: 'arr-empty',
        name: 'Empty Arrangement',
        lyricId: 'lyric-1',
        sectionOrder: [],
        isDefault: false,
        createdAt: now,
        updatedAt: now,
      );

      // Assert
      expect(arrangement.sectionOrder, isEmpty);
    });

    test('should handle single section arrangement', () {
      // Arrange & Act
      final arrangement = Arrangement(
        id: 'arr-single',
        name: 'Single Section',
        lyricId: 'lyric-1',
        sectionOrder: ['verse'],
        isDefault: false,
        createdAt: now,
        updatedAt: now,
      );

      // Assert
      expect(arrangement.sectionOrder.length, 1);
      expect(arrangement.sectionOrder.first, 'verse');
    });

    test('should handle repeated sections in arrangement', () {
      // Arrange & Act
      final arrangement = Arrangement(
        id: 'arr-repeat',
        name: 'With Repeats',
        lyricId: 'lyric-1',
        sectionOrder: ['verse', 'chorus', 'verse', 'chorus', 'chorus'],
        isDefault: false,
        createdAt: now,
        updatedAt: now,
      );

      // Assert
      expect(arrangement.sectionOrder.length, 5);
      expect(arrangement.sectionOrder.where((s) => s == 'chorus').length, 3);
      expect(arrangement.sectionOrder.where((s) => s == 'verse').length, 2);
    });

    test('should allow non-default arrangements', () {
      // Arrange & Act
      final arrangement = Arrangement(
        id: 'arr-custom',
        name: 'Custom Arrangement',
        lyricId: 'lyric-1',
        sectionOrder: ['bridge', 'verse'],
        isDefault: false,
        createdAt: now,
        updatedAt: now,
      );

      // Assert
      expect(arrangement.isDefault, false);
    });
  });
}