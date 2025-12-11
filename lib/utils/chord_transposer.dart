/// Utility class for transposing musical chords
class ChordTransposer {
  // Private constructor to prevent instantiation
  ChordTransposer._();

  /// Chromatic scale with all 12 semitones
  static const List<String> chromaticScale = [
    'C',
    'C#',
    'D',
    'D#',
    'E',
    'F',
    'F#',
    'G',
    'G#',
    'A',
    'A#',
    'B',
  ];

  /// Mapping of flat notes to their sharp equivalents
  static const Map<String, String> alternateChords = {
    'Db': 'C#',
    'Eb': 'D#',
    'Gb': 'F#',
    'Ab': 'G#',
    'Bb': 'A#',
    'E#': 'F',
    'B#': 'C',
    'Cb': 'B',
    'Fb': 'E',
  };

  /// Regex pattern to match chord notations
  static final RegExp _chordPattern = RegExp(
    r'\b([A-G][#b]?(?:m|maj|min|dim|aug|sus|add|[0-9])*)\b',
  );

  /// Transpose a single chord by the specified number of semitones
  static String transposeChord(String chord, int semitones) {
    if (chord.isEmpty) return chord;

    final chordParts = _parseChord(chord);
    if (chordParts == null) return chord;

    final String rootNote = chordParts['root']!;
    final String suffix = chordParts['suffix']!;

    // Find current position in chromatic scale
    final int currentIndex = chromaticScale.indexOf(rootNote);
    if (currentIndex == -1) return chord;

    // Calculate new position with proper wrapping
    int newIndex = (currentIndex + semitones) % chromaticScale.length;
    if (newIndex < 0) newIndex += chromaticScale.length;

    return chromaticScale[newIndex] + suffix;
  }

  /// Transpose all chords in a single line of text
  static String transposeLine(String line, int semitones) {
    return line.replaceAllMapped(_chordPattern, (match) {
      final String chord = match.group(1)!;
      return transposeChord(chord, semitones);
    });
  }

  /// Transpose all chords in multi-line text
  static String transposeText(String text, int semitones) {
    if (semitones == 0) return text;

    final List<String> lines = text.split('\n');
    return lines.map((line) => transposeLine(line, semitones)).join('\n');
  }

  /// Check if the given text contains any chords
  static bool containsChords(String text) {
    return _chordPattern.hasMatch(text);
  }

  /// Parse a chord into its root note and suffix
  /// Returns a map with 'root' and 'suffix' keys, or null if parsing fails
  static Map<String, String>? _parseChord(String chord) {
    String rootNote = '';
    String suffix = '';

    // Handle flats (e.g., Db, Eb)
    if (chord.length >= 2 && chord[1] == 'b') {
      rootNote = chord.substring(0, 2);
      suffix = chord.length > 2 ? chord.substring(2) : '';
    }
    // Handle sharps (e.g., C#, F#)
    else if (chord.length >= 2 && chord[1] == '#') {
      rootNote = chord.substring(0, 2);
      suffix = chord.length > 2 ? chord.substring(2) : '';
    }
    // Handle natural notes (e.g., C, G, Am)
    else {
      rootNote = chord[0];
      suffix = chord.length > 1 ? chord.substring(1) : '';
    }

    // Remove any leading # or b from suffix to prevent F## or Dbb
    suffix = suffix.replaceFirst(RegExp(r'^[#b]+'), '');

    // Convert flats to sharps for consistent processing
    if (alternateChords.containsKey(rootNote)) {
      rootNote = alternateChords[rootNote]!;
    }

    return {'root': rootNote, 'suffix': suffix};
  }
}
