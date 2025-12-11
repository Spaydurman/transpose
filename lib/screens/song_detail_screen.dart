import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/song_model.dart';
import '../utils/chord_transposer.dart';

/// Screen for viewing and transposing song chords
class SongDetailScreen extends StatefulWidget {
  final Song song;

  const SongDetailScreen({super.key, required this.song});

  @override
  State<SongDetailScreen> createState() => _SongDetailScreenState();
}

class _SongDetailScreenState extends State<SongDetailScreen> {
  int _transposeValue = 0;
  String? _selectedText;
  bool _isSelecting = false;
  int _selectionStart = 0;
  int _selectionEnd = 0;

  // History for undo/redo
  final List<String> _history = [];
  int _historyIndex = -1;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _history.add(widget.song.lyrics);
    _historyIndex = 0;
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  // Getters
  String get displayedLyrics =>
      ChordTransposer.transposeText(widget.song.lyrics, _transposeValue);

  bool get _hasChords {
    if (_selectedText == null || _selectedText!.isEmpty) return false;
    return ChordTransposer.containsChords(_selectedText!);
  }

  bool get canUndo => _historyIndex > 0;
  bool get canRedo => _historyIndex < _history.length - 1;

  // History management
  void _addToHistory(String lyrics) {
    if (_historyIndex < _history.length - 1) {
      _history.removeRange(_historyIndex + 1, _history.length);
    }

    _history.add(lyrics);
    _historyIndex++;

    // Limit history size
    if (_history.length > 50) {
      _history.removeAt(0);
      _historyIndex--;
    }
  }

  void _undo() {
    if (!canUndo) return;

    setState(() {
      _historyIndex--;
      widget.song.lyrics = _history[_historyIndex];
      _clearSelection();
    });

    _showFeedback('Undo');
  }

  void _redo() {
    if (!canRedo) return;

    setState(() {
      _historyIndex++;
      widget.song.lyrics = _history[_historyIndex];
      _clearSelection();
    });

    _showFeedback('Redo');
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return;

    final isControlPressed = HardwareKeyboard.instance.isControlPressed;

    if (isControlPressed && event.logicalKey == LogicalKeyboardKey.keyZ) {
      _undo();
    } else if (isControlPressed &&
        event.logicalKey == LogicalKeyboardKey.keyY) {
      _redo();
    }
  }

  // Transpose operations
  void _transpose(int semitones) {
    setState(() {
      _transposeValue = (_transposeValue + semitones) % 12;
      if (_transposeValue < 0) _transposeValue += 12;
    });
  }

  void _reset() {
    setState(() {
      _transposeValue = 0;
      _clearSelection();
    });
  }

  void _transposeSelection(int semitones) {
    if (_selectedText == null) return;

    setState(() {
      final transposed = ChordTransposer.transposeText(
        _selectedText!,
        semitones,
      );
      final beforeSelection = widget.song.lyrics.substring(
        0,
        _selectionStart.clamp(0, widget.song.lyrics.length),
      );
      final afterSelection = _selectionEnd < widget.song.lyrics.length
          ? widget.song.lyrics.substring(_selectionEnd)
          : '';

      widget.song.lyrics = beforeSelection + transposed + afterSelection;
      _addToHistory(widget.song.lyrics);
      _clearSelection();
    });

    _showFeedback(
      'Selection transposed by ${semitones > 0 ? '+' : ''}$semitones semitones',
    );
  }

  // Selection handling
  void _onSelectionChanged(
    TextSelection selection,
    SelectionChangedCause? cause,
  ) {
    if (selection.start != selection.end) {
      setState(() {
        _selectionStart = selection.start;
        _selectionEnd = selection.end;
        _selectedText = displayedLyrics.substring(
          selection.start,
          selection.end,
        );
        _isSelecting = true;
      });
    } else {
      setState(() {
        _clearSelection();
      });
    }
  }

  void _clearSelection() {
    _selectedText = null;
    _isSelecting = false;
    _selectionStart = 0;
    _selectionEnd = 0;
  }

  // UI helpers
  void _showFeedback(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      onKeyEvent: _handleKeyEvent,
      autofocus: true,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: Column(
          children: [
            _buildTransposeControls(),
            _buildLyricsDisplay(),
            if (_selectedText != null && _isSelecting && _hasChords)
              _buildSelectionTransposePanel(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Column(
        children: [
          Text(
            widget.song.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            widget.song.artist,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.undo),
          onPressed: canUndo ? _undo : null,
          tooltip: 'Undo (Ctrl+Z)',
        ),
        IconButton(
          icon: const Icon(Icons.redo),
          onPressed: canRedo ? _redo : null,
          tooltip: 'Redo (Ctrl+Y)',
        ),
      ],
    );
  }

  Widget _buildTransposeControls() {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton.filledTonal(
                onPressed: () => _transpose(-1),
                icon: const Icon(Icons.remove),
                tooltip: 'Transpose down',
              ),
              const SizedBox(width: 16),
              _buildTransposeDisplay(theme),
              const SizedBox(width: 16),
              IconButton.filledTonal(
                onPressed: () => _transpose(1),
                icon: const Icon(Icons.add),
                tooltip: 'Transpose up',
              ),
            ],
          ),
          if (_transposeValue != 0) ...[
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _reset,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Reset'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTransposeDisplay(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            'Transpose',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
          Text(
            _transposeValue == 0
                ? 'Original'
                : '${_transposeValue > 0 ? '+' : ''}$_transposeValue',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLyricsDisplay() {
    final theme = Theme.of(context);

    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: SelectableText(
          displayedLyrics,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 14,
            height: 1.6,
            color: theme.colorScheme.onSurface,
          ),
          onSelectionChanged: _onSelectionChanged,
        ),
      ),
    );
  }

  Widget _buildSelectionTransposePanel() {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Transpose Selected Text',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSecondaryContainer,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            alignment: WrapAlignment.center,
            children: [
              for (int i = -6; i <= 6; i++)
                if (i != 0)
                  FilledButton.tonal(
                    onPressed: () => _transposeSelection(i),
                    child: Text('${i > 0 ? '+' : ''}$i'),
                  ),
            ],
          ),
        ],
      ),
    );
  }
}
