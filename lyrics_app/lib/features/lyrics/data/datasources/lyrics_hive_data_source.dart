import 'package:hive/hive.dart';
import '../../domain/entities/lyric.dart';
import 'lyrics_data_source_interface.dart';

class LyricsHiveDataSource implements LyricsDataSource {
  static const String _boxName = 'lyrics';
  late Box<Lyric> _lyricsBox;

  Future<void> init() async {
    _lyricsBox = await Hive.openBox<Lyric>(_boxName);
  }

  @override
  Future<List<Lyric>> getAllLyrics() async {
    return _lyricsBox.values.toList();
  }

  @override
  Future<Lyric?> getLyricById(String id) async {
    return _lyricsBox.get(id);
  }

  @override
  Future<Lyric> createLyric(Lyric lyric) async {
    await _lyricsBox.put(lyric.id, lyric);
    return lyric;
  }

  @override
  Future<Lyric> updateLyric(Lyric lyric) async {
    await _lyricsBox.put(lyric.id, lyric);
    return lyric;
  }

  @override
  Future<void> deleteLyric(String id) async {
    await _lyricsBox.delete(id);
  }

  @override
  Future<List<Lyric>> searchLyrics(String query) async {
    final lowercaseQuery = query.toLowerCase();
    final allLyrics = _lyricsBox.values.toList();
    
    return allLyrics.where((lyric) {
      // Search in title
      if (lyric.title.toLowerCase().contains(lowercaseQuery)) {
        return true;
      }
      
      // Search in artist
      if (lyric.artist?.toLowerCase().contains(lowercaseQuery) == true) {
        return true;
      }
      
      // Search in album
      if (lyric.album?.toLowerCase().contains(lowercaseQuery) == true) {
        return true;
      }
      
      // Search in tags
      if (lyric.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery))) {
        return true;
      }
      
      // Search in section content
      if (lyric.sections.any((section) => 
          section.title.toLowerCase().contains(lowercaseQuery) ||
          section.content.toLowerCase().contains(lowercaseQuery))) {
        return true;
      }
      
      return false;
    }).toList();
  }

  Future<void> clear() async {
    await _lyricsBox.clear();
  }

  Future<void> close() async {
    await _lyricsBox.close();
  }
}