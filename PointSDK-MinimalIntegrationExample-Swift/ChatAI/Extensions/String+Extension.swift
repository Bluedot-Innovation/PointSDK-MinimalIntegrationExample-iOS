//
//  String+Extension.swift
//  PointSDK-MinimalIntegrationExample-iOS
//
//  Created by Nataliia Klymenko on 9/1/2025.
//  Copyright © 2025 Bluedot Innovation. All rights reserved.
//

extension String {

    func markdownFormat() -> String {
        var markdownText = self
        
        // Replace <br> with Markdown newlines
        markdownText = markdownText.replacingOccurrences(of: "<br>", with: "\n")
        
        // Replace <b> and </b> with Markdown bold (**)
        markdownText = markdownText.replacingOccurrences(of: "<b>", with: "**")
        markdownText = markdownText.replacingOccurrences(of: "</b>", with: "**")
        
        // Replace any other symbols as needed
        // Example: Replace <i> with Markdown italic (*)
        markdownText = markdownText.replacingOccurrences(of: "<i>", with: "*")
        markdownText = markdownText.replacingOccurrences(of: "</i>", with: "*")
        
        return markdownText
    }
}
