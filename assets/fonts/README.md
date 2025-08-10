# Font Setup Instructions (Optional)

The app is designed to work with or without the Poppins font family. Currently, the app uses the system default font.

## To Add Poppins Fonts (Optional Enhancement):

### Required Font Files:
- `Poppins-Regular.ttf`
- `Poppins-Medium.ttf`
- `Poppins-SemiBold.ttf`
- `Poppins-Bold.ttf`

### How to Get the Fonts:
1. Visit [Google Fonts - Poppins](https://fonts.google.com/specimen/Poppins)
2. Download the font family
3. Extract the TTF files and place them in this directory
4. Ensure the filenames match exactly as listed above

### Alternative Sources:
- [Fontsquirrel](https://www.fontsquirrel.com/fonts/poppins)
- [DaFont](https://www.dafont.com/poppins.font)

### To Enable Poppins Fonts:
1. Add the font files to this directory
2. Uncomment the font section in `pubspec.yaml`
3. Uncomment all `fontFamily: 'Poppins'` lines in `lib/utils/theme.dart`

## Current Status:
✅ **App works perfectly without fonts** - uses system default
🔧 **Fonts are optional** - for enhanced visual experience only

The app will automatically fall back to the system default font if Poppins is not available.
