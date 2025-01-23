//
//  FeedbackView.swift
//  PointSDK-MinimalIntegrationExample-Swift
//
//  Created by Nataliia Klymenko on 10/1/2025.
//  Copyright © 2025 Bluedot Innovation. All rights reserved.
//

import SwiftUI

struct FeedbackView: View {
    @EnvironmentObject private var chatAIViewModel: ChatAIViewModel
    @EnvironmentObject private var chatMessage: ChatMessage
    
    var body: some View {
        HStack {
            Spacer()
            Button {
                Task {
                    if let responseID = chatMessage.responseID {
                        await chatAIViewModel.sendFeedback(responseID: responseID, reaction: .liked)
                    }
                }
            } label: {
                if let reaction = chatMessage.reaction,
                   reaction == .liked {
                    Image(systemName: "hand.thumbsup.fill")
                        .padding(.trailing, 10)

                } else {
                    Image(systemName: "hand.thumbsup")
                        .padding(.trailing, 10)
                }
            }
            Button {
                Task {
                    if let responseID = chatMessage.responseID {
                        await chatAIViewModel.sendFeedback(responseID: responseID, reaction: .disliked)
                    }
                }
            } label: {
                if let reaction = chatMessage.reaction,
                   reaction == .disliked {
                    Image(systemName: "hand.thumbsdown.fill")
                } else {
                    Image(systemName: "hand.thumbsdown")
                }
            }
        }
        .padding(.trailing, 10)
        .padding(.bottom, 10)
        .foregroundColor(.gray)
    }
}

#Preview {
    FeedbackView()
}
