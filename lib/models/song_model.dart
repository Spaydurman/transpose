/// Song model representing a song with chords and lyrics
class Song {
  final String id;
  String title;
  String artist;
  String lyrics;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.lyrics,
  });

  /// Create a copy of the song with optional parameter updates
  Song copyWith({String? id, String? title, String? artist, String? lyrics}) {
    return Song(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      lyrics: lyrics ?? this.lyrics,
    );
  }
}
