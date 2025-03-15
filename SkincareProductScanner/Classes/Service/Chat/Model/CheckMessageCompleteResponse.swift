//
//  CheckMessageCompleteResponse.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 26.10.2024.
//

struct CheckMessageCompleteResponse {
    let runner: ChatMessageRunner
    let message: ChatMessage?
}

// MARK: Public
extension CheckMessageCompleteResponse {
    init?(response: Any) {
        guard
            let json = response as? [String: Any],
            let body = json["body"] as? [String: Any],
            let runnerId = body["run_id"] as? String,
            let runnerStatusRawValue = body["status"] as? String,
            let runnerStatus = ChatMessageRunner.Status(rawValue: runnerStatusRawValue),
            let runnerIsComplete = body["is_complete"] as? Bool
        else { return nil }
        
        runner = ChatMessageRunner(
            id: runnerId,
            status: runnerStatus,
            isComplete: runnerIsComplete
        )
        message = {
            guard let json = body["content"] as? [String: Any] else { return nil }
            return ChatMessage(json: json)
        }()
    }
}
