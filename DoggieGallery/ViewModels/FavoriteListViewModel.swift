//
//  FavoriteListViewModel.swift
//  DoggieGallery
//
//  Created by Kevin Velazco on 6/6/23.
//

import Foundation
import SwiftUI

class FavoriteListViewModel: ObservableObject {
    
    static let shared = FavoriteListViewModel()
    @Published var favoriteBreeds: [String] = []
    @Published var dogImages: [String: String] = [:]
    
    init() {
        fetchFavorites()
    }
    
    func fetchFavorites() {
        if let favorites = UserDefaults.standard.array(forKey: "Favorites") as? [String] {
            favoriteBreeds = favorites
        }
        fetchDogImages()
    }
    
    func fetchDogImages() {
        
        let dispatchGroup = DispatchGroup()
        
        for breed in favoriteBreeds {
            
            dispatchGroup.enter()
            
            guard let url = URL(string: "https://dog.ceo/api/breed/\(breed)/images/random") else {
                dispatchGroup.leave()
                continue
            }

            URLSession.shared.dataTask(with: url) { data, _, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    dispatchGroup.leave()
                    return
                }

                guard let data = data else {
                    print("No data received")
                    dispatchGroup.leave()
                    return
                }

                do {
                    let image = try JSONDecoder().decode(DogImageResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.dogImages[breed] = image.message
                        dispatchGroup.leave()
                    }
                } catch {
                    print("Error decoding dog images JSON: \(error.localizedDescription)")
                }
            }.resume()
            
            print("fetchImage")
        }
        
        dispatchGroup.notify(queue: .main) {
            print("All images fetched")
        }
    }
}
