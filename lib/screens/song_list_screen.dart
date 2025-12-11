import 'package:flutter/material.dart';
import '../models/song_model.dart';
import '../theme/theme_notifier.dart';
import 'add_edit_song_screen.dart';
import 'song_detail_screen.dart';

/// Screen displaying the list of all songs
class SongListScreen extends StatefulWidget {
  final ThemeNotifier themeNotifier;

  const SongListScreen({super.key, required this.themeNotifier});

  @override
  State<SongListScreen> createState() => _SongListScreenState();
}

class _SongListScreenState extends State<SongListScreen> {
  final List<Song> _songs = [
    Song(
      id: '1',
      title: 'Sample Song',
      artist: 'Demo Artist',
      lyrics: '''[Verse 1]
C        G        Am       F
This is a sample song with chords
C        G           F
You can transpose these chords

[Chorus]
F        C        G        Am
Sing along with the melody
F        C             G
Change the key as you need

[Bridge]
Dm       Em       F        G
Select text to transpose parts
C        Am       F        G
Or transpose the whole song''',
    ),
  ];

  /// Navigate to add/edit song screen
  Future<void> _addOrEditSong([Song? song]) async {
    final result = await Navigator.push<Song>(
      context,
      MaterialPageRoute(builder: (context) => AddEditSongScreen(song: song)),
    );

    if (result != null && mounted) {
      setState(() {
        if (song == null) {
          _songs.add(result);
        } else {
          final index = _songs.indexWhere((s) => s.id == result.id);
          if (index != -1) {
            _songs[index] = result;
          }
        }
      });
    }
  }

  /// Delete a song from the list
  void _deleteSong(Song song) {
    setState(() {
      _songs.removeWhere((s) => s.id == song.id);
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${song.title} deleted'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  /// Navigate to song detail screen
  void _viewSong(Song song) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SongDetailScreen(song: song)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: _buildAppBar(),
      body: _songs.isEmpty ? _buildEmptyState(theme) : _buildSongList(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  /// Build the app bar
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'Chord Master',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      actions: [
        IconButton(
          icon: Icon(
            widget.themeNotifier.isDarkMode
                ? Icons.light_mode_rounded
                : Icons.dark_mode_rounded,
          ),
          onPressed: widget.themeNotifier.toggleTheme,
          tooltip: 'Toggle theme',
        ),
      ],
    );
  }

  /// Build the empty state widget
  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.music_note_outlined,
            size: 80,
            color: theme.colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No songs yet',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap + to add your first song',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.4),
            ),
          ),
        ],
      ),
    );
  }

  /// Build the song list
  Widget _buildSongList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _songs.length,
      itemBuilder: (context, index) => _buildSongCard(_songs[index]),
    );
  }

  /// Build a single song card
  Widget _buildSongCard(Song song) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        child: InkWell(
          onTap: () => _viewSong(song),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildSongIcon(theme),
                const SizedBox(width: 16),
                _buildSongInfo(song, theme),
                _buildOptionsMenu(song),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build the song icon
  Widget _buildSongIcon(ThemeData theme) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        Icons.music_note,
        color: theme.colorScheme.onPrimaryContainer,
        size: 28,
      ),
    );
  }

  /// Build song title and artist info
  Widget _buildSongInfo(Song song, ThemeData theme) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            song.title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            song.artist,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  /// Build the options menu
  Widget _buildOptionsMenu(Song song) {
    return PopupMenuButton(
      icon: const Icon(Icons.more_vert),
      itemBuilder: (context) => [
        PopupMenuItem(
          child: const Row(
            children: [Icon(Icons.edit), SizedBox(width: 12), Text('Edit')],
          ),
          onTap: () {
            Future.delayed(Duration.zero, () => _addOrEditSong(song));
          },
        ),
        PopupMenuItem(
          child: const Row(
            children: [
              Icon(Icons.delete, color: Colors.red),
              SizedBox(width: 12),
              Text('Delete', style: TextStyle(color: Colors.red)),
            ],
          ),
          onTap: () => _deleteSong(song),
        ),
      ],
    );
  }

  /// Build the floating action button
  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () => _addOrEditSong(),
      icon: const Icon(Icons.add),
      label: const Text('Add Song'),
    );
  }
}
