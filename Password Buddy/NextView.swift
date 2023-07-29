//
//  NextView.swift
//  Password Buddy
//
//  Created by Yamin Ayon on 7/27/23.
//

import SwiftUI
import KeychainSwift

struct NextView: View {
    @State var loginDataArray: [LoginData]
    @State private var showingEditScreen = false
    @State private var selectedLoginData: LoginData?
    var keychain = KeychainSwift()

    var body: some View {
        VStack {
            Button(action: {
                // Handle change master password action
            }) {
                Text("Change Master Password")
            }
            List {
                ForEach(loginDataArray.indices, id: \.self) { index in
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Website URL: \(loginDataArray[index].websiteUrl)")
                            Text("Email: \(loginDataArray[index].email)")
                            Text("Password: \(loginDataArray[index].websitePassword)")
                        }
                        Spacer()
                        Button(action: {
                            self.selectedLoginData = loginDataArray[index]
                            self.showingEditScreen = true
                        }) {
                            Text("Edit")
                        }
                        Button(action: {
                            // Handle delete action
                            loginDataArray.remove(at: index)

                            // Save the updated array back to the storage
                            let encoder = JSONEncoder()
                            if let encodedData = try? encoder.encode(loginDataArray) {
                                let jsonString = String(data: encodedData, encoding: .utf8) ?? ""
                                self.keychain.set(jsonString, forKey: "storedLoginData")
                            }
                        }) {
                            Text("Delete")
                        }
                    }
                }
            }
            .sheet(isPresented: $showingEditScreen) {
                EditLoginDataView(loginData: $selectedLoginData) {
                    self.showingEditScreen = false

                    // Save changes back to the storage
                    if let loginData = self.selectedLoginData {
                        // Find the index of the selectedLoginData in loginDataArray and update it
                        if let index = self.loginDataArray.firstIndex(where: { $0.websiteUrl == loginData.websiteUrl }) {
                            self.loginDataArray[index] = loginData
                        }

                        // Save the updated array back to the storage
                        let encoder = JSONEncoder()
                        if let encodedData = try? encoder.encode(loginDataArray) {
                            let jsonString = String(data: encodedData, encoding: .utf8) ?? ""
                            self.keychain.set(jsonString, forKey: "storedLoginData")
                        }
                    }
                }
            }
        }
    }
}

struct EditLoginDataView: View {
    @Binding var loginData: LoginData?
    @State var websiteUrl: String = ""
    @State var email: String = ""
    @State var websitePassword: String = ""
    var onSave: () -> Void

    var body: some View {
        VStack {
            TextField("Website URL", text: $websiteUrl)
            TextField("Email", text: $email)
            TextField("Password", text: $websitePassword)
            
            Button(action: {
                // Save changes
                if var loginData = loginData {
                    loginData.websiteUrl = websiteUrl
                    loginData.email = email
                    loginData.websitePassword = websitePassword
                    self.loginData = loginData
                }
                onSave()  // Call the closure
            }) {
                Text("Save")
            }
        }
        .onAppear {
            // Initialize text fields with current loginData values
            websiteUrl = loginData?.websiteUrl ?? ""
            email = loginData?.email ?? ""
            websitePassword = loginData?.websitePassword ?? ""
        }
    }
}
