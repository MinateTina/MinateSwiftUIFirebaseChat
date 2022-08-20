//
//  CreateNewMessageView.swift
//  LBTASwiftUIFirebaseChat
//
//  Created by Minate on 6/18/22.
//

import SwiftUI
import SDWebImageSwiftUI
import FirebaseFirestoreSwift

class CreateNewMessageViewModel: ObservableObject {
    
    @Published var users = [ChatUser]()
    @Published var errMessage = ""
    
    init() {
        fetchAllUsers()
    }
    
    func fetchAllUsers() {
        FirebaseManager.shared.firestore.collection("users").getDocuments { documentSnapshot, err in
            if let err = err {
                self.errMessage = "Failed to fetch users: \(err)"
                print("Failed to fetch users \(err)")
                return
            }
            
            documentSnapshot?.documents.forEach({ snapshot in
                let user = try? snapshot.data(as: ChatUser.self)
                if user?.id != FirebaseManager.shared.auth.currentUser?.uid {
                    self.users.append(user!)
                }
//                let data = snapshot.data()
//                let user = ChatUser(data: data)
//                //if you don't want yourself appear on new message lists
//                if user.uid != FirebaseManager.shared.auth.currentUser?.uid {
//                    self.users.append(.init(data: data))
//                }
                
            })
            
            self.errMessage = "Fetched users successfully"
        }
    }
    
}

struct CreateNewMessageView: View {
    //pass the new user you select back to MainMessageView
    let didSelectNewUser : (ChatUser) -> ()
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var vm = CreateNewMessageViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                
                ForEach(vm.users) { user in
                    Button {
                        presentationMode.wrappedValue.dismiss()
                        didSelectNewUser(user)
                    } label: {
                        HStack(spacing: 16) {
                            WebImage(url: URL(string: user.profileImageUrl))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipped()
                                .cornerRadius(50)
                                .overlay(RoundedRectangle(cornerRadius: 50).stroke(Color(.label), lineWidth: 1))
                            Text(user.email).foregroundColor(Color(.label))
                            Spacer()
                        }.padding(.horizontal)
                    }

                    Divider()
                        .padding(.vertical, 8)
                }
      
            }.navigationTitle("New Message")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("Cancel")
                        }

                    }
                }
        }
    }
}

struct CreateNewMessageView_Previews: PreviewProvider {
    static var previews: some View {
        //CreateNewMessageView(didSelectNewUser: (user) -> ())
        MainMessageView()
    }
}
