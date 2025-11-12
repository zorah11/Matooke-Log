# Matooke Log 🌱

**Matooke Log** is an offline farming record application built specifically for Ugandan farmers to track their planting, harvesting, and sales activities. The app helps farmers maintain organized records of their crops, quantities, and transactions without requiring an internet connection.

## Features ✨

- **📊 Dashboard**: View comprehensive statistics and charts showing your farming activities at a glance
  - Total quantities for planting, harvest, and sales
  - Interactive pie charts showing crop distribution
  - Bar charts for visual comparison
  - Crop-level breakdowns

- **🌾 Record Management**: Track three types of farming activities:
  - **Planting Records**: Log what you planted and when
  - **Harvest Records**: Record your harvest quantities
  - **Sales Records**: Track your sales and revenue

- **🔍 Search & Filter**: Quickly find specific records by crop name

- **📁 CSV Export**: Export your records to CSV format for backup or external analysis

- **💾 Offline-First**: All data is stored locally on your device - no internet required

- **🎨 Modern UI**: Beautiful, user-friendly interface with:
  - Bottom navigation for easy access to all sections
  - Material Design 3 components
  - Custom color scheme inspired by agriculture
  - Smooth animations and transitions

## Screenshots 📱

*Dashboard with statistics and charts*
*Record management screens*
*Add/Edit record forms*

## Getting Started 🚀

### Prerequisites

- Flutter SDK (^3.9.2 or higher)
- Dart SDK
- Android Studio / VS Code with Flutter extensions (for development)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/matookelog.git
cd matookelog
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:

For mobile/desktop:
```bash
flutter run
```

For web:
```bash
flutter run -d chrome
```

### Building for Production

**Android:**
```bash
flutter build apk --release
```

**iOS:**
```bash
flutter build ios --release
```

**Web:**
```bash
flutter build web --release
```

**Linux:**
```bash
flutter build linux --release
```

## Project Structure 📁

```
lib/
├── main.dart                          # App entry point and main UI
├── models/
│   └── record.dart                    # Data model for farming records
└── db/
    ├── database_helper.dart           # Database interface (conditional export)
    ├── database_helper_io.dart        # SQLite implementation (mobile/desktop)
    └── database_helper_web.dart       # SharedPreferences implementation (web)
```

## Technologies Used 🛠️

- **Flutter**: Cross-platform UI framework
- **SQLite** (via sqflite): Local database for mobile and desktop platforms
- **SharedPreferences**: Web storage solution
- **fl_chart**: Beautiful charts and data visualization
- **Google Fonts**: Custom typography with Poppins font family
- **intl**: Date formatting and internationalization

## Dependencies 📦

```yaml
dependencies:
  flutter:
    sdk: flutter
  sqflite: ^2.2.8
  path: ^1.8.4
  fl_chart: ^1.1.1
  google_fonts: ^4.0.4
  intl: ^0.18.1
  shared_preferences: ^2.2.1
```

## Platform Support 🖥️

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Linux
- ✅ macOS
- ✅ Windows

## How It Works 💡

### Data Storage

The app uses a platform-conditional database approach:

- **Mobile & Desktop**: Uses SQLite via the `sqflite` package for robust relational database storage
- **Web**: Uses `SharedPreferences` with JSON serialization for browser-compatible storage

### Record Types

Each record contains:
- **Crop Name**: The type of crop (e.g., Matooke, Beans, Coffee)
- **Date**: When the activity occurred
- **Quantity**: Amount planted/harvested/sold (in kg or units)
- **Notes**: Optional additional information

### Features Breakdown

1. **Dashboard Screen**: Aggregates all data and presents visual summaries
2. **Record Screens**: Separate tabs for Planting, Harvest, and Sales with swipe-to-delete functionality
3. **Add/Edit Forms**: Simple forms with date pickers and numeric input validation
4. **Search**: Real-time filtering as you type
5. **Export**: One-tap CSV export with proper formatting

## Contributing 🤝

Contributions are welcome! If you'd like to improve Matooke Log:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## Future Enhancements 🔮

- [ ] Multi-language support (Luganda, Swahili)
- [ ] Cloud backup and sync
- [ ] Weather integration
- [ ] Expense tracking
- [ ] Market price information
- [ ] Farming tips and best practices
- [ ] Photo attachments for records
- [ ] PDF report generation

## License 📄

This project is open source and available under the [MIT License](LICENSE).

## Author ✍️

Built with ❤️ for Ugandan farmers

## Acknowledgments 🙏

- Inspired by the need to support smallholder farmers in Uganda
- Thanks to the Flutter community for excellent packages and resources
- Special thanks to all farmers working hard to feed their communities

---

**Note**: This app is designed to work completely offline. Your data stays on your device and is never sent to external servers.

