import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/entities/lyric.dart';
import '../../domain/entities/arrangement.dart';
import '../../domain/entities/presentation_settings.dart';

class PresentationPage extends StatefulWidget {
  final Lyric lyric;
  final Arrangement? arrangement;

  const PresentationPage({
    super.key,
    required this.lyric,
    this.arrangement,
  });

  @override
  State<PresentationPage> createState() => _PresentationPageState();
}

class _PresentationPageState extends State<PresentationPage> {
  late PageController _pageController;
  late List<String> _allLines;
  late List<List<String>> _pages;
  int _currentPageIndex = 0;
  bool _showControls = true;
  PresentationSettings _settings = const PresentationSettings();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _prepareContent();
    _hideStatusBar();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _showStatusBar();
    super.dispose();
  }

  void _hideStatusBar() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  void _showStatusBar() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  void _prepareContent() {
    final sections = widget.arrangement != null
        ? widget.lyric.getSectionsInOrder(widget.arrangement!.id)
        : widget.lyric.sections;

    _allLines = [];
    for (final section in sections) {
      _allLines.add('[${section.title}]');
      if (section.content.trim().isNotEmpty) {
        _allLines.addAll(
          section.content.split('\n').where((line) => line.trim().isNotEmpty),
        );
      }
      _allLines.add(''); // Add spacing between sections
    }

    _createPages();
  }

  void _createPages() {
    _pages = [];
    final linesPerPage = _settings.linesPerScreen;
    
    for (int i = 0; i < _allLines.length; i += linesPerPage) {
      final pageLines = _allLines.skip(i).take(linesPerPage).toList();
      if (pageLines.isNotEmpty) {
        _pages.add(pageLines);
      }
    }

    if (_pages.isEmpty) {
      _pages.add(['No content to display']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _settings.darkMode ? Colors.black : Colors.white,
      body: GestureDetector(
        onTap: () {
          setState(() {
            _showControls = !_showControls;
          });
        },
        child: Stack(
          children: [
            _buildPageView(),
            if (_showControls) _buildControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildPageView() {
    return PageView.builder(
      controller: _pageController,
      itemCount: _pages.length,
      onPageChanged: (index) {
        setState(() {
          _currentPageIndex = index;
        });
      },
      itemBuilder: (context, index) {
        return _buildPage(_pages[index]);
      },
    );
  }

  Widget _buildPage(List<String> lines) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: lines.map((line) {
            final isSection = line.startsWith('[') && line.endsWith(']');
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                line,
                style: TextStyle(
                  fontSize: isSection ? _settings.fontSize + 4 : _settings.fontSize,
                  fontFamily: _settings.fontFamily,
                  fontWeight: isSection ? FontWeight.bold : FontWeight.normal,
                  color: _settings.darkMode ? Colors.white : Colors.black,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildControls() {
    return Positioned(
      top: MediaQuery.of(context).padding.top,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
        ),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                Expanded(
                  child: Text(
                    widget.lyric.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.settings, color: Colors.white),
                  onPressed: _showSettingsDialog,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.skip_previous, color: Colors.white),
                  onPressed: _currentPageIndex > 0 ? _previousPage : null,
                ),
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Colors.white,
                      inactiveTrackColor: Colors.white30,
                      thumbColor: Colors.white,
                    ),
                    child: Slider(
                      value: _currentPageIndex.toDouble(),
                      min: 0,
                      max: (_pages.length - 1).toDouble(),
                      divisions: _pages.length - 1,
                      onChanged: (value) {
                        _goToPage(value.round());
                      },
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.skip_next, color: Colors.white),
                  onPressed: _currentPageIndex < _pages.length - 1 ? _nextPage : null,
                ),
              ],
            ),
            Text(
              '${_currentPageIndex + 1} / ${_pages.length}',
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  void _previousPage() {
    if (_currentPageIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _nextPage() {
    if (_currentPageIndex < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Presentation Settings'),
        content: StatefulBuilder(
          builder: (context, setDialogState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text('Lines per screen: ${_settings.linesPerScreen}'),
                  subtitle: Slider(
                    value: _settings.linesPerScreen.toDouble(),
                    min: 1,
                    max: 10,
                    divisions: 9,
                    onChanged: (value) {
                      setDialogState(() {
                        _settings = _settings.copyWith(linesPerScreen: value.round());
                      });
                    },
                  ),
                ),
                ListTile(
                  title: Text('Font size: ${_settings.fontSize.round()}'),
                  subtitle: Slider(
                    value: _settings.fontSize,
                    min: 12,
                    max: 48,
                    divisions: 36,
                    onChanged: (value) {
                      setDialogState(() {
                        _settings = _settings.copyWith(fontSize: value);
                      });
                    },
                  ),
                ),
                SwitchListTile(
                  title: const Text('Dark mode'),
                  value: _settings.darkMode,
                  onChanged: (value) {
                    setDialogState(() {
                      _settings = _settings.copyWith(darkMode: value);
                    });
                  },
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _createPages();
              });
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }
}