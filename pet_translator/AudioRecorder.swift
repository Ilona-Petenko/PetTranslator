import Foundation
import SwiftUI
import AVFoundation
import Speech


public class AudioRecorder: ObservableObject {
    @Published var isRecording = false
    @Published var showPermissionDeniedAlert = false
    @Published var isRecordingFinished = false
    @Published var isProcessingTranslation = false
    @Published var translatedText: String?
    
    private var audioRecorder: AVAudioRecorder?
    private var recordedFileURL: URL?


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
        guard let fileURL = recordedFileURL else {
            translatedText = "No file found"
            selectedPage.wrappedValue = "Result"
            return
        }

        isProcessingTranslation = true
        transcribeAudioFile(at: fileURL) { [weak self] transcription in
            DispatchQueue.main.async {
                if let transcription = transcription {
                    self?.translatedText = transcription
                } else {
                    self?.translatedText = "Transcription failed"
                }
                self?.isProcessingTranslation = false
                selectedPage.wrappedValue = "Result"
            }
        }
    }

    func reset() {
        isRecording = false
        isProcessingTranslation = false
        translatedText = nil
    }
    
    func transcribeAudioFile(at url: URL, completion: @escaping (String?) -> Void) {
        let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
        guard let recognizer = recognizer, recognizer.isAvailable else {
            completion("Speech recognizer not available")
            return
        }

        let request = SFSpeechURLRecognitionRequest(url: url)

        recognizer.recognitionTask(with: request) { result, error in
            if let error = error {
                print("Transcription error: \(error.localizedDescription)")
                completion("Error: \(error.localizedDescription)")
            } else if let result = result {
                if result.isFinal {
                    completion(result.bestTranscription.formattedString)
                }
            }
        }
    }
}
