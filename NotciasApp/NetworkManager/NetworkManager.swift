//
//  NetworkManager.swift
//  NotciasApp
//
//  Created by Luciano Nicolini on 04/07/2024.
//

// NetworkManager.swift

import Foundation
import SwiftUI

protocol NewsNetworkManagerProtocol {
    func getNews() async throws -> News
}

final class NetworkManager: NewsNetworkManagerProtocol {
    static let shared = NetworkManager()
    private let urlNews = "https://newsapi.org/v2/everything?q=bitcoin&apiKey=6d8b91a5f9334b2ca815997bc1a16fa7"
    private let decoder: JSONDecoder
    private let userDefaults = UserDefaults.standard
    private let newsKey = "cachedNews"

    private init() {
        self.decoder = JSONDecoder()
        self.decoder.dateDecodingStrategy = .iso8601
    }

    func getNews() async throws -> News {
        if let cachedNews = loadNewsFromUserDefaults() {
            return cachedNews
        }

        guard let url = URL(string: urlNews) else {
            throw NetworkError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }

        do {
            let news = try decoder.decode(News.self, from: data)
            saveNewsToUserDefaults(news)
            return news
        } catch {
            throw NetworkError.invalidData
        }
    }

    private func saveNewsToUserDefaults(_ news: News) {
        do {
            let encodedData = try JSONEncoder().encode(news)
            userDefaults.set(encodedData, forKey: newsKey)
        } catch {
            print("Error saving news to UserDefaults: \(error)")
        }
    }

    private func loadNewsFromUserDefaults() -> News? {
        guard let encodedData = userDefaults.data(forKey: newsKey) else {
            return nil
        }

        do {
            return try JSONDecoder().decode(News.self, from: encodedData)
        } catch {
            print("Error loading news from UserDefaults: \(error)")
            return nil
        }
    }
}



