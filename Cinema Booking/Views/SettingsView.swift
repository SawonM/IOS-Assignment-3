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
        VStack {
            Text("User Settings")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding(.bottom, 20)
                .padding(.horizontal, 20)
            
            TextField("Name", text: $name)
                .padding()
                .background(Color(white: 0.9))
                .foregroundColor(.black)
                .cornerRadius(8)
                .padding(.horizontal, 20)
           
            TextField("Phone Number", text: $phoneNumber)
                .padding()
                .background(Color(white: 0.9))
                .foregroundColor(.black)
                .cornerRadius(8)
                .keyboardType(.phonePad)
                .padding(.horizontal, 20)
            
            TextField("Email", text: $email)
                .padding()
                .background(Color(white: 0.9))
                .foregroundColor(.black)
                .cornerRadius(8)
                .keyboardType(.emailAddress)
                .padding(.horizontal, 20)
           
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
                    .padding(.horizontal, 30)
                    .padding(.vertical, 12)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.top, 20)
            .padding(.horizontal, 20)
            .alert(isPresented: $showingAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .onAppear(){
            name = UserDefaults.standard.string(forKey: userNameKey) ?? "Citizen"
            phoneNumber = UserDefaults.standard.string(forKey: userPhoneNumberKey) ?? "0434567890"
            email = UserDefaults.standard.string(forKey: userEmailKey) ?? "janecitizen@gmail.com"
        }
    }
    
    func isValidPhoneNumber(_ number: String) -> Bool {
        return number.count == 10 && number.hasPrefix("04")
    }
  
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}
