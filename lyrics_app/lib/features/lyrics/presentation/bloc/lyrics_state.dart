import 'package:equatable/equatable.dart';
import '../../domain/entities/lyric.dart';

abstract class LyricsState extends Equatable {
  const LyricsState();

  @override
  List<Object> get props => [];
}

class LyricsInitial extends LyricsState {}

class LyricsLoading extends LyricsState {}

class LyricsLoaded extends LyricsState {
  final List<Lyric> lyrics;
  final bool isSearching;
  final String searchQuery;

  const LyricsLoaded({
    required this.lyrics,
    this.isSearching = false,
    this.searchQuery = '',
  });

  LyricsLoaded copyWith({
    List<Lyric>? lyrics,
    bool? isSearching,
    String? searchQuery,
  }) {
    return LyricsLoaded(
      lyrics: lyrics ?? this.lyrics,
      isSearching: isSearching ?? this.isSearching,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object> get props => [lyrics, isSearching, searchQuery];
}

class LyricsError extends LyricsState {
  final String message;

  const LyricsError(this.message);

  @override
  List<Object> get props => [message];
}