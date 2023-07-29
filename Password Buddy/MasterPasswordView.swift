//
//  MasterPasswordView.swift
//  Password Buddy
//
//  Created by Yamin Ayon on 7/27/23.
//

import SwiftUI
import KeychainSwift

import SwiftUI
import KeychainSwift

struct MasterPasswordView: View {
    @Binding var masterPassword: String
    
    var body: some View {
        VStack {
            TextField("Enter Master Password", text: $masterPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

           
        }
    }
}

struct MasterPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        MasterPasswordView(masterPassword: .constant(""))
    }
}

