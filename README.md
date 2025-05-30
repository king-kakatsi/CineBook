# CINEBOOK

CineBook is your personal digital companion for the world of entertainment, crafted with passion for series and anime enthusiasts. Born from the desire to create the perfect media tracking experience, this elegant Flutter application transforms the way you organize and interact with your watched content. Whether you're a casual viewer or a dedicated binge-watcher, CineBook helps you maintain a beautiful, organized library of your media adventures, complete with ratings, notes, and smart search capabilities - all wrapped in a modern, intuitive interface.

## Features

- Media tracking (series and anime)
- Search and sort functionality
- Rating system
- Local image caching
- Backup and restore functionality
- Beautiful Material Design UI
- Text-to-Speech and Speech-to-Text capabilities

## Technologies Used

- Flutter SDK (^3.7.2)
- Dart
- Hive (local database)
- Provider (state management)
- GetIt (dependency injection)
- Various Flutter packages for UI and functionality

### Key Dependencies

- hive: ^2.2.3 (local database)
- provider: ^6.1.4 (state management)
- get_it: ^8.0.3 (dependency injection)
- flutter_tts: ^4.2.2 (text to speech)
- speech_to_text: ^7.0.0 (speech recognition)
- lottie: ^3.3.1 (animations)

## Installation 🚀

Hey there! Let's get you started with CineBook. Follow these simple steps and you'll be up and running in no time! 

### Step 1: Set Up Your Development Environment 💻

First things first, let's make sure you have everything you need:

1. Install Flutter on your machine:
   - Visit the [official Flutter installation guide](https://flutter.dev/docs/get-started/install)
   - Choose your operating system and follow the instructions
   - Run `flutter doctor` in your terminal to verify everything is set up correctly

2. Install a code editor (we recommend VS Code):
   - Download [Visual Studio Code](https://code.visualstudio.com/)
   - Install the Flutter and Dart extensions in VS Code

### Step 2: Get the Project Code 📦

Now that your environment is ready, let's grab the project code:

```bash
# Clone the repository to your local machine
git clone <repository-url>

# Navigate to the project directory
cd CineBook

# Make sure you're on the main branch
git checkout main
```

### Step 3: Project Setup ⚙️

Time to set up the project dependencies and generate necessary files:

```bash
# Get all the dependencies
flutter pub get

# Generate the Hive database adapters
# This step is crucial for the app to work properly!
flutter pub run build_runner build --delete-conflicting-outputs
```

### Step 4: Configuration 🔧

Before running the app, make sure to:

1. Check that your device/emulator is connected:
   ```bash
   flutter devices
   ```

2. Verify all dependencies are properly resolved:
   ```bash
   flutter doctor -v
   ```

### Step 5: You're Ready! 🎉

Now you can run the app in development mode:
```bash
# Start the app in debug mode
flutter run

# Or specify a device if you have multiple
flutter run -d <device-id>
```

### Troubleshooting Tips 🔍

If you encounter any issues:

- Run `flutter clean` and then `flutter pub get` to refresh your dependencies
- Make sure all environment variables are properly set
- Check that your Flutter version matches the project requirements
- For database issues, try deleting the generated files in `.dart_tool` and regenerating them

Need help? Feel free to reach out through the contact information below! 

## Running the Project

### Development
```bash
flutter run
```

### Production Build
```bash
# For Android
flutter build apk --release

# For iOS
flutter build ios --release

# For Web
flutter build web --release
```

## Project Structure
```
first_project/
├── lib/
│   ├── controllers/     # Business logic
│   ├── models/          # Data models
│   ├── pages/           # UI screens
│   ├── services/        # External services
│   ├── widgets/         # Reusable UI components
│   ├── themes/          # App theming
│   └── main.dart        # Entry point
├── assets/
│   ├── fonts/          # Custom fonts
│   ├── icon/           # App icons
│   └── lottie/         # Animation files
└── pubspec.yaml        # Project configuration
```

## Future Enhancements 🚀

Here's what's on our roadmap to make CineBook even better:

### High Priority Enhancements 🎯

1. **Smart Content Loading**
   - Implement infinite scroll with efficient pagination
   - Optimize media list performance for large libraries
   - Add lazy loading for images and heavy content

2. **Cloud Integration**
   - Integrate Firebase Authentication for secure user accounts
   - Implement real-time database synchronization
   - Enable cross-device library syncing

3. **Voice Command Improvements**
   - Enhance speech recognition accuracy and response time
   - Add custom voice commands for quick actions
   - Implement multilingual voice support

### Proposed Features 💡

4. **Social Features**
   - Share watchlists with friends
   - Create watch parties and group discussions
   - Add social media integration for sharing reviews

5. **Advanced Analytics**
   - Personal watching statistics and insights
   - Viewing habit analysis and recommendations
   - Weekly/monthly activity reports

6. **Content Enhancement**
   - Automatic metadata fetching from TMDB/IMDB
   - Episode tracking with air date notifications
   - Integration with streaming service APIs

7. **User Experience**
   - Customizable themes and layouts
   - Gesture-based navigation
   - Widget support for quick access

8. **Offline Capabilities**
   - Enhanced offline mode with full functionality
   - Smart content caching
   - Background sync when online

Want to contribute or suggest more features? Feel free to reach out! 

## Contact Information

- **WhatsApp**: +233535610908
- **Website**: [kingweb.pythonanywhere.com](https://kingweb.pythonanywhere.com)
- **Email**: king.officialdev.pro@gmail.com

## License

This project is proprietary software. All rights reserved.

---
Made with ❤️ using Flutter
