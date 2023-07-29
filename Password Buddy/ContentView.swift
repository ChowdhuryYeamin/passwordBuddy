//
//  ContentView.swift
//  Password Buddy
//
//  Created by Yamin Ayon on 7/27/23.
//

import SwiftUI
import KeychainSwift

struct ContentView: View {

    var body: some View {
        NavigationView {
                    LoginView()
                }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
