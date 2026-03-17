//
//  HistoryView.swift
//  SentimentAnalyzer
//
//  Created by Manish Parihar on 16.03.26.
//

import SwiftUI

struct HistoryView: View {
    @ObservedObject var viewModel : SentimentViewModel

    var body: some View {
        NavigationView {
            Group {
                if viewModel.analysisHistory.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "clock.arrow.circlepath")
                            .font(.system(size: 60))
                            .foregroundStyle(.secondary.opacity(0.4))
                        Text("No History Yet")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundStyle(.secondary)
                        Text("Your analysis results will appear here.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary.opacity(0.7))
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                } else {
                    List {
                        ForEach(viewModel.analysisHistory) { entry in
                            HistoryRowView(entry: entry)
                                .listRowBackground(Color(.systemBackground))
                                .listRowSeparator(.hidden)
                                .listRowInsets(
                                    EdgeInsets(
                                        top: 6,
                                        leading: 16,
                                        bottom: 6,
                                        trailing: 16
                                    )
                                )
                        }
                    }
                    .listStyle(.plain)
                    .background(Color(.systemGroupedBackground))
                }
            }
            .navigationTitle("History")
            .toolbar {
                if !viewModel.analysisHistory.isEmpty {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Clear") {
                            withAnimation {
                                viewModel.analysisHistory.removeAll()
                            }
                        }
                        .foregroundStyle(.red)
                    }
                }
            }
        }
    }
}

struct HistoryRowView: View {
    let entry : HistoryEntry

    var color: Color {
        switch entry.score {
        case 0.2...: return .green
        case ..<(-0.2): return .red
        default: return .orange
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(entry.label)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(color)
                Spacer()
                Text(entry.date, style: .time)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Text(entry.shortText)
                .font(.footnote)
                .foregroundColor(.primary)
                .lineLimit(2)
            HStack {
                Text("Score: \(entry.score, specifier: "%.3f")")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                Spacer()
                Text(entry.date, style: .date)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(12)
        .background(color.opacity(0.07))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(color.opacity(0.2), lineWidth: 1)
        )
    }
}

