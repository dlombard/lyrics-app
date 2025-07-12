import 'package:flutter/material.dart';
import '../../domain/entities/lyric.dart';
import '../../domain/entities/arrangement.dart';
import '../widgets/section_display.dart';
import 'presentation_page.dart';
import 'create_lyric_page.dart';

class LyricDetailPage extends StatefulWidget {
  final Lyric lyric;

  const LyricDetailPage({super.key, required this.lyric});

  @override
  State<LyricDetailPage> createState() => _LyricDetailPageState();
}

class _LyricDetailPageState extends State<LyricDetailPage> {
  Arrangement? _selectedArrangement;

  @override
  void initState() {
    super.initState();
    _selectedArrangement = widget.lyric.defaultArrangement ?? 
        (widget.lyric.arrangements.isNotEmpty ? widget.lyric.arrangements.first : null);
  }

  @override
  Widget build(BuildContext context) {
    final sectionsToShow = _selectedArrangement != null
        ? widget.lyric.getSectionsInOrder(_selectedArrangement!.id)
        : widget.lyric.sections;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lyric.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CreateLyricPage(lyric: widget.lyric),
                ),
              );
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'present':
                  _openPresentationMode();
                  break;
                case 'share':
                  _shareLyric();
                  break;
                case 'duplicate':
                  _duplicateLyric();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'present',
                child: Row(
                  children: [
                    Icon(Icons.slideshow),
                    SizedBox(width: 8),
                    Text('Present'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'share',
                child: Row(
                  children: [
                    Icon(Icons.share),
                    SizedBox(width: 8),
                    Text('Share'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'duplicate',
                child: Row(
                  children: [
                    Icon(Icons.copy),
                    SizedBox(width: 8),
                    Text('Duplicate'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          _buildHeader(),
          if (widget.lyric.arrangements.length > 1) _buildArrangementSelector(),
          Expanded(
            child: _buildSectionsList(sectionsToShow),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openPresentationMode,
        child: const Icon(Icons.slideshow),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).primaryColor.withOpacity(0.1),
            Theme.of(context).primaryColor.withOpacity(0.05),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.lyric.title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          if (widget.lyric.artist != null) ...[
            const SizedBox(height: 4),
            Text(
              'by ${widget.lyric.artist}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
          if (widget.lyric.album != null) ...[
            const SizedBox(height: 2),
            Text(
              'from ${widget.lyric.album}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[500],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              _buildInfoChip(
                Icons.list_alt,
                '${widget.lyric.sections.length} sections',
              ),
              const SizedBox(width: 8),
              _buildInfoChip(
                Icons.video_library,
                '${widget.lyric.arrangements.length} arrangements',
              ),
            ],
          ),
          if (widget.lyric.tags.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: widget.lyric.tags.map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    tag,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey[700]),
          const SizedBox(width: 4),
          Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArrangementSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Text(
            'Arrangement:',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButton<Arrangement>(
              value: _selectedArrangement,
              isExpanded: true,
              underline: Container(),
              items: widget.lyric.arrangements.map((arrangement) {
                return DropdownMenuItem(
                  value: arrangement,
                  child: Row(
                    children: [
                      if (arrangement.isDefault)
                        Icon(
                          Icons.star,
                          size: 16,
                          color: Colors.amber[600],
                        ),
                      if (arrangement.isDefault) const SizedBox(width: 4),
                      Text(arrangement.name),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (arrangement) {
                setState(() {
                  _selectedArrangement = arrangement;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionsList(List sectionsToShow) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sectionsToShow.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: SectionDisplay(
            section: sectionsToShow[index],
            index: index + 1,
          ),
        );
      },
    );
  }

  void _openPresentationMode() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PresentationPage(
          lyric: widget.lyric,
          arrangement: _selectedArrangement,
        ),
      ),
    );
  }

  void _shareLyric() {
    // TODO: Implement sharing functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Share functionality coming soon!')),
    );
  }

  void _duplicateLyric() {
    // TODO: Implement duplication functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Duplicate functionality coming soon!')),
    );
  }
}