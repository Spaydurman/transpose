class ChordTransposer {
  ChordTransposer._();

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

  static final RegExp _chordPattern = RegExp(
    r'(?<![A-Za-z0-9#b♯♭])([A-G][#b♯♭]*(?:m|maj|min|dim|aug|sus|add|[0-9])*)(?![A-Za-z0-9#b♯♭])',
  );

  static String transposeChord(String chord, int semitones) {
    if (chord.isEmpty) return chord;

    final chordParts = _parseChord(chord);
    if (chordParts == null) return chord;

    final String rootNote = chordParts['root']!;
    final String suffix = chordParts['suffix']!;

    final int currentIndex = chromaticScale.indexOf(rootNote);
    if (currentIndex == -1) return chord;

    int newIndex = (currentIndex + semitones) % chromaticScale.length;
    if (newIndex < 0) newIndex += chromaticScale.length;

    return chromaticScale[newIndex] + suffix;
  }

  static String transposeLine(String line, int semitones) {
    return line.replaceAllMapped(_chordPattern, (match) {
      final String chord = match.group(1)!;
      return transposeChord(chord, semitones);
    });
  }

  static String transposeText(String text, int semitones) {
    if (semitones == 0) return text;

    final List<String> lines = text.split('\n');
    return lines.map((line) => transposeLine(line, semitones)).join('\n');
  }

  static bool containsChords(String text) {
    return _chordPattern.hasMatch(text);
  }

  static Map<String, String>? _parseChord(String chord) {
    if (chord.isEmpty) return null;

    final String normalized = chord
        .replaceAll('♯', '#')
        .replaceAll('♭', 'b');

    final RegExp parse = RegExp(r'^([A-G])([#b]*)(.*)$');
    final Match? m = parse.firstMatch(normalized);
    if (m == null) return null;

    final String base = m.group(1)!; 
    final String acc = m.group(2)!; 
    final String suffix = m.group(3)!;

    const Map<String, int> baseIndex = {
      'C': 0,
      'D': 2,
      'E': 4,
      'F': 5,
      'G': 7,
      'A': 9,
      'B': 11,
    };

    int idx = baseIndex[base]!;

    for (int i = 0; i < acc.length; i++) {
      final String ch = acc[i];
      if (ch == '#') {
        idx += 1;
      } else if (ch == 'b') {
        idx -= 1;
      }
    }

    idx %= chromaticScale.length;
    if (idx < 0) idx += chromaticScale.length;

    final String normalizedRoot = chromaticScale[idx];
    return {'root': normalizedRoot, 'suffix': suffix};
  }
}
