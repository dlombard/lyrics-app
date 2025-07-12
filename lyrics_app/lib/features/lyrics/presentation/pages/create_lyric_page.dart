import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/lyric.dart';
import '../../domain/entities/lyric_section.dart';
import '../../domain/entities/section_type.dart';
import '../bloc/lyrics_bloc.dart';
import '../bloc/lyrics_event.dart';
import '../widgets/section_editor.dart';

class CreateLyricPage extends StatefulWidget {
  final Lyric? lyric;

  const CreateLyricPage({super.key, this.lyric});

  @override
  State<CreateLyricPage> createState() => _CreateLyricPageState();
}

class _CreateLyricPageState extends State<CreateLyricPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _artistController = TextEditingController();
  final _albumController = TextEditingController();
  final _uuid = const Uuid();

  List<LyricSection> _sections = [];
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.lyric != null;
    
    if (_isEditing) {
      _titleController.text = widget.lyric!.title;
      _artistController.text = widget.lyric!.artist ?? '';
      _albumController.text = widget.lyric!.album ?? '';
      _sections = List.from(widget.lyric!.sections);
    } else {
      _addDefaultSection();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _artistController.dispose();
    _albumController.dispose();
    super.dispose();
  }

  void _addDefaultSection() {
    final now = DateTime.now();
    _sections.add(
      LyricSection(
        id: _uuid.v4(),
        title: 'Verse 1',
        content: '',
        type: SectionType.verse,
        order: _sections.length,
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  void _addSection(SectionType type) {
    final now = DateTime.now();
    String title = type.displayName;
    
    final existingSections = _sections.where((s) => s.type == type).length;
    if (existingSections > 0 && type != SectionType.custom) {
      title = '${type.displayName} ${existingSections + 1}';
    }

    setState(() {
      _sections.add(
        LyricSection(
          id: _uuid.v4(),
          title: title,
          content: '',
          type: type,
          order: _sections.length,
          createdAt: now,
          updatedAt: now,
        ),
      );
    });
  }

  void _updateSection(int index, LyricSection section) {
    setState(() {
      _sections[index] = section;
    });
  }

  void _removeSection(int index) {
    setState(() {
      _sections.removeAt(index);
      for (int i = 0; i < _sections.length; i++) {
        _sections[i] = _sections[i].copyWith(order: i);
      }
    });
  }

  void _reorderSections(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final section = _sections.removeAt(oldIndex);
      _sections.insert(newIndex, section);
      
      for (int i = 0; i < _sections.length; i++) {
        _sections[i] = _sections[i].copyWith(order: i);
      }
    });
  }

  void _saveLyric() {
    if (!_formKey.currentState!.validate()) return;
    if (_sections.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one section')),
      );
      return;
    }

    final now = DateTime.now();
    final lyric = Lyric(
      id: _isEditing ? widget.lyric!.id : _uuid.v4(),
      title: _titleController.text.trim(),
      artist: _artistController.text.trim().isEmpty 
          ? null 
          : _artistController.text.trim(),
      album: _albumController.text.trim().isEmpty 
          ? null 
          : _albumController.text.trim(),
      sections: _sections,
      arrangements: _isEditing ? widget.lyric!.arrangements : [],
      tags: _isEditing ? widget.lyric!.tags : [],
      createdAt: _isEditing ? widget.lyric!.createdAt : now,
      updatedAt: now,
    );

    context.read<LyricsBloc>().add(CreateLyricEvent(lyric));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Lyric' : 'Create Lyric'),
        actions: [
          TextButton(
            onPressed: _saveLyric,
            child: Text(
              _isEditing ? 'Update' : 'Save',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBasicInfo(),
                    const SizedBox(height: 24),
                    _buildSectionsHeader(),
                    const SizedBox(height: 16),
                    _buildSectionsList(),
                  ],
                ),
              ),
            ),
            _buildAddSectionButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Basic Information',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title *',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _artistController,
              decoration: const InputDecoration(
                labelText: 'Artist',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _albumController,
              decoration: const InputDecoration(
                labelText: 'Album',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionsHeader() {
    return Row(
      children: [
        Text(
          'Sections',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        Text(
          '${_sections.length} sections',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionsList() {
    return ReorderableListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _sections.length,
      onReorder: _reorderSections,
      itemBuilder: (context, index) {
        return SectionEditor(
          key: ValueKey(_sections[index].id),
          section: _sections[index],
          index: index,
          onUpdate: (section) => _updateSection(index, section),
          onRemove: _sections.length > 1 ? () => _removeSection(index) : null,
        );
      },
    );
  }

  Widget _buildAddSectionButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _showAddSectionDialog(),
              icon: const Icon(Icons.add),
              label: const Text('Add Section'),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddSectionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Section'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: SectionType.values.map((type) {
            return ListTile(
              leading: Icon(_getSectionIcon(type)),
              title: Text(type.displayName),
              onTap: () {
                Navigator.of(context).pop();
                _addSection(type);
              },
            );
          }).toList(),
        ),
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
}