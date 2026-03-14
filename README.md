# Instagram Home Clone 📸

A **polished, feature-rich Flutter implementation** of Instagram's home feed with smooth animations, advanced gestures, and modern state management.

## ✨ Features Implemented

### 1. **Shimmer Loading State**
- Beautiful skeleton loaders while fetching posts
- Smooth shimmer animation during data load
- Theme-aware (light/dark mode support)

### 2. **Smooth Infinite Scrolling**
- Pagination-based feed loading
- Automatic fetch when user scrolls near bottom
- Prevents duplicate requests with loading state checks
- Smooth refresh functionality with pull-to-refresh

### 3. **Pinch-to-Zoom Interaction**
- Full gesture support for zooming images
- Smooth animation with transformation controller
- Double-tap to reset zoom with animation
- Advanced overlay rendering for smooth performance

### 4. **Toggle Interactions**
- **Like Button** - Animated heart with scale animation
- **Save Button** - Persistent toggle state
- **Comment & Share** - UI-ready buttons
- State persisted with smooth visual feedback

---

## 🏗️ Architecture

### State Management: **Riverpod**
**Why Riverpod?**
- ✅ Compile-time safety (no runtime errors from string keys)
- ✅ Dependency Injection built-in
- ✅ Fine-grained reactivity
- ✅ Excellent for pagination and complex state
- ✅ Hot reload friendly

**Key Providers:**
- `feedProvider` - Manages feed state, pagination, and posts
- `postRepositoryProvider` - Singleton post data repository
- `themeProvider` - Light/dark mode theme management

### Project Structure
```
lib/
├── main.dart                 # App entry with ProviderScope
├── core/
│   ├── theme/               # Theme & theme provider
│   └── constants/           # App constants
├── features/
│   ├── auth/                # Authentication screens
│   ├── feed/                # Main feed implementation
│   │   ├── screens/         # FeedScreen with bottom nav
│   │   ├── widgets/         # PostCard, Shimmer, PinchZoom
│   │   ├── models/          # Post model
│   │   ├── providers/       # FeedNotifier & FeedState
│   │   └── repository/      # PostRepository (mock data)
│   ├── chat/                # Direct messages
│   ├── search/              # Search implementation
│   └── settings/            # Profile & settings
└── assets/
    └── images/              # App images & launcher icon
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.10.7+
- Dart 3.10.7+
- Android Emulator / iOS Simulator

### Installation & Running

```bash
# 1. Clone the repository
git clone https://github.com/yourusername/instagram_home.git
cd instagram_home

# 2. Install dependencies
flutter pub get

# 3. Generate launcher icons (optional, already configured)
dart run flutter_launcher_icons

# 4. Run the app
flutter run

# For debugging
flutter run -v

# For specific device
flutter run -d emulator-5554
```

### ⚡ Quick Start - Download Pre-built APK

Don't want to build from source? Download the latest pre-built release:

1. **Go to [Releases](https://github.com/rohitraj1711/Instagram_home/releases)**
2. **Download** `app-release.apk` from the latest release
3. **Transfer to your Android phone** (USB or cloud storage)
4. **Install** - Tap the APK file and grant permissions
5. **Enable "Install from Unknown Sources"** if prompted on your device

**Requirements:**
- Android 6.0 (API 21) or higher
- Approximately 50MB free storage
- Internet connection for loading feed images

---

### Available Commands
```bash
# Clean build cache
flutter clean

# Format code
dart format lib/

# Run tests
flutter test

# Build release APK (Android)
flutter build apk --release

# Build iOS app
flutter build ios --release
```

---

## 📦 Dependencies

| Package | Purpose |
|---------|---------|
| `flutter_riverpod: ^3.3.1` | State management |
| `cached_network_image: ^3.4.1` | Image caching & loading |
| `shimmer: ^3.0.0` | Skeleton loaders |
| `photo_view: ^0.15.0` | Image zoom viewer |
| `google_fonts: ^8.0.2` | Custom typography |
| `smooth_page_indicator: ^2.0.1` | Page dots indicator |
| `shared_preferences: ^2.5.4` | Local storage |
| `uuid: ^4.5.3` | Unique ID generation |

---

## 🎨 Design Highlights

### Responsive Layout
- Adapts to all device sizes
- Portrait and landscape support
- Safe area considerations

### Theme Support
- Light & Dark mode fully implemented
- Dynamically switches based on system settings
- Consistent color scheme across all screens

### Performance Optimizations
- Image caching with `cached_network_image`
- Efficient list rendering with `IndexedStack`
- Lazy loading with pagination
- Proper disposal of resources

---

## 🎬 Demo Features Shown
1. **Initial shimmer loading** - Skeleton loaders while fetching posts
2. **Infinite scrolling** - Smooth pagination as user scrolls
3. **Pinch-to-zoom** - Gesture interaction on post images
4. **Like toggle** - Animated heart button with visual feedback
5. **Save toggle** - Instagram-style save button interaction
6. **Pull-to-refresh** - Refresh entire feed

---

## 🔄 State Flow Example

```
User scrolls down
    ↓
_scrollController listener triggered
    ↓
Check if already loading (prevents duplicates)
    ↓
Call feedProvider.notifier.fetchPosts()
    ↓
FeedNotifier makes async call to PostRepository
    ↓
Posts loaded → UI rebuilds with new posts
    ↓
Shimmer hides, new posts displayed smoothly
```

---

## 🛠️ Development

### Hot Reload
```bash
'r' in terminal to hot reload
'R' to hot restart
```

### Debugging
Enable breakpoints in VS Code or Android Studio and:
```bash
flutter run --debug
```

### Common Issues

**Launcher icon not showing?**
```bash
flutter clean
dart run flutter_launcher_icons
flutter run
```

**Build fails?**
```bash
flutter clean
flutter pub get
flutter run -v
```

---

## 📝 License

This project is open source and available under the [MIT License](LICENSE).

---

## 👨‍💻 Author

Created as a **Flutter state management and UI interaction showcase**.

For questions or suggestions, feel free to open an issue!

---

**⭐ If you found this helpful, please star the repository!**
