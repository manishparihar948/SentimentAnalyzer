//
//  SentimentViewModel.swift
//  SentimentAnalyzer
//
//  Created by Manish Parihar on 16.03.26.
//

import Foundation
import Combine
import NaturalLanguage


struct SentenceResult: Identifiable {
    let id = UUID()
    let sentence : String
    let score : Double

    var label: String {
        switch score {
        case 0.2...: return "Positive"
        case ..<(-0.2): return "Negative"
        default : return "Neutral"
        }
    }

    var emoji: String {
        switch score {
        case 0.2...: return "😊"
        case ..<(-0.2): return "😞"
        default: return "😐"
        }
    }
}

@MainActor
class SentimentViewModel: ObservableObject {
    @Published var inputText: String = ""
    @Published var overallScore: Double = 0.0
    @Published var sentenceResults: [SentenceResult] = []
    @Published var hasAnalyzed: Bool = false
    @Published var isAnalyzing: Bool = false
    @Published var  analysisHistory: [HistoryEntry] = []

    var overallLabel: String {
        switch overallScore {
        case 0.2...: return "Positive 😊"
        case ..<(-0.2): return "Negative 😞"
        default: return "Neutral 😐"
        }
    }

    func analyze() {
        guard !inputText
            .trimmingCharacters(in: .whitespaces).isEmpty else {return}
        isAnalyzing = true

        DispatchQueue.global(qos: .userInitiated).async {
            let overall = self.computeOverallSentiment(self.inputText)
            let sentences = self.computeSentenceSentiments(self.inputText)

            DispatchQueue.main.async {
                self.overallScore = overall
                self.sentenceResults = sentences
                self.hasAnalyzed = true
                self.isAnalyzing = false

                let entry = HistoryEntry(
                    text: self.inputText,
                    score: overall,
                    date: Date()
                )
                self.analysisHistory.insert(entry, at: 0)
                if self.analysisHistory.count > 10 {
                    self.analysisHistory = Array(self.analysisHistory.prefix(10))
                }
            }
        }
    }

    func reset() {
        inputText = ""
        overallScore = 0.0
        sentenceResults = []
        hasAnalyzed = false
    }

    private func computeOverallSentiment(_ text: String) -> Double {
        let tagger = NLTagger(tagSchemes: [.sentimentScore])
        tagger.string = text
        let (tag, _) = tagger.tag(
            at: text.startIndex,
            unit: .paragraph,
            scheme: .sentimentScore
        )
        return Double(tag?.rawValue ?? "0") ?? 0.0
    }

    private func computeSentenceSentiments(_ text: String) -> [SentenceResult] {
        let tagger = NLTagger(tagSchemes: [.sentimentScore])
        tagger.string = text
        var results: [SentenceResult] = []

        tagger.enumerateTags(
            in: text.startIndex..<text.endIndex,
            unit: .sentence,
            scheme: .sentimentScore
        ) { tag, range in
            let sentence = String(text[range]).trimmingCharacters(in: .whitespacesAndNewlines)
            guard !sentence.isEmpty else { return true }
            let score = Double(tag?.rawValue ?? "0") ?? 0.0
            results.append(SentenceResult(sentence: sentence, score: score))
            return true
        }
        return results
    }
}

struct HistoryEntry: Identifiable {
    let id = UUID()
    let text: String
    let score: Double
    let date: Date

    var shortText: String {
        text.count > 60 ? String(text.prefix(60)) + "..." : text
    }

    var label: String {
        switch score {
        case 0.2...: return "Positive 😊"
        case ..<(-0.2): return "Negative 😞"
        default: return "Neutral 😐"
        }
    }
}
