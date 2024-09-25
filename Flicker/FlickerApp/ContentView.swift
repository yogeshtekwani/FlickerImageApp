//
//  ContentView.swift
//  FlickerApp
//
//  Created by Yogesh on 25/09/24.
//

import SwiftUI
import Speech

struct ContentView: View {
    @StateObject private var viewModel = ImageViewModel()

    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
   // @State private var searchText: String = ""
       @State private var isListening = false
       private let speechRecognizer = SpeechRecognizer()

    var body: some View {
        NavigationView {

            ScrollView {
                
                HStack {
                    // Search Bar
                    TextField("Search...", text: $viewModel.text) // $searchText
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .onReceive(
                            viewModel.$text
                                .debounce(for: .seconds(2), scheduler: DispatchQueue.main)
                        ) {
                            guard !$0.isEmpty else { return }
                            print(">> searching for: \($0)")
                            viewModel.fetchImages(searchString: "\($0)")
                        }
                    
                    // Microphone Button
                    Button(action: {
                        if isListening {
                            speechRecognizer.stopListening()
                            isListening = false
                        } else {
                            startListening()
                        }
                    }) {
                        Image(systemName: isListening ? "mic.fill" : "mic")
                            .font(.system(size: 24))
                            .foregroundColor(.blue)
                    }
                    .padding(.leading, 10)
                }
                .padding()
                
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(viewModel.items) { item in
                        NavigationLink(destination: ImageDetailView(item: item)) {
                            VStack {
                                AsyncImage(url: URL(string: item.media.m)) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 150)
                                } placeholder: {
                                    ProgressView()
                                }
                                Text(item.title)
                                    .font(.caption)
                                    .lineLimit(2)
                                    .padding(.top, 5)
                            }
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Image Grid")
        }
        .onAppear {
            viewModel.fetchImages(searchString: "")
            speechRecognizer.requestAuthorization()
        }
    }
    
    // Starts the speech recognition process
    func startListening() {
        isListening = true
        speechRecognizer.startListening { result in
            if let recognizedText = result {
                viewModel.text = recognizedText
            }
            isListening = false
        }
    }
}


#Preview {
    ContentView()
}

