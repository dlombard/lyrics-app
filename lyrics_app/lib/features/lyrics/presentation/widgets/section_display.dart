import 'package:flutter/material.dart';
import '../../domain/entities/lyric_section.dart';
import '../../domain/entities/section_type.dart';

class SectionDisplay extends StatelessWidget {
  final LyricSection section;
  final int index;
  final bool showIndex;

  const SectionDisplay({
    super.key,
    required this.section,
    required this.index,
    this.showIndex = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 12),
            _buildContent(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: _getSectionColor(section.type),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: showIndex
                ? Text(
                    '$index',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  )
                : Icon(
                    _getSectionIcon(section.type),
                    color: Colors.white,
                    size: 16,
                  ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                section.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Icon(
                    _getSectionIcon(section.type),
                    size: 14,
                    color: _getSectionColor(section.type),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    section.type == SectionType.custom && section.customType != null
                        ? section.customType!
                        : section.type.displayName,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: _getSectionColor(section.type),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        _buildSectionBadge(context),
      ],
    );
  }

  Widget _buildSectionBadge(BuildContext context) {
    final lines = section.content.split('\n').where((line) => line.trim().isNotEmpty).length;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$lines lines',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Colors.grey[600],
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (section.content.trim().isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Text(
          'No lyrics added yet',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.grey[500],
            fontStyle: FontStyle.italic,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getSectionColor(section.type).withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _getSectionColor(section.type).withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            section.content,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              height: 1.6,
              fontSize: 16,
            ),
          ),
          if (section.content.contains('\n')) ...[
            const SizedBox(height: 8),
            Text(
              '${section.content.split('\n').length} lines',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ],
      ),
    );
  }

  IconData _getSectionIcon(SectionType type) {
    switch (type) {
      case SectionType.verse:
        return Icons.format_list_numbered;
      case SectionType.chorus:
        return Icons.repeat;
      case SectionType.bridge:
        return Icons.compare_arrows;
      case SectionType.intro:
        return Icons.play_arrow;
      case SectionType.outro:
        return Icons.stop;
      case SectionType.preChorus:
        return Icons.fast_forward;
      case SectionType.interlude:
        return Icons.pause;
      case SectionType.custom:
        return Icons.edit;
    }
  }

  Color _getSectionColor(SectionType type) {
    switch (type) {
      case SectionType.verse:
        return Colors.blue;
      case SectionType.chorus:
        return Colors.green;
      case SectionType.bridge:
        return Colors.orange;
      case SectionType.intro:
        return Colors.purple;
      case SectionType.outro:
        return Colors.red;
      case SectionType.preChorus:
        return Colors.teal;
      case SectionType.interlude:
        return Colors.amber;
      case SectionType.custom:
        return Colors.grey;
    }
  }
}