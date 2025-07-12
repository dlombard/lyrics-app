import '../../domain/entities/lyric.dart';
import '../../domain/entities/lyric_section.dart';
import '../../domain/entities/arrangement.dart';
import '../../domain/entities/section_type.dart';
import 'lyrics_data_source_interface.dart';

class LyricsMockDataSource implements LyricsDataSource {
  static final List<Lyric> _mockData = [];

  @override
  Future<List<Lyric>> getAllLyrics() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_mockData);
  }

  @override
  Future<Lyric?> getLyricById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _mockData.firstWhere((lyric) => lyric.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Lyric> createLyric(Lyric lyric) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _mockData.add(lyric);
    return lyric;
  }

  @override
  Future<Lyric> updateLyric(Lyric lyric) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _mockData.indexWhere((l) => l.id == lyric.id);
    if (index != -1) {
      _mockData[index] = lyric;
    }
    return lyric;
  }

  @override
  Future<void> deleteLyric(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _mockData.removeWhere((lyric) => lyric.id == id);
  }

  @override
  Future<List<Lyric>> searchLyrics(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final lowerQuery = query.toLowerCase();
    return _mockData.where((lyric) {
      return lyric.title.toLowerCase().contains(lowerQuery) ||
          (lyric.artist?.toLowerCase().contains(lowerQuery) ?? false) ||
          (lyric.album?.toLowerCase().contains(lowerQuery) ?? false);
    }).toList();
  }

  static void addSampleData() {
    if (_mockData.isNotEmpty) return;

    final now = DateTime.now();
    
    // Add sample lyric
    final sampleSections = [
      LyricSection(
        id: '1',
        title: 'Verse 1',
        content: 'Walking down the street today\nSunshine lights my way\nEverything feels right\nIn this moment bright',
        type: SectionType.verse,
        order: 0,
        createdAt: now,
        updatedAt: now,
      ),
      LyricSection(
        id: '2',
        title: 'Chorus',
        content: 'This is my song, this is my time\nEvery word and every rhyme\nTells a story that is mine\nShining bright like morning light',
        type: SectionType.chorus,
        order: 1,
        createdAt: now,
        updatedAt: now,
      ),
      LyricSection(
        id: '3',
        title: 'Verse 2',
        content: 'Looking at the world around\nBeautiful sights and sounds\nMemories being made\nIn this perfect day',
        type: SectionType.verse,
        order: 2,
        createdAt: now,
        updatedAt: now,
      ),
    ];

    final defaultArrangement = Arrangement(
      id: 'arr1',
      name: 'Default',
      lyricId: 'sample1',
      sectionOrder: ['1', '2', '3', '2'],
      isDefault: true,
      createdAt: now,
      updatedAt: now,
    );

    final sampleLyric = Lyric(
      id: 'sample1',
      title: 'My Perfect Day',
      artist: 'Demo Artist',
      album: 'Sample Songs',
      sections: sampleSections,
      arrangements: [defaultArrangement],
      defaultArrangementId: 'arr1',
      tags: ['demo', 'happy', 'acoustic'],
      createdAt: now,
      updatedAt: now,
    );

    _mockData.add(sampleLyric);
  }
}