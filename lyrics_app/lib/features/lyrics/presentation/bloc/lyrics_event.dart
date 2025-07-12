import 'package:equatable/equatable.dart';
import '../../domain/entities/lyric.dart';

abstract class LyricsEvent extends Equatable {
  const LyricsEvent();

  @override
  List<Object> get props => [];
}

class LoadLyrics extends LyricsEvent {}

class CreateLyricEvent extends LyricsEvent {
  final Lyric lyric;

  const CreateLyricEvent(this.lyric);

  @override
  List<Object> get props => [lyric];
}

class UpdateLyricEvent extends LyricsEvent {
  final Lyric lyric;

  const UpdateLyricEvent(this.lyric);

  @override
  List<Object> get props => [lyric];
}

class DeleteLyricEvent extends LyricsEvent {
  final String lyricId;

  const DeleteLyricEvent(this.lyricId);

  @override
  List<Object> get props => [lyricId];
}

class SearchLyricsEvent extends LyricsEvent {
  final String query;

  const SearchLyricsEvent(this.query);

  @override
  List<Object> get props => [query];
}

class ClearSearch extends LyricsEvent {}