//
//  AnalyzerView.swift
//  SentimentAnalyzer
//
//  Created by Manish Parihar on 16.03.26.
//

import SwiftUI
import Combine

struct AnalyzerView: View {

    @ObservedObject var viewModel: SentimentViewModel

    var sentimentColor: Color {
        switch viewModel.overallScore {
        case 0.2...: return .green
        case ..<(-0.2): return .red
        default: return .orange
        }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing:20) {
                    // MARK: Input Card
                    VStack(alignment: .leading, spacing: 10) {
                        Label("Enter Text", systemImage: "pencil.and.outline")
                            .font(.headline)
                            .foregroundStyle(.secondary)

                        ZStack(alignment: .topLeading) {
                            if viewModel.inputText.isEmpty {
                                Text("Type or paste your text here...")
                                    .foregroundStyle(.gray.opacity(0.6))
                                    .padding(.top, 10)
                                    .padding(.leading, 5)
                            }
                            TextEditor(text: $viewModel.inputText)
                                .frame(minHeight: 140)
                                .opacity(viewModel.inputText.isEmpty ? 0.9 : 1)
                        }
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)

                        HStack {
                            Text("\(viewModel.inputText.count) characters")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Spacer()
                            if !viewModel.inputText.isEmpty {
                                Button(action: viewModel.reset) {
                                    Label("Clear", systemImage: "xmark.circle.fill")
                                        .font(.caption)
                                        .foregroundStyle(.red.opacity(0.8))
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .presentationCornerRadius(16)
                    .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
                    .padding(.horizontal)

                    // MARK: Analyze Button
                    Button(action: viewModel.analyze) {
                        HStack {
                            if viewModel.isAnalyzing {
                                ProgressView()
                                    .progressViewStyle(
                                        CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(0.8)
                            } else {
                                Image(systemName: "waveform.path.ecg")
                            }
                            Text(viewModel.isAnalyzing ? "Analyzing..." : "Analyze Sentiment")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            viewModel.inputText
                                .trimmingCharacters(
                                    in: .whitespaces
                                ).isEmpty ? Color.gray : Color.blue
                        )
                        .foregroundStyle(.white)
                        .presentationCornerRadius(14)
                        .padding(.horizontal)
                    }
                    .disabled(
                        viewModel.inputText
                            .trimmingCharacters(
                                in: .whitespaces
                            ).isEmpty || viewModel.isAnalyzing)

                    // MARK: Results
                    if viewModel.hasAnalyzed {
                        // Overall Score Card
                        OverallScoreCard(
                            score: viewModel.overallScore,
                            label: viewModel.overallLabel,
                            color: sentimentColor
                        )
                        .padding(.horizontal)

                        // Sentence Breakdown
                        if viewModel.sentenceResults.count > 1 {
                            SentenceBreakdownView(
                                results: viewModel.sentenceResults
                            )
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.top)
                .padding(.bottom, 30)
            }
            .navigationTitle("Sentiment Analyzer")
            .background(Color(.systemGroupedBackground))
        }
    }
}

// MARK: Overall Score Card
struct OverallScoreCard: View {
    let score: Double
    let label: String
    let color: Color

    var gaugeValue: Double {(score + 1.0) / 2.0 }

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Label("Overall Sentiment", systemImage: "chart.bar.fill")
                    .font(.headline)
                Spacer()
            }
            Text(label)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(color)

            // Score Bar
            VStack(spacing: 6) {
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(.systemGray5))
                            .frame(height: 18)

                        RoundedRectangle(cornerRadius: 8)
                            .fill(
                                LinearGradient(
                                    colors: [color.opacity(0.7), color],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geo.size.width * CGFloat(gaugeValue), height: 18)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: score)
                    }
                }
                .frame(height: 18)

                HStack {
                    Text("Negative")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("Score: \(score, specifier: "%.3f")")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(color)
                    Spacer()
                    Text("Positive")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(color.opacity(0.08))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(color.opacity(0.25), lineWidth: 1)
        )
    }
}

// MARK: - Sentence Breakdown

struct SentenceBreakdownView: View {
    let results: [SentenceResult]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Sentence Breakdown", systemImage: "list.number")
                .font(.headline)
                .padding(.bottom, 2)

            ForEach(results) { result in
                SentenceRow(result: result)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
    }
}

struct SentenceRow: View {
    let result: SentenceResult

    var color: Color {
        switch result.score {
        case 0.2...: return .green
        case ..<(-0.2): return .red
        default: return .orange
        }
    }

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text(result.emoji)
                .font(.title3)

            VStack(alignment: .leading, spacing: 4) {
                Text(result.sentence)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)

                HStack {
                    Text(result.label)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(color)

                    Text("(\(result.score, specifier: "%.3f"))")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            Spacer()
        }
        .padding(10)
        .background(color.opacity(0.06))
        .cornerRadius(10)
    }
}
