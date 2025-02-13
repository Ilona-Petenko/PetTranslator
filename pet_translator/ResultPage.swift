//
//  ResultPage.swift
//  pet_translator
//
//  Created by ilona petenko on 11.02.2025.
//

import Foundation
import SwiftUI

struct SpeechBubble: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let bubbleRect = CGRect(x: rect.minX, y: rect.minY, width: rect.width, height: rect.height * 0.75)
        let tailWidth: CGFloat = rect.width * 0.15
        let tailHeight: CGFloat = rect.height * 0.1
        
        path.addRoundedRect(in: bubbleRect, cornerSize: CGSize(width: 25, height: 25))
        
        let tailStartX = bubbleRect.maxX - 25
        let tailTipX = rect.midX * 1.5
        let tailEndX = bubbleRect.maxX - tailWidth
        
        let tailStartY = bubbleRect.maxY
        let tailTipY = rect.maxY - (tailHeight - 100)
        let tailEndY = bubbleRect.maxY
        
        path.move(to: CGPoint(x: tailStartX, y: tailStartY))
        path.addLine(to: CGPoint(x: tailTipX, y: tailTipY))
        path.addLine(to: CGPoint(x: tailEndX, y: tailEndY))
        path.closeSubpath()
        
        return path
    }
}



struct SpeechBubbleView: View {
    var text: String

    var body: some View {
        ZStack {
            SpeechBubble()
                .fill(Color(red: 214.0/255.0, green: 220.0/255.0, blue: 255.0/255.0))
                .frame(width: 350, height: 200)
            
            Text(text)
                .font(.body)
                .bold()
                .foregroundColor(.black)
                .padding(.bottom, 35)
        }
        .shadow(color: Color.black.opacity(0.3), radius: 10, x: 5, y: 5)
    }
}


struct ResultPage: View {
    @Binding var selectedAnimal: String
    @Binding var selectedPage: String
    
    @State private var isBubbleVisible = true
    @State private var showResetButton = false
    @State private var navigateToTranslator = false
    @State private var isSwapped = false
    
    @State private var humanText = ""
    @State private var petText = ""
    
    @ObservedObject var audioRecorder = AudioRecorder()
    
    let translatedText: String
    
    @State private var path = [String]()
    
    private var selectedPetImageName: String {
        switch selectedAnimal {
        case "Cat": return "cat"
        case "Dog": return "dog"
        default: return ""
        }
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                GradientBakground()
                VStack {
                    Text("Result")
                        .foregroundColor(.black)
                        .font(.largeTitle)
                        .bold()
                        .padding(.top, 40)
                    
                    Spacer()
                    
                    if isBubbleVisible {
                        SpeechBubbleView(text: translatedText)
                            .padding(.bottom, 20)
                            .onTapGesture {
                                withAnimation {
                                    isBubbleVisible = false
                                    showResetButton = true
                                }
                            }
                    }
                    
                    if showResetButton {
                        Button(action: {
                            selectedPage = "Translator"
                            path.append("TranslatorPagedView")
                        }) {
                            HStack {
                                Image("vector")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(Color.black)
                                
                                Text("Repeat")
                                    .font(.title3)
                                    .foregroundColor(.black)
                                    .padding(.leading, 8)
                            }
                            .padding()
                            .background(Color(red: 214.0/255.0, green: 220.0/255.0, blue: 255.0/255.0))
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 2, y: 2)
                        }
                    }
                    
                    Spacer()

                    Image(selectedPetImageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .padding(.bottom, 135)
                }
                .padding()
                Spacer()
            }
        }
    }
}
