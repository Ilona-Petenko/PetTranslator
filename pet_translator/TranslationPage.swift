//
//  TranslationPage.swift
//  pet_translator
//
//  Created by ilona petenko on 11.02.2025.
//

import Foundation
import SwiftUI
    

struct TranslatorPage: View {
    @Binding var isSwapped: Bool
    @Binding var humanText: String
    @Binding var petText: String
    @Binding var selectedPage: String
    @ObservedObject var audioRecorder: AudioRecorder
    @Binding var selectedAnimal: String
    
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
                Text("Translator")
                    .foregroundColor(.black)
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 50)
                
                HStack {
                    Text(humanText)
                        .font(.title2)
                        .bold()
                        .foregroundColor(.black)
                        .padding()
                        .frame(maxWidth: .infinity)
                    
                    Button(action: {
                        DispatchQueue.main.async {
                            isSwapped.toggle()
                            humanText = isSwapped ? "PET" : "HUMAN"
                            petText = isSwapped ? "HUMAN" : "PET"
                        }
                    }) {
                        Image("arrow-swap-horizontal")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.black)
                    }
                    
                    Text(petText)
                        .font(.title2)
                        .foregroundColor(.black)
                        .bold()
                        .padding()
                        .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
                
                HStack {
                    Button(action: {
                        if audioRecorder.isRecording {
                            audioRecorder.stopRecording(for: selectedAnimal, selectedPage: $selectedPage)
                        } else {
                            audioRecorder.translatedText = nil
                            audioRecorder.isProcessingTranslation = false
                            audioRecorder.startRecording()
                        }
                    }) {
                        VStack {
                            ZStack {
                                Color.clear.frame(width: 160, height: 95)
                                
                                if audioRecorder.isRecording {
                                    GifView(gifName: "animation")
                                } else {
                                    Image("microphone-2")
                                        .resizable()
                                        .frame(width: 70, height: 70)
                                }
                            }
                            
                            Text(audioRecorder.isRecording ? "Recording..." : "Start Speak")
                                .font(.body)
                                .foregroundColor(.black)
                        }
                        .frame(width: 200, height: 170)
                        .padding(20)
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.3), radius: 10, x: 5, y: 5)
                    }
                    
                    VStack {
                        Button(action: { selectedAnimal = "Cat" }) {
                            Image("cat")
                                .resizable()
                                .frame(width: 50, height: 50)
                        }
                        .blur(radius: selectedAnimal == "Cat" ? 0 : 1)
                        .padding(20)
                        .background(Color(red: 209.0/255.0, green: 231.0/255.0, blue: 252.0/255.0))
                        .cornerRadius(12)
                        
                        Button(action: { selectedAnimal = "Dog" }) {
                            Image("dog")
                                .resizable()
                                .frame(width: 50, height: 50)
                        }
                        .blur(radius: selectedAnimal == "Dog" ? 0 : 1)
                        .padding(20)
                        .background(Color(red: 236.0/255.0, green: 251.0/255.0, blue: 199.0/255.0))
                        .cornerRadius(12)
                    }
                    .padding(10)
                    .background(Color.white)
                    .cornerRadius(12)
                }
                .padding(.top, 40)
                
                Spacer()
                
                Image(selectedPetImageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .padding(.bottom, 60)
                
                BottomBar(selectedPage: $selectedPage)
                    .padding(.bottom, 10)
                
            }
            .onAppear {
                if humanText.isEmpty {
                    humanText = "HUMAN"
                    petText = "PET"
                }
                
            }
            .alert(isPresented: $audioRecorder.showPermissionDeniedAlert) {
                Alert(
                    title: Text("Enable Microphone Access"),
                    message: Text("Please allow access to your microphone to use the app’s features."),
                    primaryButton: .default(Text("Settings")) {
                        if let appSettingsUrl = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(appSettingsUrl)
                        }
                    },
                    secondaryButton: .cancel(Text("Cancel"))
                )
            }
        }
    }
}
