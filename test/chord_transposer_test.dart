import 'package:flutter_test/flutter_test.dart';
import 'package:transpose/utils/chord_transposer.dart';

void main() {
  group('ChordTransposer sharp handling', () {
    test('No extra # when sharp -> sharp', () {
      const input = 'G        C#        G#        Bm';
      // Transpose by +5 semitones: G->C, C#->F#, G#->C#, Bm->Em
      final output = ChordTransposer.transposeLine(input, 5);
      expect(output, 'C        F#        C#        Em');
    });

    test('Handles Unicode sharps and flats', () {
      const input = 'C♯m F♭ G♯';
      // +1 semitone: C#->D, F♭(=E)->F, G#->A
      final output = ChordTransposer.transposeLine(input, 1);
      expect(output, 'Dm F A');
    });

    test('Normalizes double accidentals gracefully', () {
      const input = 'C## Dbb';
      // +0 semitones: C## -> D, Dbb -> C
      final output = ChordTransposer.transposeLine(input, 0);
      expect(output, 'D C');
    });
  });
}
