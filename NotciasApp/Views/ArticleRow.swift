//
//  ArticleRow.swift
//  NotciasApp
//
//  Created by Luciano Nicolini on 08/07/2024.
//

import SwiftUI

struct ArticleRow: View {
    let article: Article
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if let imageUrl = article.urlToImage,
               let url = URL(string: imageUrl) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .clipped()
                        .cornerRadius(8)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 200)
                        .cornerRadius(8)
                }
            }
            
            Text(article.title)
                .font(.headline)
                .lineLimit(2)
                .foregroundColor(.primary)
            
            if let description = article.description {
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
            }
            
            HStack {
                Image(systemName: "clock")
                    .foregroundColor(.secondary)
                Text(formatDate(article.publishedAt))
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text(article.source.name)
                    .font(.caption)
                    .padding(5)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(5)
            }
        }
        .padding(.vertical, 8)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    ArticleRow(article: Article.sampleArticle)
}

extension Article {
    static var sampleArticle: Article {
        Article(
            source: Source(id: "sample-source", name: "Sample News"),
            author: "John Doe",
            title: "Este es un título de muestra para el artículo de noticias",
            description: "Esta es una descripción de muestra para el artículo. Proporciona un breve resumen del contenido del artículo.",
            url: "https://example.com/sample-article",
            urlToImage: "https://example.com/sample-image.jpg",
            publishedAt: Date(),
            content: "Este es el contenido completo del artículo de muestra..."
        )
    }
}
