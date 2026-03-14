# GitHub Setup & Submission Guide

## 📋 Step-by-Step GitHub Upload

### 1. **Initialize Git (if not already done)**
```bash
cd d:\flutter-projects\instagram_home
git init
git add .
git commit -m "Initial commit: Instagram home clone with Riverpod state management"
```

### 2. **Create a New Repository on GitHub**
- Go to https://github.com/new
- **Repository Name:** `instagram_home` or `instagram-home-flutter`
- **Description:** "A polished Flutter Instagram home feed clone with Riverpod state management, shimmer loading, infinite scrolling, and pinch-to-zoom."
- **Public:** Make it public for submission
- **Initialize without README** (we already have one)
- Click **Create Repository**

### 3. **Add Remote & Push**
```bash
# Add GitHub remote (replace USERNAME)
git remote add origin https://github.com/YOUR_USERNAME/instagram_home.git

# Rename branch to main (if it's master)
git branch -M main

# Push to GitHub
git push -u origin main
```

### 4. **Verify on GitHub**
- Go to your repo URL: `https://github.com/YOUR_USERNAME/instagram_home`
- Check that all files are present
- Verify the README displays correctly

---

## 🎬 Preparing for Demo (Screen Recording)

### What to Show (in order):

#### 1. **App Launch & Shimmer Loading (10 seconds)**
- Show the splash screen
- Feed loads with shimmer skeleton loaders
- Smooth transition as posts appear
- *Highlight the beautiful loading state*

#### 2. **Infinite Scrolling (15 seconds)**
- Scroll down the feed smoothly
- Show automatic pagination loading
- Multiple posts loading as you scroll
- *Smooth, no jank*

#### 3. **Pinch-to-Zoom (10 seconds)**
- Tap on a post image
- Perform pinch-to-zoom gesture
- Show smooth zoom in/out
- Double-tap to reset
- *Show the gesture is responsive*

#### 4. **Like Button Toggle (5 seconds)**
- Tap the heart icon
- Show animated scale-up effect
- Heart changes color and animates
- Tap again to unlike
- *Emphasize the smooth animation*

#### 5. **Save Button Toggle (5 seconds)**
- Tap the bookmark/save icon
- Show visual feedback (bookmark highlights)
- Tap again to unsave
- *Show instant feedback*

#### 6. **Pull-to-Refresh (5 seconds)**
- Scroll to top
- Pull down to refresh
- Show shimmer loaders during refresh
- New posts load

#### 7. **Theme Toggle (5 seconds) [Optional]**
- Toggle dark/light mode
- Show theme changes throughout app
- *Polished UI consistency*

---

## 📹 Recording Best Practices

### Tools:
- **Windows:** OBS Studio (free), ScreenFlow, or built-in Xbox Game Bar
- **Quick Option:** `adb shell screenrecord /sdcard/screenrecordvideo.mp4` (then pull via ADB)

### Settings:
- **Resolution:** 1080p (standard mobile)
- **Frame Rate:** 60 FPS
- **Bitrate:** High (better quality)
- **Video Format:** H.264 MP4 (as per requirements)
- **Duration:** Keep it under 1 minute total (show quality, not quantity)

### Recording Tips:
- Use a clean emulator (no extra apps visible)
- Make smooth, slow gestures
- Pause for 1-2 seconds between interactions so viewers can see changes
- Keep system UI clean (hide notifications if possible)

### After Recording:
- Save as `.mp4` (H.264 codec)
- Test playback
- Optional: Upload to Loom for easy sharing (https://loom.com)
  - Free account, upload video privately, share link in submission

---

## ✅ Final Submission Checklist

- [ ] **README.md** - Complete with state management explanation ✓
- [ ] **GitHub Repo** - Public, updated README visible
- [ ] **Display Features:**
  - [ ] Shimmer loading visible
  - [ ] Infinite scroll working smoothly
  - [ ] Pinch-to-zoom responsive and smooth
  - [ ] Like button animates when tapped
  - [ ] Save button visual feedback
  - [ ] No crashes or errors
- [ ] **Video Recording** - H.264 MP4 format, under 1 minute
- [ ] **Code Quality** - Clean, well-commented, formatted
- [ ] **Tested** - Run on emulator, verify all features work

---

## 🔗 Sample Submission Format

For your submission, provide:

```
GitHub Repository: https://github.com/YOUR_USERNAME/instagram_home

Demo Video: [Loom Link] or [MP4 file]

Features Demonstrated:
✅ Shimmer Loading State - Skeleton loaders with smooth animation
✅ Infinite Scrolling - Pagination-based pagination at scroll bottom
✅ Pinch-to-Zoom - Full gesture control with smooth transformation
✅ Toggle Interactions - Animated like/save buttons with instant feedback

State Management: Riverpod
Key Highlights: 
- Type-safe providers with compile-time safety
- Efficient pagination logic preventing duplicate requests
- Responsive design with light/dark theme support
- Smooth animations using Flutter's animation framework
```

---

## 🚀 Extra Polish (If Time Permits)

1. Add `.github/workflows/` for CI/CD badge
2. Create a `CONTRIBUTING.md` file
3. Add `LICENSE` file (MIT recommended)
4. Add code comments in complex widgets
5. Consider adding a `CHANGELOG.md`

---

## 📞 Support

If you face any issues:
1. Run `flutter doctor` to verify setup
2. Check `flutter run -v` for detailed logs
3. Try `flutter clean && flutter pub get && flutter run`
