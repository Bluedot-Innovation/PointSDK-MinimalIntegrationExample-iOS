//
//  ChatBubbleView.swift
//  PointSDK-MinimalIntegrationExample-iOS
//
//  Created by Nataliia Klymenko on 7/1/2025.
//  Copyright © 2025 Bluedot Innovation. All rights reserved.
//

import SwiftUI
import Foundation

struct ChatBubbleView: View {
    @ObservedObject var message: ChatMessage
    @EnvironmentObject private var chatAIViewModel: ChatAIViewModel
    
    var body: some View {
        HStack {
            if message.isUser {
                Spacer()
                Text(message.text.markdownFormat())
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(16)
                    .frame(maxWidth: 320, alignment: .trailing)
                Spacer()
                    .frame(width: 5)
            } else {
                Spacer()
                    .frame(width: 5)
                
                if let imageURL = message.imageURL {
                    VStack {
                        Text(LocalizedStringKey(message.text.markdownFormat()))
                            .padding()
                        
                        VStack {
                            if let imageTitle = message.imageTitle {
                                HStack {
                                    Text(imageTitle)
                                        .fontWeight(.bold)
                                    Spacer()
                                }
                                .padding()
                            }
                                
                            AsyncImage(url: imageURL) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .background(Color.chatAIAnswersBackground)
                                        .cornerRadius(16)
                                        .padding()
                                case .failure:
                                    Image(systemName: "photo") // Fallback image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 200, height: 200)
                                        .foregroundColor(.gray)
                                @unknown default:
                                    EmptyView()
                                }
                            }
                        }
                        .background(.white)
                        .cornerRadius(16)
                        .padding()

                        if message.responseID != nil {
                            FeedbackView()
                                .environmentObject(message)
                                .environmentObject(chatAIViewModel)
                        }
                    }
                    .background(Color.chatAIAnswersBackground)
                    .foregroundColor(.black)
                    .cornerRadius(16)
                    .frame(maxWidth: 320, alignment: .leading)
                } else {
                    VStack {
                        Text(LocalizedStringKey(message.text.markdownFormat()))
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        if message.responseID != nil {
                            FeedbackView()
                                .environmentObject(message)
                                .environmentObject(chatAIViewModel)
                        }
                    }
                    .background(Color.chatAIAnswersBackground)
                    .foregroundColor(.black)
                    .cornerRadius(16)
                    .frame(maxWidth: 320, alignment: .leading)
                }
                Spacer()
            }
        }
    }
}
