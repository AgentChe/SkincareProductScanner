//
//  ChatMessageRunner.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 26.10.2024.
//

struct ChatMessageRunner {
    enum Status: String {
        case queued = "queued"
        case completed = "completed"
    }
    
    let id: String
    let status: Status
    let isComplete: Bool
}

// MARK: Public
extension ChatMessageRunner {
    init?(json: [String: Any]) {
        guard
            let id = json["run_id"] as? String,
            let statusRawValue = json["status"] as? String,
            let status = Status(rawValue: statusRawValue),
            let isComplete = json["is_complete"] as? Bool
        else { return nil }
        
        self.id = id
        self.status = status
        self.isComplete = isComplete
    }
}
