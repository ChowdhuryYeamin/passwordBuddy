import SwiftUI
import KeychainSwift



struct LoginData: Codable {
        var websiteUrl: String
        var email: String
        var websitePassword: String
    }

struct MainView: View {
    @State private var websiteUrl: String = ""
    @State private var email: String = ""
    @State private var websitePassword: String = ""
    @State private var masterPassword: String = ""
    @State private var showNextView = false
    @State private var loginDataArray = [LoginData]()
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertText = ""
    var keychain: KeychainSwift = KeychainSwift()
    
    

    var body: some View {
        VStack {
            HeaderView()

            TextField("Website URL", text: $websiteUrl)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            SecureField("Website Password", text: $websitePassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: storeData) {
                Text("Store Data")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10.0)
            }
            .padding()
            .disabled(websiteUrl.isEmpty || email.isEmpty || websitePassword.isEmpty)

            SecureField("Master Password", text: $masterPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: verifyMasterPasswordAndNavigate) {
                Text("Retrieve Data")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10.0)
            }
            .padding()
            .disabled(masterPassword.isEmpty)
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertTitle), message: Text(alertText), dismissButton: .default(Text("OK")))
        }
        .sheet(isPresented: $showNextView) {
            NextView(loginDataArray: loginDataArray)
        }
    }

    func storeData() {
            // Check if the password is strong enough
            let passwordStrength = checkPasswordStrength(password: websitePassword)
            
            switch passwordStrength {
            case "Medium", "Strong", "Very Strong":
                // Password is strong enough, continue to store the data
                let newLoginData = LoginData(websiteUrl: websiteUrl, email: email, websitePassword: websitePassword)
                
                loginDataArray.append(newLoginData)

                // Save the updated array back to the storage
                let encoder = JSONEncoder()
                if let encodedData = try? encoder.encode(loginDataArray) {
                    let jsonString = String(data: encodedData, encoding: .utf8) ?? ""
                    self.keychain.set(jsonString, forKey: "storedLoginData")
                }

                // After storing data, clear the text fields
                websiteUrl = ""
                email = ""
                websitePassword = ""
                
                showAlert = true
                alertTitle = "Success"
                alertText = "Data stored successfully."

            default:
                // Password is not strong enough, do not store the data and show an alert
                showAlert = true
                alertTitle = "Error"
                alertText = "Password is \(passwordStrength). Please use a stronger password."
            }
        }

    func verifyMasterPasswordAndNavigate() {
        let storedPassword = UserDefaults.standard.string(forKey: "masterPassword")
        if storedPassword == masterPassword {
            // Password is correct, retrieve the loginDataArray from the storage
            if let jsonString = keychain.get("storedLoginData"), let jsonData = jsonString.data(using: .utf8) {
                let decoder = JSONDecoder()
                do {
                    let decodedData = try decoder.decode([LoginData].self, from: jsonData)
                    self.loginDataArray = decodedData
                    // set showNextView to true to present the next view
                    showNextView = true
                } catch {
                    showAlert = true
                    alertTitle = "Error"
                    alertText = "Failed to decode stored data."
                }
            } else {
                showAlert = true
                alertTitle = "Error"
                alertText = "No stored data found."
            }
        } else {
            // Password is incorrect, show an alert
            showAlert = true
            alertTitle = "Error"
            alertText = "Incorrect master password."
        }
    }

    

    func checkPasswordStrength(password: String) -> String {
        var strength = 0

        if password.count > 8 {
            strength += 1
        }

        if password.count > 12 {
            strength += 1
        }

        let lowercaseLetterRegEx  = "[a-z]"
        let uppercaseLetterRegEx = "[A-Z]"
        let digitRegEx  = "[0-9]"
        let specialCharacterRegEx  = "[!@#$%^&*(),.?\":{}|<>]"
        
        if password.range(of: lowercaseLetterRegEx, options: .regularExpression) != nil &&
            password.range(of: uppercaseLetterRegEx, options: .regularExpression) != nil {
            strength += 1
        }

        if password.range(of: digitRegEx, options: .regularExpression) != nil {
            strength += 1
        }

        if password.range(of: specialCharacterRegEx, options: .regularExpression) != nil {
            strength += 1
        }

        switch strength {
        case 0:
            return "Very Weak"
        case 1:
            return "Weak"
        case 2:
            return "Medium"
        case 3:
            return "Strong"
        case 4...5:
            return "Very Strong"
        default:
            return "Invalid"
        }
    }
}
