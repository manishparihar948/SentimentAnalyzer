//
//  BaseView.swift
//  SentimentAnalyzer
//
//  Created by Manish Parihar on 16.03.26.
//

import SwiftUI

struct BaseView: View {
    @StateObject private var viewModel  = SentimentViewModel()
    var body: some View {
        TabView{
            AnalyzerView(viewModel: viewModel)
                .tabItem {
                    Label("Analyze", systemImage: "text.magnifyingglass")
                }

            HistoryView()
                .tabItem {
                    Label("History", systemImage: "clock.arrow.circlepath")
                }
        }
    }
}

#Preview {
    BaseView()
}
