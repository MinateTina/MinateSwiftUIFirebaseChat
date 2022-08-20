//
//  ChatUser.swift
//  LBTASwiftUIFirebaseChat
//
//  Created by Minate on 6/18/22.
//

import FirebaseFirestoreSwift

struct ChatUser: Codable, Identifiable {
    @DocumentID var id: String?
    let uid, email, profileImageUrl: String
}


//struct ChatUser : Identifiable {
//
//    var id : String { uid }
//
//    let uid, email, profileImageUrl: String
//
//    init(data:[String: Any]) {
//        self.uid = data["uid"] as? String ?? ""
//        self.email = data["email"] as? String ?? ""
//        self.profileImageUrl = data["profileImageUrl"] as? String ?? ""
//
//    }
//}
