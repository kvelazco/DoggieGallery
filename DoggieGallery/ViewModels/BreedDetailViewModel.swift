//
//  BreedDetailViewModel.swift
//  DoggieGallery
//
//  Created by Kevin Velazco on 6/5/23.
//

import Foundation
import SwiftUI

class BreedDetailViewModel: ObservableObject {
    
    var breed = ""
    @Published var dogImages: [String] = []
    
    init(breed: String) {
        self.breed = breed
    }
    
    func fetchDogImages(breed: String) {
        
            guard let url = URL(string: "https://dog.ceo/api/breed/\(breed)/images/random/15") else {
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
                
                if let jsonString = String(data: data, encoding: .utf8) {
                                print("Received data: \(jsonString)")
                            }
                
                do {
                    let images = try JSONDecoder().decode(DogImageByBreedResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.dogImages = images.message
                        print(self.dogImages)
                    }
                } catch {
                    print("Error decoding images JSON in fetchDogImages(BreedetailView): \(error.localizedDescription)")
                }
            }.resume()
            
            print("fetchBreedSpecificImages")
    }
}
