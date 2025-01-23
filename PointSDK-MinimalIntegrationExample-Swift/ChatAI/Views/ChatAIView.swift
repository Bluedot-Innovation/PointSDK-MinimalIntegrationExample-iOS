//
//  ChatAIView.swift
//  BDTestApp
//
//  Created by Nataliia Klymenko on 15/11/2024.
//  Copyright © 2024 Bluedot Innovation. All rights reserved.
//

import SwiftUI
import WebKit

struct ChatAIView: View {
    @State private var typingMessage: String = ""
    @ObservedObject var viewModel: ChatAIViewModel = ChatAIViewModel()
    
    var body: some View {
        ZStack {
            Color.chatAIBackground
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Button {
                        viewModel.resetChat()
                    } label: {
                        Text("Start new conversation")
                            .padding(.leading, 15)
                            .font(.footnote.weight(.bold))
                    }
                    Spacer()
                    Text("Brain Chat AI")
                        .padding(.trailing, 15)
                        .font(.headline)
                }
                Divider()
                    .background(Color(UIColor.lightGray))
                
                ScrollViewReader { proxy in
                    
                    if #available(iOS 17, *) {
                        ScrollView {
                            LazyVStack {
                                ForEach(viewModel.messages) { message in
                                    ChatBubbleView(message: message)
                                        .environmentObject(viewModel)
                                }
                            }
                        }
                        .defaultScrollAnchor(.bottom)
                    } else {
                        ScrollView {
                            ForEach(viewModel.messages) { message in
                                ChatBubbleView(message: message)
                                    .environmentObject(viewModel)
                            }
                            .onChange(of: viewModel.messages) { _ in
                                proxy.scrollTo(viewModel.messages.count - 1, anchor: .bottom)
                            }
                        }
                    }
                }
                
                Divider()
                    .background(Color(UIColor.lightGray))
                
                HStack {
                    TextField("Type your message here...", text: $typingMessage)
                        .padding(.bottom, 10)
                        .padding(.leading, 10)
                        .padding(.top, 5)
                        .textFieldStyle(.roundedBorder)
                    
                    Button {
                        viewModel.sendMessage(message: typingMessage)
                        typingMessage = ""
                    } label: {
                        Image(systemName: "paperplane")
                            .frame(height: 15)
                            .foregroundColor(.white)
                            .padding(.all, 10)
                }
                    .background(Color.blue)
                    .cornerRadius(20)
                    .padding(.trailing, 10)
                }
            }
            .padding(.top, 5)
        }
    }
}

