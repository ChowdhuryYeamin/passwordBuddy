//
//  SubmitButtonView.swift
//  Password Buddy
//
//  Created by Yamin Ayon on 7/27/23.
//

import SwiftUI
import KeychainSwift

struct SubmitButtonView: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text("Submit")
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(10.0)
        }
        .padding()
    }
}
