//
//  SpeechHelper.swift
//  FlickerApp
//
//  Created by Yogesh on 25/09/24.
//

import Foundation
import Speech

class SpeechRecognizer {
    private let mixerNode = AVAudioMixerNode()
    
    private var audioEngine = AVAudioEngine()
    private var recognitionTask: SFSpeechRecognitionTask?
    private var speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    private var recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
    
    func requestAuthorization() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            switch authStatus {
            case .authorized:
                print("Speech recognition authorized")
            case .denied, .restricted, .notDetermined:
                print("Speech recognition not authorized")
            @unknown default:
                print("Unknown speech recognition status")
            }
        }
    }
    
    func startListening(completion: @escaping (String?) -> Void) {
        recognitionTask?.cancel()
        recognitionTask = nil
        
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
//        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, when in
//            self.recognitionRequest.append(buffer)
//        }
        
        
        //Start
               
        if (inputNode.inputFormat(forBus: 0).channelCount == 0){
            print("*required condition is false: IsFormatSampleRateAndChannelCountValid(format)")
            return
        }
        
        inputNode.removeTap(onBus: 0)

//        // Configure the microphone input.
//        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
//                    //process buffer...
//                }
//        
//         inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, when in
//            self.recognitionRequest.append(buffer)
//        }
//        
//        //End
        
        audioEngine.prepare()
        try? audioEngine.start()
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            if let result = result {
                completion(result.bestTranscription.formattedString)
            } else if let error = error {
                print("Speech recognition error: \(error)")
                completion(nil)
            }
        }
    }
     
    
    func stopListening() {
        audioEngine.stop()
        recognitionRequest.endAudio()
        recognitionTask?.cancel()
        recognitionTask = nil
        audioEngine.inputNode.removeTap(onBus: 0)
    }
}
