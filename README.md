# 📱 SentimentAnalyzer

> A SwiftUI iOS app that performs real-time, on-device sentiment analysis using Apple's built-in **NaturalLanguage** framework — no internet, no third-party dependencies.
>
![iOS](https://img.shields.io/badge/iOS-17.0%2B-blue?logo=apple)
![Swift](https://img.shields.io/badge/Swift-5.0-orange?logo=swift)
![Xcode](https://img.shields.io/badge/Xcode-15.0%2B-blue?logo=xcode)
![License](https://img.shields.io/badge/License-MIT-green)
![NaturalLanguage](https://img.shields.io/badge/Apple-NaturalLanguage-black?logo=apple)

---

## ✨ Features

| Feature | Description |
|---|---|
| 📊 **Overall Score** | Animated score bar from `-1.0` (negative) to `+1.0` (positive) |
| 🔍 **Sentence Breakdown** | Per-sentence scores with emoji indicators and color coding |
| 🕐 **Analysis History** | Stores last 10 analyses with timestamps |
| ⚡ **Async Processing** | Background thread analysis — zero UI lag |
| 🔒 **On-Device & Private** | No network calls, no third-party SDKs |
| 🏗️ **MVVM Architecture** | Clean, testable code with `ObservableObject` |

---
## 📸 Screens

| Analyzer Tab | Results | History Tab |
|---|---|---|
| Text input + Analyze button | Score bar + sentence breakdown | Last 10 analyses with timestamps |

---
## 🗂️ Project Structure

```
SentimentAnalyzer/
├── SentimentAnalyzer.xcodeproj/
│   └── project.pbxproj
└── SentimentAnalyzer/
    ├── SentimentAnalyzerApp.swift   # @main entry point
    ├── BaseView.swift               # TabView container
    ├── ViewModel
          └──  SentimentViewModel.swift     # Business logic, models, history
    └── Views
        └── AnalyzerView.swift       # Main analysis UI + score bar
        └── HistoryView.swift        # Past analyses list
```

---

## 🔧 Requirements

| | Minimum |
|---|---|
| iOS | 17.0+ |
| Xcode | 15.0+ |
| Swift | 5.0+ |
| macOS (dev) | 13.0+ Ventura |

---

## 🚀 Getting Started

### Run in Simulator

```bash
# 1. Clone or download the repo
git clone https://github.com/yourusername/SentimentAnalyzer.git

# 2. Open in Xcode
open SentimentAnalyzer/SentimentAnalyzer.xcodeproj

# 3. Select a simulator (e.g. iPhone 15) and press Cmd + R
```

### Run on a Physical Device

1. Open **Signing & Capabilities** in Xcode
2. Change the Bundle ID to `com.yourname.SentimentAnalyzer`
3. Select your **Apple Developer Team**
4. Connect your iPhone and press **Cmd + R**

---
