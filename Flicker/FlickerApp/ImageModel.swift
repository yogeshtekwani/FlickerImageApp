//
//  ImageModel.swift
//  FlickerApp
//
//  Created by Yogesh on 25/09/24.
//

import Foundation

struct FlickrResponse: Codable {
    let items: [FlickrItem]
}

struct FlickrItem: Codable, Identifiable {
    let id = UUID() // Unique ID for SwiftUI to use in a list
    let title: String
    let media: FlickrMedia
}

struct FlickrMedia: Codable {
    let m: String // Image URL
}

