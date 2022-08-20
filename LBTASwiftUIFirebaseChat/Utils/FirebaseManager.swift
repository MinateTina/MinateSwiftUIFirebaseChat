//
//  FirebaseManager.swift
//  LBTASwiftUIFirebaseChat
//
//  Created by Minate on 6/17/22.
//

import Foundation
import Firebase
import FirebaseStorage



//This singleton created for fast fresh Preview on the right side
class FirebaseManager: NSObject {
    
    let auth: Auth
    let storage: Storage
    let firestore: Firestore
    
    var currentUser: ChatUser?
    
    static let shared = FirebaseManager()
    
    override init() {
        FirebaseApp.configure()
        
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        self.firestore = Firestore.firestore()
        
        super.init()
    }
    
}
