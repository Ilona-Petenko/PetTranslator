import Foundation
import SwiftUI
import AVFoundation

public class AudioRecorder: ObservableObject {
    @Published var isRecording = false
    @Published var showPermissionDeniedAlert = false
    @Published var isRecordingFinished = false
    @Published var isProcessingTranslation = false
    @Published var translatedText: String?
    
    private var audioRecorder: AVAudioRecorder?
    private var recordedFileURL: URL?

    private let catTranslations = [
        "Purrfect! I’m feeling so cozy right now!",
        "Feed me, hooman! I’m starving!",
        "Excuse me, were my ears not clear enough? BACK OFF.",
        "AH! What was that noise?!",
        "Ooo, what’s this thing? Let me knock it off the table!"
    ]

    private let dogTranslations = [
        "OH MY DOG, YOU’RE HOME!",
        "I saw you open the fridge. I know there’s food in there.",
        "Who goes there?! I must protect my hooman!",
        "You’ve been gone for 5 minutes… that’s too long!",
        "I stole your sock. What are you gonna do about it?"
    ]

    private func getRandomTranslation(for animal: String) -> String {
        if animal == "Cat" {
            return catTranslations.randomElement() ?? "Meow?"
        } else if animal == "Dog" {
            return dogTranslations.randomElement() ?? "Woof?"
        }
        return "Unknown animal!"
    }

    func startRecording() {
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            DispatchQueue.main.async {
                if granted {
                    self.reset()
                    self.beginRecording()
                } else {
                    self.showPermissionDeniedAlert = true
                }
            }
        }
    }

    private func beginRecording() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
            try audioSession.setActive(true)

            let tempDir = FileManager.default.temporaryDirectory
            let fileURL = tempDir.appendingPathComponent("recording.m4a")
            recordedFileURL = fileURL

            let settings: [String: Any] = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 12000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]

            audioRecorder = try AVAudioRecorder(url: fileURL, settings: settings)
            audioRecorder?.record()
            isRecording = true
            isRecordingFinished = false
            isProcessingTranslation = false
        } catch {
            print("Failed to start recording: \(error.localizedDescription)")
        }
    }

    @MainActor func stopRecording(for animal: String, selectedPage: Binding<String>) {
        audioRecorder?.stop()
        isRecording = false
        isRecordingFinished = true
        processTranslation(for: animal, selectedPage: selectedPage)
    }

    @MainActor
    private func processTranslation(for animal: String, selectedPage: Binding<String>) {
        DispatchQueue.main.async {
            self.isProcessingTranslation = true
            self.objectWillChange.send()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.translatedText = self.getRandomTranslation(for: animal)
            self.isProcessingTranslation = false
            self.objectWillChange.send()

            selectedPage.wrappedValue = "Result"
        }
    }

    func reset() {
        isRecording = false
        isProcessingTranslation = false
        translatedText = nil
    }
}
