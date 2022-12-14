//
//  RecentMessage.swift
//  LBTASwiftUIFirebaseChat
//
//  Created by Minate on 6/20/22.
//

import Foundation
import FirebaseFirestoreSwift

struct RecentMessage: Codable, Identifiable {
    
    @DocumentID var id: String?
    let text, email: String
    let fromId, toId: String
    let profileImageUrl: String
    let timestamp: Date
    
    var username: String {
        email.components(separatedBy: "@").first ?? email
    }
    
    var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: timestamp, relativeTo: Date())
    }
}


//struct RecentMessage: Identifiable {
//
//    var id: String { documentId }
//
//    let documentId: String
//    let text, email: String
//    let fromId, toId: String
//    let profileImageUrl: String
//    let timestamp: Date?
//
//    init(documentId: String, data: [String: Any]) {
//        self.documentId = documentId
//        self.text = data["text"] as? String ?? ""
//        self.fromId = data["fromId"] as? String ?? ""
//        self.toId = data["toId"] as? String ?? ""
//        self.profileImageUrl = data["profileImageUrl"] as? String ?? ""
//        self.email = data["email"] as? String ?? ""
//        self.timestamp = data["timestamp"] as? Date ?? Date
//    }
//
//    var timeAgo: String {
//        let formatter = RelativeDateTimeFormatter()
//        formatter.unitsStyle = .abbreviated
//        return formatter.localizedString(for: timestamp , relativeTo: Date())
//    }
//}
