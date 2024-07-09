//
//  ContentView.swift
//  NotciasApp
//
//  Created by Luciano Nicolini on 04/07/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel: NewsViewModel
    @State private var searchText = ""
    
    init(networkManager: NewsNetworkManagerProtocol = NetworkManager.shared) {
        _viewModel = State(initialValue: NewsViewModel(networkManager: networkManager))
    }
   
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)]),
                               startPoint: .top,
                               endPoint: .bottom)
                    .ignoresSafeArea()
            
                Group {
                    if viewModel.isLoading {
                        ProgressView()
                    } else if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    } else {
                        List {
                            ForEach(filteredNews, id: \.url) { article in
                                NavigationLink(destination: ArticleDetailView(article: article)) {
                                    ArticleRow(article: article)
                                        .padding(.vertical, 8)
                                }
                                .listRowBackground(Color.clear)
                             
                            }
                        }
                        .listStyle(PlainListStyle())
                        .refreshable {
                            await refreshNews()
                        }
                    }
                }
            }
            .navigationTitle("Noticias")
            .searchable(text: $searchText, prompt: "Buscar noticias")
        }
    }
    
    var filteredNews: [Article] {
        if searchText.isEmpty {
            return viewModel.news
        } else {
            return viewModel.news.filter { article in
                article.title.lowercased().contains(searchText.lowercased()) ||
                (article.description?.lowercased().contains(searchText.lowercased()) ?? false)
            }
        }
    }
    
    func refreshNews() async {
        await viewModel.fetchNewsAsync()
    }
}


#Preview {
    ContentView()
}


