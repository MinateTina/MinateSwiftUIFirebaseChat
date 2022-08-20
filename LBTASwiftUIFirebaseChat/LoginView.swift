//
//  ContentView.swift
//  LBTASwiftUIFirebaseChat
//
//  Created by Minate on 6/16/22.
//

import SwiftUI
import Firebase
import FirebaseCoreInternal
import FirebaseStorage



struct LoginView: View {
    
    let didCompletedLoginProcess: () -> ()
    
    @State var isLoginMode = false
    @State var email = ""
    @State var password = ""
    
    @State var shouldShowImagePicker = false
    @Environment(\.colorScheme) var colorScheme
    
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    Picker(selection: $isLoginMode, label: Text("Picker here")) {
                        Text("Login").tag(true)
                        Text("Create Account").tag(false)
                    
                    }.pickerStyle(SegmentedPickerStyle())
                        
                    if !isLoginMode {
                        Button  {
                            shouldShowImagePicker.toggle()
                        } label: {
                            VStack {
                                if let image = self.image {
                                    Image(uiImage: image)
                                        .resizable()
                                        .frame(width: 128, height: 128)
                                        .scaledToFill()
                                        .cornerRadius(128)
                                } else {
                                    Image(systemName: "person.fill")
                                    .font(.system(size: 64))
                                    .padding()
                                    .foregroundColor(colorScheme == .light ? Color.black : Color.white)
                                }
                                
                            }
                            .overlay(RoundedRectangle(cornerRadius: 64).stroke(colorScheme == .light ? Color.black : Color.white, lineWidth: 3))
                            
                            
                        }
                    }
                 
                    
                    Group {
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            
                        SecureField("Password", text: $password)
                            
                    }.padding(12)
                        .foregroundColor(colorScheme == .light ? Color.gray : Color.black)
                    .background(Color.white)
                    
                
                    
                    Button {
                        handleAction()
                    } label: {
                        HStack{
                            Spacer()
                            Text(isLoginMode ? "Log In" : "Create Account").foregroundColor(Color.white)
                                .padding()
                                .font(.system(size: 14, weight: .semibold))
                            Spacer()
                        }.background(Color.blue)

                    }
                    Text(self.loginStatusMessage)
                    
                }.padding()
                    
            }.navigationTitle(isLoginMode ? "Login" : "Create Account")
                .background(Color(.init(white: 0, alpha: 0.05))
            .ignoresSafeArea())
        }.navigationViewStyle(StackNavigationViewStyle())
            .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
                ImagePicker(image: $image)
            }
    }
    
    @State var image : UIImage?
    
    private func handleAction() {
        if isLoginMode {
            loginUser()
        } else {

            CreateNewAccount()
        }
    }
    
    
    @State var loginStatusMessage = ""
    
    private func loginUser() {
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password) { result, err in
            if let err = err {
                print("Failed to login user:", err)
                self.loginStatusMessage = "Failed to login user: \(err)"
                return
            }
            
            print("Successfully logged in as user: \(result?.user.uid ?? "")")
            self.loginStatusMessage = "Successfully logged in as user: \(result?.user.uid ?? "")"
            
            self.didCompletedLoginProcess()
        }
    }
    
    private func CreateNewAccount() {
        
        if self.image == nil {
            self.loginStatusMessage = "You must select an avatar image"
            return
        }
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password) { result, err in
            
            if let err = err {
                print("Failed to create user:", err)
                self.loginStatusMessage = "Failed to create user: \(err)"
                return
            }
            
            print("Successfully created user: \(result?.user.uid ?? "")")
            self.loginStatusMessage = "Successfully created user: \(result?.user.uid ?? "")"
            
            self.persistImageToStorage()
            
        }
    }
    
    private func persistImageToStorage() {
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let ref = FirebaseManager.shared.storage.reference(withPath: uid)
        guard let imageData = self.image?.jpegData(compressionQuality: 0.5) else { return }
        
        ref.putData(imageData, metadata: nil) { metaData, err in
            if let err = err {
                self.loginStatusMessage = "Failed to push image to storage \(err)"
                return
            }
            
            ref.downloadURL { url, err in
                if let err = err {
                    self.loginStatusMessage = "Failed to retrieve downloadUrl \(err)"
                    return
                }
                
                self.loginStatusMessage = "Successfully stored image with url: \(url?.absoluteString ?? "")"
                
                guard let url = url else { return }
                self.storeUserInformation(imageProfileUrl: url)
            }
            
        }
        
    }
    
    private func storeUserInformation(imageProfileUrl: URL) {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        let userData = ["email": self.email, "uid": uid, "profileImageUrl": imageProfileUrl.absoluteString]
        FirebaseManager.shared.firestore.collection("users").document(uid).setData(userData) { err in
            if let err = err {
                print(err)
                self.loginStatusMessage = "\(err)"
                return
            }
            
            print("success")
            
            self.didCompletedLoginProcess()
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(didCompletedLoginProcess:{
            
        })
            .colorScheme(.dark)
        LoginView(didCompletedLoginProcess:{
            
        })
            .colorScheme(.light)
    }
}
