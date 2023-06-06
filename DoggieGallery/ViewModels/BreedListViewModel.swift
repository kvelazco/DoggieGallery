//
//  BreedListViewModel.swift
//  DoggieGallery
//
//  Created by Kevin Velazco on 6/5/23.
//

import Foundation
import SwiftUI

class BreedListViewModel: ObservableObject {
    
    @Published var dogBreeds: [String] = []
    @Published var dogImages: [String: String] = [:]

    init() {
        fetchDogBreeds()
    }

    func fetchDogBreeds() {
        
        guard let url = URL(string: "https://dog.ceo/api/breeds/list/all") else {
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let breedsData = try JSONDecoder().decode(DogBreedResponse.self, from: data)
                let breeds = breedsData.message.flatMap { (key, value) -> [String] in
                    if value.isEmpty {
                        return [key]
                    } else {
                        return value.map { "\(key)/\($0)" }
                    }
                }
                DispatchQueue.main.async {
                    self.dogBreeds = breeds
                    self.fetchDogImages()
                }
            } catch {
                print("Error decoding dog list JSON: \(error.localizedDescription)")
            }
        }.resume()
    }

    func fetchDogImages() {
        
        let dispatchGroup = DispatchGroup()
        
        for breed in dogBreeds {
            
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
