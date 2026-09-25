# The_Zodiac
A simlpe app that lets you know which star sign you are based on your birthday and also lets you brose the date ranges for all 12 signs.

## Feaures

- **Find your sign**: pick your birthday with the built-in date picker and instantly see your zodiac sign, symbol, date range, and element.
- **Browse all signs**: scroll through all 12 zodiac signs, each shown with its symbol, date range, and element (Fire, Earth, Air, or Water), styled with its own gradient color.
- Dark, star-themed visual design with smooth animated transitions.

## How it works

### Required

- [Flutter SDK](https://docs.flutter.dev/get-started/install) installed and set up (`flutter doctor` should report no issues).
- A code editor such as VS Code with the Flutter and Dart extensions.

### Setting up
 
1. Create a new Flutter project:
```
   flutter create The_Zodiac
   cd star_signs
```
 
2. Copy the contents of `main.dart` into `lib/main.dart`.
3. Copy the contents of `widget_test.dart` into `test/widget_test.dart`.
4. In `test/widget_test.dart`, update the import line to match your project's actual name from `pubspec.yaml`:
```dart
   import 'package:your_app_name/main.dart';
```
   For example, if your `pubspec.yaml` has `name: The_Zodiac`, this should be:
```dart
   import 'package:star_signs/main.dart';
```

### Run the app
 
```
flutter run
```
 
### Run the tests
 
```
flutter test
```
 
## How the date logic works
 
The `signForDate(month, day)` function checks a birthday against the standard Western (tropical) zodiac date ranges:
 
| Sign | Dates |
|---|---|
| Aries | Mar 21 – Apr 19 |
| Taurus | Apr 20 – May 20 |
| Gemini | May 21 – Jun 20 |
| Cancer | Jun 21 – Jul 22 |
| Leo | Jul 23 – Aug 22 |
| Virgo | Aug 23 – Sep 22 |
| Libra | Sep 23 – Oct 22 |
| Scorpio | Oct 23 – Nov 21 |
| Sagittarius | Nov 22 – Dec 21 |
| Capricorn | Dec 22 – Jan 19 |
| Aquarius | Jan 20 – Feb 18 |
| Pisces | Feb 19 – Mar 20 |
 
## Project structure
 
```
lib/
  main.dart          # App entry point, UI, and zodiac date logic
test/
  widget_test.dart   # Widget and unit tests
```
 
## Possible next steps
 
- Add daily horoscope text per sign (would need a data source or API).
- Persist the picked birthday with `shared_preferences` so it's remembered between launches.
- Add compatibility matching between two signs.

## Verification code:
WTC-B7866NAF
