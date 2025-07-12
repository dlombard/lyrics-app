import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/lyrics_bloc.dart';
import '../bloc/lyrics_event.dart';
import '../bloc/lyrics_state.dart';
import '../widgets/lyrics_list.dart';
import '../widgets/search_bar.dart';
import 'create_lyric_page.dart';

class LyricsHomePage extends StatefulWidget {
  const LyricsHomePage({super.key});

  @override
  State<LyricsHomePage> createState() => _LyricsHomePageState();
}

class _LyricsHomePageState extends State<LyricsHomePage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<LyricsBloc>().add(LoadLyrics());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Lyrics',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Navigate to settings
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomSearchBar(
              controller: _searchController,
              onChanged: (query) {
                if (query.trim().isEmpty) {
                  context.read<LyricsBloc>().add(ClearSearch());
                } else {
                  context.read<LyricsBloc>().add(SearchLyricsEvent(query));
                }
              },
              onClear: () {
                _searchController.clear();
                context.read<LyricsBloc>().add(ClearSearch());
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<LyricsBloc, LyricsState>(
              builder: (context, state) {
                if (state is LyricsLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is LyricsError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Oops! Something went wrong',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<LyricsBloc>().add(LoadLyrics());
                          },
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  );
                } else if (state is LyricsLoaded) {
                  if (state.lyrics.isEmpty) {
                    return _buildEmptyState(context, state.isSearching);
                  }
                  return LyricsList(lyrics: state.lyrics);
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final lyricsBloc = context.read<LyricsBloc>();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => BlocProvider<LyricsBloc>.value(
                value: lyricsBloc,
                child: const CreateLyricPage(),
              ),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('New Lyric'),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isSearching) {
    if (isSearching) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No lyrics found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Try a different search term',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.library_music,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No lyrics yet',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first lyric to get started',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              final lyricsBloc = context.read<LyricsBloc>();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BlocProvider<LyricsBloc>.value(
                    value: lyricsBloc,
                    child: const CreateLyricPage(),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Create Lyric'),
          ),
        ],
      ),
    );
  }
}