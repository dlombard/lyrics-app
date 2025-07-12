import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_all_lyrics.dart';
import '../../domain/usecases/create_lyric.dart';
import '../../domain/usecases/search_lyrics.dart';
import '../../../../core/usecases/usecase.dart';
import 'lyrics_event.dart';
import 'lyrics_state.dart';

class LyricsBloc extends Bloc<LyricsEvent, LyricsState> {
  final GetAllLyrics getAllLyrics;
  final CreateLyric createLyric;
  final SearchLyrics searchLyrics;

  LyricsBloc({
    required this.getAllLyrics,
    required this.createLyric,
    required this.searchLyrics,
  }) : super(LyricsInitial()) {
    on<LoadLyrics>(_onLoadLyrics);
    on<CreateLyricEvent>(_onCreateLyric);
    on<SearchLyricsEvent>(_onSearchLyrics);
    on<ClearSearch>(_onClearSearch);
  }

  Future<void> _onLoadLyrics(
    LoadLyrics event,
    Emitter<LyricsState> emit,
  ) async {
    emit(LyricsLoading());
    
    final result = await getAllLyrics(const NoParams());
    
    result.fold(
      (failure) => emit(LyricsError(failure.message)),
      (lyrics) => emit(LyricsLoaded(lyrics: lyrics)),
    );
  }

  Future<void> _onCreateLyric(
    CreateLyricEvent event,
    Emitter<LyricsState> emit,
  ) async {
    if (state is LyricsLoaded) {
      final currentState = state as LyricsLoaded;
      emit(LyricsLoading());
      
      final result = await createLyric(CreateLyricParams(lyric: event.lyric));
      
      result.fold(
        (failure) => emit(LyricsError(failure.message)),
        (newLyric) {
          final updatedLyrics = [newLyric, ...currentState.lyrics];
          emit(LyricsLoaded(lyrics: updatedLyrics));
        },
      );
    }
  }

  Future<void> _onSearchLyrics(
    SearchLyricsEvent event,
    Emitter<LyricsState> emit,
  ) async {
    if (state is LyricsLoaded) {
      final currentState = state as LyricsLoaded;
      
      if (event.query.trim().isEmpty) {
        emit(currentState.copyWith(isSearching: false, searchQuery: ''));
        return;
      }
      
      emit(currentState.copyWith(isSearching: true, searchQuery: event.query));
      
      final result = await searchLyrics(SearchLyricsParams(query: event.query));
      
      result.fold(
        (failure) => emit(LyricsError(failure.message)),
        (searchResults) => emit(LyricsLoaded(
          lyrics: searchResults,
          isSearching: true,
          searchQuery: event.query,
        )),
      );
    }
  }

  Future<void> _onClearSearch(
    ClearSearch event,
    Emitter<LyricsState> emit,
  ) async {
    if (state is LyricsLoaded) {
      add(LoadLyrics());
    }
  }
}