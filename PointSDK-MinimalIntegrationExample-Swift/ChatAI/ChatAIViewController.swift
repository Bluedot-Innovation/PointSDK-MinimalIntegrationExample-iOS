//
//  ChatAIViewController.swift
//  BDTestApp
//
//  Created by Nataliia Klymenko on 15/11/2024.
//  Copyright © 2024 Bluedot Innovation. All rights reserved.
//

import SwiftUI
import UIKit

class ChatAIViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let chatView = ChatAIView()
        let hostingController = UIHostingController(rootView: chatView)
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        hostingController.didMove(toParent: self)
    }
}
