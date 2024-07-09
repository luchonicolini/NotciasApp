//
//  ArticleDetailView.swift
//  NotciasApp
//
//  Created by Luciano Nicolini on 08/07/2024.
//

import SwiftUI

struct ArticleDetailView: View {
    let article: Article
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                articleImage
                
                VStack(alignment: .leading, spacing: 12) {
                    titleView
                    authorDateView
                    descriptionView
                    readMoreButton
                }
                .padding(.horizontal)
            }
        }
        .background(backgroundGradient)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var articleImage: some View {
        Group {
            if let imageUrl = article.urlToImage,
               let url = URL(string: imageUrl) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 200)
                            .clipped()
                    case .failure(_):
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 200)
                            .foregroundColor(.gray)
                    case .empty:
                        ProgressView()
                            .frame(height: 200)
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Color.gray.frame(height: 200)
            }
        }
    }
    
    private var titleView: some View {
        Text(article.title)
            .font(.title2)
            .fontWeight(.bold)
            .foregroundColor(.primary)
            .fixedSize(horizontal: false, vertical: true)
    }
    
    private var authorDateView: some View {
        HStack {
            if let author = article.author {
                Label(author, systemImage: "person")
            }
            Spacer()
            Label(article.publishedAt.formatted(date: .abbreviated, time: .omitted), systemImage: "calendar")
        }
        .font(.caption)
        .foregroundColor(.secondary)
    }
    
    private var descriptionView: some View {
        Group {
            if let description = article.description {
                Text(description)
                    .font(.body)
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
    
    private var contentView: some View {
        Group {
            if let content = article.content {
                Text("Full Content")
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding(.top, 8)
                
                Text(content)
                    .font(.body)
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
    
    private var readMoreButton: some View {
        Link(destination: URL(string: article.url)!) {
            Text("Read Full Article")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
        }
        .padding(.top, 8)
    }
    
    private var backgroundGradient: some View {
        LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)]),
                       startPoint: .top,
                       endPoint: .bottom)
            .ignoresSafeArea()
    }
}


#Preview {
    ArticleDetailView(article: Article.sampleArticle)
}
