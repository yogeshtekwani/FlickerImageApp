//
//  ImageDetailView.swift
//  FlickerApp
//
//  Created by Yogesh on 25/09/24.
//

import SwiftUI
import Kingfisher

struct ImageDetailView: View {
    let item: FlickrItem
    
    @State private var currentScale: CGFloat = 1.0
    @State private var finalScale: CGFloat = 1.0
    
    var body: some View {
        VStack {
            VStack {
                AsyncImage(url: URL(string: item.media.m)) { image in
                    image
                        .resizable()
                        .frame(height: 500)
                    
                        .aspectRatio(contentMode: .fit)
                        .scaleEffect(currentScale * finalScale) // Apply the scaling
                        .gesture(
                            MagnificationGesture()
                                .onChanged { value in
                                    currentScale = value
                                }
                                .onEnded { value in
                                    finalScale *= currentScale
                                    currentScale = 1.0 // Reset current scale for next gesture
                                }
                        )
                        .gesture(
                            TapGesture(count: 2) // Double tap gesture
                                .onEnded {
                                    withAnimation {
                                        if finalScale > 1.0 {
                                            // Reset to original scale
                                            finalScale = 1.0
                                        } else {
                                            // Zoom in on double tap
                                            finalScale = 2.0
                                        }
                                    }
                                }
                        )
                        .animation(.easeInOut, value: finalScale)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } placeholder: {
                    ProgressView()
                }
            }
            
            Text(item.title)
                .font(.headline)
                .padding()
            
            Spacer()
        }
        .navigationBarTitle("Image Details", displayMode: .inline)
    }
}
