//
//  ChatTableElement.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 29.10.2024.
//

import UIKit

enum ChatTableElement {
    case questionImageUrl(URL)
    case questionImage(UIImage)
    case questionText(String)
    case loading
    case answer(ChatTableAnswerElement)
    case historyAnswer(ChatMessage)
}

struct ChatTableAnswerElement {
    let runner: ChatMessageRunner
    let message: ChatMessage
}
