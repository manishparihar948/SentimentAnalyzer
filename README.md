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
## 🧠 How It Works

The app uses `NLTagger` with the `.sentimentScore` scheme from Apple's `NaturalLanguage` framework:

```swift
import NaturalLanguage

let tagger = NLTagger(tagSchemes: [.sentimentScore])
tagger.string = inputText

let (tag, _) = tagger.tag(
    at: inputText.startIndex,
    unit: .paragraph,
    scheme: .sentimentScore
)

let score = Double(tag?.rawValue ?? "0") ?? 0.0
// Returns -1.0 (very negative) → 0.0 (neutral) → +1.0 (very positive)
```

### Score Interpretation

| Score Range | Sentiment |
|---|---|
| `0.2` → `1.0` | 😊 Positive |
| `-0.2` → `0.2` | 😐 Neutral |
| `-1.0` → `-0.2` | 😞 Negative |

### Sentence-Level Analysis

```swift
tagger.enumerateTags(
    in: text.startIndex..<text.endIndex,
    unit: .sentence,
    scheme: .sentimentScore
) { tag, range in
    let sentence = String(text[range])
    let score = Double(tag?.rawValue ?? "0") ?? 0.0
    // handle each sentence result
    return true
}
```

---

## 🏗️ Architecture

The project follows **MVVM** pattern:

```
┌─────────────────────────────────────┐
│          BaseView (TabView)      │
│   ┌─────────────┐  ┌─────────────┐  │
│   │AnalyzerView │  │HistoryView  │  │
│   └──────┬──────┘  └──────┬──────┘  │
│          └────────┬────────┘         │
│         SentimentViewModel           │
│         (ObservableObject)           │
│              │                       │
│         NLTagger                     │
│    (NaturalLanguage framework)       │
└─────────────────────────────────────┘
```
| Layer | File | Responsibility |
|---|---|---|
| **View** | `AnalyzerView.swift` | Text input, score bar, sentence list |
| **View** | `HistoryView.swift` | History list with score badges |
| **ViewModel** | `SentimentViewModel.swift` | State, NLTagger calls, history |
| **Model** | `SentimentViewModel.swift` | `SentenceResult`, `HistoryEntry` structs |


---

## ⚙️ Customization

### Change Sentiment Thresholds

In `SentimentViewModel.swift` and `AnalyzerView.swift`:

```swift
var overallLabel: String {
    switch overallScore {
    case 0.3...:    return "Positive 😊"  // default: 0.2
    case ..<(-0.3): return "Negative 😞"  // default: -0.2
    default:        return "Neutral 😐"
    }
}
```

### Increase History Limit

In `SentimentViewModel.swift`:

```swift
if self.analysisHistory.count > 20 {   // default: 10
    self.analysisHistory = Array(self.analysisHistory.prefix(20))
}
```

### Persist History Across Launches

History currently lives in memory. To persist it, encode `analysisHistory` to `UserDefaults` or `SwiftData` in the `analyze()` method of `SentimentViewModel`.

---

## ⚠️ Known Limitations

- **English-optimized** — `NLTagger` works best with English; other languages may be less accurate
- **In-memory history** — history is cleared when the app is terminated
- **Short inputs** — single words or very short phrases may return `0.0`
- **Sarcasm** — context-dependent or sarcastic language may be misclassified

---

## 🔮 Possible Extensions

- [ ] Persist history using `SwiftData` or `CoreData`
- [ ] Add language detection before analysis
- [ ] Export history as CSV
- [ ] Widget extension showing last sentiment score
- [ ] Custom ML model via `Create ML` for domain-specific analysis
- [ ] macOS support via `Catalyst`

---
## 📄 License

```
MIT License

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software.
```

---

## 🙏 Credits

| Technology | Details |
|---|---|
| [NaturalLanguage](https://developer.apple.com/documentation/naturallanguage) | Apple's on-device NLP framework |
| [SwiftUI](https://developer.apple.com/xcode/swiftui/) | Apple's declarative UI framework |

---

<p align="center">
  Made with ❤️ using SwiftUI &amp; Apple NaturalLanguage
</p>
