//
//  File.swift
//  pet_translator
//
//  Created by ilona petenko on 11.02.2025.
//

import Foundation
import SwiftUI


struct ProcessingPage: View {
    @Binding var selectedAnimal: String
    @Binding var selectedPage: String
    
    private var selectedPetImageName: String {
        switch selectedAnimal {
        case "Cat": return "cat"
        case "Dog": return "dog"
        default: return ""
        }
    }
    
    var body: some View {
        ZStack {
            GradientBakground()
            
            VStack {
                Spacer()
                
                Text("Processing Translation...")
                    .font(.title2)
                    .bold()
                    .padding(.bottom, 50)
                    .foregroundColor(.black)
                
                Image(selectedPetImageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .padding(.bottom, 60)

                BottomBar(selectedPage: $selectedPage)
                    .padding(.bottom, 10)
                
            
            }
        }
    }
}
