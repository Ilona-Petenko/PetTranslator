//
//  File.swift
//  pet_translator
//
//  Created by ilona petenko on 11.02.2025.
//

import Foundation
import SwiftUI

struct SettingsRow: View {
    let title: String
    
    var body: some View {
        HStack {
            Text(title).font(.body).foregroundColor(.black)
            Spacer()
            Image(systemName: "chevron.right").foregroundColor(.gray)
        }
        .padding()
        .background(Color(red: 214.0/255.0, green: 220.0/255.0, blue: 255.0/255.0))
        .cornerRadius(24)
    }
}


struct SettingsPage: View {
    @Binding var selectedPage: String
    
    var body: some View {
        ZStack {
            GradientBakground()
            
            VStack {
                Text("Settings")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 50)
                    .foregroundColor(.black)
                
                VStack(spacing: 10) {
                    SettingsRow(title: "Rate Us")
                    SettingsRow(title: "Share App")
                    SettingsRow(title: "Contact Us")
                    SettingsRow(title: "Restore Purchases")
                    SettingsRow(title: "Privacy Policy")
                    SettingsRow(title: "Terms of Use")
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                BottomBar(selectedPage: $selectedPage)
                    .padding(.bottom, 10)
            }
        }
    }
}
