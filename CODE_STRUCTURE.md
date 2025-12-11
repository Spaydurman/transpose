# Chord Master - Code Organization

## Project Structure

```
lib/
├── main.dart                      # App entry point
├── models/                        # Data models
│   └── song_model.dart           # Song model with chords and lyrics
├── utils/                        # Utility classes
│   └── chord_transposer.dart     # Chord transposition logic
├── theme/                        # Theme configuration
│   ├── app_theme.dart            # Light and dark theme definitions
│   └── theme_notifier.dart       # Theme state management
└── screens/                      # UI screens
    ├── song_list_screen.dart     # Main screen with song list
    ├── add_edit_song_screen.dart # Add/edit song form
    └── song_detail_screen.dart   # Song viewer with transpose controls
```

## Naming Conventions

- **Files**: `snake_case` (e.g., `song_model.dart`, `chord_transposer.dart`)
- **Classes**: `PascalCase` (e.g., `Song`, `ChordTransposer`, `ThemeNotifier`)
- **Variables/Methods**: `camelCase` (e.g., `transposeChord`, `displayedLyrics`)
- **Private members**: Prefix with `_` (e.g., `_transposeValue`, `_addToHistory`)
- **Constants**: `SCREAMING_SNAKE_CASE` or `camelCase` with const

## File Descriptions

### Models
- **song_model.dart**: Defines the Song class with id, title, artist, and lyrics properties

### Utils
- **chord_transposer.dart**: Contains all chord transposition logic
  - `transposeChord()`: Transpose single chord
  - `transposeLine()`: Transpose chords in a line
  - `transposeText()`: Transpose all chords in text
  - `containsChords()`: Check if text contains chords

### Theme
- **app_theme.dart**: Centralized theme configuration for light and dark modes
- **theme_notifier.dart**: State management for theme switching

### Screens
- **song_list_screen.dart**: 
  - Displays all songs in a card list
  - Add/edit/delete song operations
  - Theme toggle button
  
- **add_edit_song_screen.dart**:
  - Form for creating or editing songs
  - Title, artist, and lyrics input fields
  - Validation and save logic
  
- **song_detail_screen.dart**:
  - View song with transposed chords
  - Whole song transpose controls (+/- semitones)
  - Selection transpose for partial text
  - Undo/redo with Ctrl+Z/Ctrl+Y
  - History management (up to 50 states)

## Clean Code Principles Applied

1. **Single Responsibility**: Each file has one clear purpose
2. **Separation of Concerns**: Models, utilities, theme, and screens are separated
3. **DRY (Don't Repeat Yourself)**: Reusable components and utility functions
4. **Clear Naming**: Descriptive names that explain purpose
5. **Documentation**: Comprehensive comments for classes and methods
6. **Encapsulation**: Private methods and fields where appropriate
7. **Composition**: Small, focused widgets built from smaller pieces

## Features

- ✅ Dark/Light mode with smooth transitions
- ✅ Add/edit/delete songs
- ✅ Transpose whole song (non-destructive)
- ✅ Transpose selected text (permanent)
- ✅ Smart chord detection
- ✅ Undo/Redo (Ctrl+Z/Ctrl+Y)
- ✅ History tracking (50 states)
- ✅ Clean, modern Material 3 UI
