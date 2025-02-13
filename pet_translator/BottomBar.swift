//
//  BottomBar.swift
//  pet_translator
//
//  Created by ilona petenko on 11.02.2025.
//

import Foundation
import SwiftUI


struct BottomBar: View {
    @Binding var selectedPage: String
    
    var body: some View {
        HStack {
            Button(action: {
                selectedPage = "Translator"
            }) {
                VStack {
                    Image("messages-2")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 24, height: 24)
                        .foregroundColor(selectedPage == "Translator" ? .black : .gray)
                    
                    Text("Translator")
                        .font(.caption)
                        .foregroundColor(selectedPage == "Translator" ? .black : .gray)
                }
            }
            
            Spacer()
            
            Button(action: {
                selectedPage = "Clicker"
            }) {
                VStack {
                    Image("settings")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 24, height: 24)
                        .foregroundColor(selectedPage == "Clicker" ? .black : .gray)
                    Text("Clicker")
                        .font(.caption)
                        .foregroundColor(selectedPage == "Clicker" ? .black : .gray)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(12)
        .padding(.horizontal, 120)
    }
}
