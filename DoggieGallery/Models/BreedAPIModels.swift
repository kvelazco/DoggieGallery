//
//  BreedAPIModels.swift
//  DoggieGallery
//
//  Created by Kevin Velazco on 6/5/23.
//

import Foundation

struct DogBreedResponse: Decodable {
    let message: [String:[String]]
}

struct DogImageResponse: Decodable {
    let message: String
}

struct DogImageByBreedResponse: Decodable {
    let message: [String]
}
