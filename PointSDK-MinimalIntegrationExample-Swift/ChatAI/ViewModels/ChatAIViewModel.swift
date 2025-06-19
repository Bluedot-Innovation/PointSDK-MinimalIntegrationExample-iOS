//
//  ChatAIViewModel.swift
//  BDTestApp
//
//  Created by Nataliia Klymenko on 15/11/2024.
//  Copyright © 2024 Bluedot Innovation. All rights reserved.
//

import Foundation
@preconcurrency import BDPointSDK

@MainActor
class ChatAIViewModel : ObservableObject {
        
    @Published var chat: Chat? = nil    
    @Published var messages: [ChatMessage] = []
 
    init() {
        createNewChat()
    }
    
    func sendMessage(message: String) {
        guard let chat = self.chat else {
            print("Chat - cannot send message")
            return
        }
                
        let userMessage = ChatMessage(text: message, isUser: true)
        messages.append(userMessage)
        let responseMessage = ChatMessage(text: "")
        messages.append(responseMessage)
        
        Task {
            do {
                for try await streamingResponseDto in chat.sendMessage(message) {
                    await MainActor.run {
                        parseResponse(streamingResponseDto, messageID: responseMessage.id)
                    }
                }
            } catch let error as Chat.ChatError {
                switch error {
                case .invalidApiKey, .invalidApiUrl, .invalidLanguage:
                    print("Chat error - on creating the chat: ", error.errorDescription)
                case .networkError, .decodingError, .unknownError:
                    print("Chat error: ", error.errorDescription)
                case .serverError(let statusCode, let details):
                    if !details.isEmpty, let strDetails = String(data: details, encoding: .utf8) {
                        print("Chat error. Code: \(statusCode), Details: \(strDetails))")
                    } else {
                        print("Chat error. Code: \(statusCode)")
                    }
                    print("Error: ", error.errorDescription)
                @unknown default:
                    print("Unexpected chat error")
                }
            }
        }
    }
    
    func sendFeedback(responseID: String, reaction: Chat.Reaction) async {
        if let chat = chat {
            do {
                try await chat.submitFeedback(responseID: responseID, reaction: reaction)
                print("Feedback sent successfully")
                if let message = getMessageWithResponseID(responseID) {
                    message.reaction = reaction
                }
            } catch {
                print("Failed to send feedback: \(error)")
            }
        }
    }
    
    func resetChat() {
        if let chat = self.chat {
            let sessionID = chat.sessionID
            BDLocationManager.instance().brainAI.closeChat(sessionID:sessionID)
            self.messages = []
        }
        createNewChat()
    }
    
    // MARK: - Private
    private func createNewChat() {
        let result = BDLocationManager.instance().brainAI.createNewChat()
        switch result {
        case .success(let chat):
            self.chat = chat
        case .failure(let error):
            print("Failed to create a chat: \(error.errorDescription)")
        }
    }
    
    private func parseResponse(_ responseDto: StreamingResponseDto, messageID: UUID) {
        switch responseDto.streamType {
        case 1: // CONTEXT
            // We are going to parse only one item, just for an example
            if !responseDto.contexts.isEmpty,
               let message = getMessageWithID(messageID) {
                let item = responseDto.contexts[0]
                if let imageLinks = item.imageLinks {
                    if !imageLinks.isEmpty {
                        message.imageURL = imageLinks[0]
                    }
                }
                if let title = item.title {
                    messages[messages.count - 1].imageTitle = title
                }
            }
            break
        case 2: // RESPONSE_TEXT
            if let responseText = responseDto.response,
               let message = getMessageWithID(messageID) {
                message.text += responseText
            }
            break
        case 3: // RESPONSE_IDENTIFIER
            if let responseID = responseDto.responseID,
                let message = getMessageWithID(messageID) {
                message.responseID = responseID
            }
            break
        default:
            break
        }
    }
    
    private func getMessageWithID(_ messageID: UUID) ->  ChatMessage? {
        if let message = messages.first(where: {$0.id == messageID}) {
           return message
        } else {
           return nil
        }
    }
    
    private func getMessageWithResponseID(_ responseID: String) ->  ChatMessage? {
        if let message = messages.first(where: {$0.responseID == responseID}) {
           return message
        } else {
           return nil
        }
    }
}
