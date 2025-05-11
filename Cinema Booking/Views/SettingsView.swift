import SwiftUI

struct SettingsView: View {
    private let userNameKey = "userName"
    private let userPhoneNumberKey = "userPhoneNumber"
    private let userEmailKey = "userEmail"
    
    @State private var name: String  = UserDefaults.standard.string(forKey: "userName") ?? "Citizen"
    @State private var phoneNumber: String = UserDefaults.standard.string(forKey: "userPhoneNumber") ?? "0434567890"
    @State private var email: String = UserDefaults.standard.string(forKey: "userEmail") ?? "janecitizen@gmail.com"
    
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var alertTitle = "Error"
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    
                    Text("User Settings")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 32)
                        .padding(.horizontal)
                    
                    VStack(spacing: 16) {
                        CustomInputField(title: "Name", text: $name, keyboard: .default)
                        CustomInputField(title: "Phone Number", text: $phoneNumber, keyboard: .phonePad)
                        CustomInputField(title: "Email", text: $email, keyboard: .emailAddress)
                    }
                    .padding(.horizontal)
                    
                    Button(action: {
                        if name.isEmpty {
                            alertMessage = "Please enter your name."
                            alertTitle = "Error"
                            showingAlert = true
                        } else if !isValidPhoneNumber(phoneNumber) {
                            alertMessage = "Please enter a valid phone number."
                            alertTitle = "Error"
                            showingAlert = true
                        } else if !isValidEmail(email) {
                            alertMessage = "Please enter a valid email address."
                            alertTitle = "Error"
                            showingAlert = true
                        } else {
                            UserDefaults.standard.set(name, forKey: userNameKey)
                            UserDefaults.standard.set(phoneNumber, forKey: userPhoneNumberKey)
                            UserDefaults.standard.set(email, forKey: userEmailKey)
                            
                            alertMessage = "Settings saved successfully!"
                            alertTitle = "Success"
                            showingAlert = true
                        }
                    }) {
                        Text("Save")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                            .shadow(radius: 2)
                    }
                    .padding(.horizontal)
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                    }
                    
                    Spacer(minLength: 32)
                }
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                name = UserDefaults.standard.string(forKey: userNameKey) ?? "Citizen"
                phoneNumber = UserDefaults.standard.string(forKey: userPhoneNumberKey) ?? "0434567890"
                email = UserDefaults.standard.string(forKey: userEmailKey) ?? "janecitizen@gmail.com"
            }
        }
    }
    
    func isValidPhoneNumber(_ number: String) -> Bool {
        return number.count == 10 && number.hasPrefix("04")
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}

struct CustomInputField: View {
    let title: String
    @Binding var text: String
    var keyboard: UIKeyboardType = .default

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.gray)

            TextField("", text: $text)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .keyboardType(keyboard)
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
    }
}
