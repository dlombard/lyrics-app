import '../../domain/entities/lyric.dart';

abstract class LyricsDataSource {
  Future<List<Lyric>> getAllLyrics();
  Future<Lyric?> getLyricById(String id);
  Future<Lyric> createLyric(Lyric lyric);
  Future<Lyric> updateLyric(Lyric lyric);
  Future<void> deleteLyric(String id);
  Future<List<Lyric>> searchLyrics(String query);
}