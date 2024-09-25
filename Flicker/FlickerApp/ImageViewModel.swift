//
//  ImageViewModel.swift
//  FlickerApp
//
//  Created by Yogesh on 25/09/24.
//

import Foundation
import Combine

class ImageViewModel: ObservableObject {
    @Published var items: [FlickrItem] = []
    private var cancellables = Set<AnyCancellable>()
    
    @Published var text: String = ""
    @Published var textChanged: Int = 0

    func fetchImages(searchString: String) {
        guard let url = URL(string: "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1&tags=\(searchString)") else { return }
        print("Searching \(searchString)")
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: FlickrResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching images: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] response in
                self?.items = response.items
            })
            .store(in: &cancellables)
    }
}
