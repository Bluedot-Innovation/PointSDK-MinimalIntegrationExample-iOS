//
//  ChatMessage.swift
//  PointSDK-MinimalIntegrationExample-iOS
//
//  Created by Nataliia Klymenko on 7/1/2025.
//  Copyright © 2025 Bluedot Innovation. All rights reserved.
//

import Foundation
import BDPointSDK

class ChatMessage: Identifiable, ObservableObject, Equatable {
    
    let id: UUID
    let isUser: Bool
    let timestamp: Date

    @Published var text: String
    @Published var imageURL: URL?
    @Published var imageTitle: String?
    @Published var responseID: String?
    @Published var reaction: Chat.Reaction?

    init(text: String, isUser: Bool = false, timestamp: Date = Date()) {
        self.id = UUID()
        self.text = text
        self.isUser = isUser
        self.timestamp = timestamp
    }
    
    static func == (lhs: ChatMessage, rhs: ChatMessage) -> Bool {
        return lhs.id == rhs.id
    }
}
