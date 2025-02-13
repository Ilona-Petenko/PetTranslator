//
//  Gradient.swift
//  pet_translator
//
//  Created by ilona petenko on 12.02.2025.
//

import Foundation
import SwiftUI


struct GradientBakground: View {
    var body: some View {
        
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 243.0/255.0, green: 245.0/255.0, blue: 246.0/255.0),
                Color(red: 201.0/255.0, green: 255.0/255.0, blue: 224.0/255.0)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
