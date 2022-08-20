//
//  ChatMessage.swift
//  LBTASwiftUIFirebaseChat
//
//  Created by Minate on 6/19/22.
//

import Foundation
import FirebaseFirestoreSwift

struct ChatMessage: Codable, Identifiable {
    @DocumentID var id: String?
    let fromId, toId, text: String
    let timestamp: Date
}

//struct ChatMessage: Identifiable {
//
//    var id: String { documentId }
//
//    let documentId: String
//    let fromId, toId, text: String
//
//    init(documentId: String, data: [String: Any]) {
//        self.documentId = documentId
//        self.fromId = data["fromId"] as? String ?? ""
//        self.toId = data["toId"] as? String ?? ""
//        self.text = data["text"] as? String ?? ""
//    }
//}
