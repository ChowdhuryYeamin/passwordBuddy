//
//  LoginView.swift
//  Password Buddy
//
//  Created by Yamin Ayon on 7/27/23.
//

import SwiftUI
import KeychainSwift

struct LoginView: View {
    @State private var masterPassword: String = ""
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var keychain: KeychainSwift = KeychainSwift()

    var body: some View {
        VStack {
            TitleView()

            MasterPasswordView(masterPassword: $masterPassword)

            SubmitButtonView(action: storeMasterPassword)
                            .disabled(masterPassword.isEmpty)

            if masterPassword.isEmpty {
                Text("Master password cannot be empty!")
                    .foregroundColor(.red)
            }
        }
    }
    
    func storeMasterPassword() {
        if !masterPassword.isEmpty {
            UserDefaults.standard.setValue(masterPassword, forKey: "masterPassword")
            navigateToNextView()
        }
    }


//    func storeMasterPassword() {
//        if !masterPassword.isEmpty {
//            let storedSuccessfully = keychain.set(masterPassword, forKey: "masterPassword")
//            if storedSuccessfully {
//                navigateToNextView()
//            }
//        }
//    }

    func navigateToNextView() {
        let nextView = MainView()
        let hostingController = UIHostingController(rootView: nextView)
        hostingController.modalPresentationStyle = .fullScreen

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(hostingController, animated: true, completion: nil)
        }
    }

}



struct TitleView: View {
    var body: some View {
        Text("Password Buddy")
            .font(.largeTitle)
            .bold()
            .padding()
    }
}





