//
//  CheckoutSuccessView.swift
//  Cinema Booking
//
//  Created by Soorya Narayanan Sanand on 10/5/2025.
//


import SwiftUI

struct CheckoutSuccessView: View {
    @EnvironmentObject var navigationHelper: NavigationHelper
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.seal")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.green)

            Text("Booking Confirmed!")
                .font(.title)
                .bold()

            Button(action: {
                navigationHelper.returnToRoot()
            }) {
                Text("Back to Home")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}
