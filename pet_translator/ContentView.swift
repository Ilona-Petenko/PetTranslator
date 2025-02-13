import SwiftUI


struct ContentView: View {
    
    @State private var isSwapped = false
    @State private var humanText = "HUMAN"
    @State private var petText = "PET"
    @StateObject private var audioRecorder = AudioRecorder()
    @State private var selectedAnimal: String = "Cat"
    @State private var selectedPage: String = "Result"

    var body: some View {
        ZStack {
            if selectedPage == "Translator" {
                if audioRecorder.isProcessingTranslation {
                    ProcessingPage(selectedAnimal: $selectedAnimal, selectedPage: $selectedPage)
                } else {
                    TranslatorPage(
                        isSwapped: $isSwapped,
                        humanText: $humanText,
                        petText: $petText,
                        selectedPage: $selectedPage,
                        audioRecorder: audioRecorder,
                        selectedAnimal: $selectedAnimal
                    )
                }
            } else if selectedPage == "Result"{
                    ResultPage(
                        selectedAnimal: $selectedAnimal,
                        selectedPage: $selectedPage,
                        audioRecorder: audioRecorder, translatedText: audioRecorder.translatedText ?? "No translation available"
                    )
            }else if selectedPage == "Clicker" {
                SettingsPage(selectedPage: $selectedPage)
            }
        }
    }

}

#Preview {
    ContentView()
}
