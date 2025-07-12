import 'package:flutter/material.dart';
import '../../domain/entities/lyric_section.dart';
import '../../domain/entities/section_type.dart';

class SectionEditor extends StatefulWidget {
  final LyricSection section;
  final int index;
  final Function(LyricSection) onUpdate;
  final VoidCallback? onRemove;

  const SectionEditor({
    super.key,
    required this.section,
    required this.index,
    required this.onUpdate,
    this.onRemove,
  });

  @override
  State<SectionEditor> createState() => _SectionEditorState();
}

class _SectionEditorState extends State<SectionEditor> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late SectionType _selectedType;
  TextEditingController? _customTypeController;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.section.title);
    _contentController = TextEditingController(text: widget.section.content);
    _selectedType = widget.section.type;
    
    if (_selectedType == SectionType.custom && widget.section.customType != null) {
      _customTypeController = TextEditingController(text: widget.section.customType);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _customTypeController?.dispose();
    super.dispose();
  }

  void _updateSection() {
    final updatedSection = widget.section.copyWith(
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      type: _selectedType,
      customType: _selectedType == SectionType.custom 
          ? _customTypeController?.text.trim() 
          : null,
      updatedAt: DateTime.now(),
    );
    widget.onUpdate(updatedSection);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          _buildHeader(),
          if (_isExpanded) _buildContent(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return InkWell(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.drag_handle,
              color: Colors.grey[400],
            ),
            const SizedBox(width: 8),
            Icon(
              _getSectionIcon(_selectedType),
              color: _getSectionColor(_selectedType),
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _titleController.text.isEmpty 
                        ? 'Untitled Section' 
                        : _titleController.text,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _selectedType.displayName,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: _getSectionColor(_selectedType),
                    ),
                  ),
                ],
              ),
            ),
            if (widget.onRemove != null)
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _showDeleteDialog(),
              ),
            Icon(
              _isExpanded ? Icons.expand_less : Icons.expand_more,
              color: Colors.grey[600],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Section Title',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  onChanged: (_) => _updateSection(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField<SectionType>(
                  value: _selectedType,
                  decoration: const InputDecoration(
                    labelText: 'Type',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  items: SectionType.values.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Row(
                        children: [
                          Icon(
                            _getSectionIcon(type),
                            size: 16,
                            color: _getSectionColor(type),
                          ),
                          const SizedBox(width: 8),
                          Text(type.displayName),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (type) {
                    setState(() {
                      _selectedType = type!;
                      if (type == SectionType.custom) {
                        _customTypeController = TextEditingController();
                      } else {
                        _customTypeController?.dispose();
                        _customTypeController = null;
                      }
                    });
                    _updateSection();
                  },
                ),
              ),
            ],
          ),
          if (_selectedType == SectionType.custom) ...[
            const SizedBox(height: 16),
            TextFormField(
              controller: _customTypeController,
              decoration: const InputDecoration(
                labelText: 'Custom Type Name',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (_) => _updateSection(),
            ),
          ],
          const SizedBox(height: 16),
          TextFormField(
            controller: _contentController,
            decoration: const InputDecoration(
              labelText: 'Lyrics',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
            maxLines: 6,
            onChanged: (_) => _updateSection(),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 16,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 8),
              Text(
                'Lines: ${_contentController.text.split('\n').length}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(width: 16),
              Text(
                'Characters: ${_contentController.text.length}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
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

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Section'),
        content: Text('Are you sure you want to delete this section?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              widget.onRemove?.call();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}