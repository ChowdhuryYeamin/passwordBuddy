import SwiftUI

struct HeaderView: View {
    var body: some View {
        HStack {
            Image(systemName: "lock.shield")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)

            Text("Password Buddy")
                .font(.largeTitle)
                .fontWeight(.bold)

            Spacer() // pushes content to the left
        }
        .padding()
    }
}
