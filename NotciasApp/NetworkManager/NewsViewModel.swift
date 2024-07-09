//
//  NewsViewModel.swift
//  NotciasApp
//
//  Created by Luciano Nicolini on 04/07/2024.
//

import Foundation
import SwiftData

@Observable
class NewsViewModel {
    var news: [Article] = []
    var errorMessage: String?
    var isLoading = false
    private let networkManager: NewsNetworkManagerProtocol

    init(networkManager: NewsNetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
        loadCachedNews()
    }

    func fetchNews() {
        Task {
            await fetchNewsAsync()
        }
    }

    func fetchNewsAsync() async {
        isLoading = true
        do {
            let article = try await networkManager.getNews()
            news = article.articles
            errorMessage = nil
        } catch {
            if let networkError = error as? NetworkError {
                errorMessage = networkError.rawValue
            } else {
                errorMessage = error.localizedDescription
            }
        }
        isLoading = false
    }

    private func loadCachedNews() {
        Task {
            do {
                let cachedNews = try await networkManager.getNews()
                news = cachedNews.articles
            } catch {
                print("Error loading cached news: \(error)")
            }
        }
    }
}


