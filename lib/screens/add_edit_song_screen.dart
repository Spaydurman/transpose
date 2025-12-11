import 'package:flutter/material.dart';
import '../models/song_model.dart';

/// Screen for adding a new song or editing an existing one
class AddEditSongScreen extends StatefulWidget {
  final Song? song;

  const AddEditSongScreen({super.key, this.song});

  @override
  State<AddEditSongScreen> createState() => _AddEditSongScreenState();
}

class _AddEditSongScreenState extends State<AddEditSongScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _artistController;
  late final TextEditingController _lyricsController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.song?.title ?? '');
    _artistController = TextEditingController(text: widget.song?.artist ?? '');
    _lyricsController = TextEditingController(text: widget.song?.lyrics ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _artistController.dispose();
    _lyricsController.dispose();
    super.dispose();
  }

  /// Validate and save the song
  void _saveSong() {
    if (_titleController.text.trim().isEmpty) {
      _showError('Please enter a song title');
      return;
    }

    final song = Song(
      id: widget.song?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      artist: _artistController.text.trim(),
      lyrics: _lyricsController.text,
    );

    Navigator.pop(context, song);
  }

  /// Show error message
  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEditing = widget.song != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Song' : 'Add Song'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveSong,
            tooltip: 'Save',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitleField(),
            const SizedBox(height: 16),
            _buildArtistField(),
            const SizedBox(height: 16),
            _buildLyricsSection(theme),
          ],
        ),
      ),
    );
  }

  /// Build title input field
  Widget _buildTitleField() {
    return TextField(
      controller: _titleController,
      decoration: InputDecoration(
        labelText: 'Song Title',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        prefixIcon: const Icon(Icons.title),
      ),
      textCapitalization: TextCapitalization.words,
      autofocus: widget.song == null,
    );
  }

  /// Build artist input field
  Widget _buildArtistField() {
    return TextField(
      controller: _artistController,
      decoration: InputDecoration(
        labelText: 'Artist',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        prefixIcon: const Icon(Icons.person),
      ),
      textCapitalization: TextCapitalization.words,
    );
  }

  /// Build lyrics section with instructions
  Widget _buildLyricsSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Lyrics & Chords',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Write chords on separate lines or inline with lyrics',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 12),
        _buildLyricsField(),
      ],
    );
  }

  /// Build lyrics input field
  Widget _buildLyricsField() {
    return TextField(
      controller: _lyricsController,
      decoration: InputDecoration(
        hintText:
            'Example:\n[Verse]\nC        G        Am\nYour lyrics here...',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        alignLabelWithHint: true,
      ),
      maxLines: 15,
      style: const TextStyle(fontFamily: 'monospace', fontSize: 14),
    );
  }
}
