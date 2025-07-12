import 'package:flutter/material.dart';
import '../../domain/entities/lyric.dart';
import 'lyric_card.dart';

class LyricsList extends StatelessWidget {
  final List<Lyric> lyrics;

  const LyricsList({
    super.key,
    required this.lyrics,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: lyrics.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: LyricCard(lyric: lyrics[index]),
        );
      },
    );
  }
}