//
//  BreedDetailView.swift
//  DoggieGallery
//
//  Created by Kevin Velazco on 6/5/23.
//

import SwiftUI

struct BreedDetailView: View {
    
    let breed: String
    @StateObject var breedDetailViewModel = BreedDetailViewModel(breed: "")
    @Environment(\.colorScheme) var colorScheme
    
    let gridLayout = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: gridLayout, spacing: 16) {
                    ForEach(breedDetailViewModel.dogImages, id: \.self) { dogImageURL in
                        if let imageURL = dogImageURL, let url = URL(string: imageURL) {
                            loadImage(url: url)
                        } else {
                            ProgressView()
                        }
                    }
                }
            }
            .padding(.top, 16)
            .padding(.bottom, 16)
            .background(backgroundViewColor())
        }
        .onAppear() {
            breedDetailViewModel.fetchDogImages(breed: breed)
        }
        .navigationBarTitle(breed.contains("/") ? separateString() : breed.capitalized)
    }
    
    func loadImage(url: URL) -> some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
            case .failure(_):
                Text("Image not available")
                    .foregroundColor(.black)
            @unknown default:
                ProgressView()
            }
        }
    }
    
    func separateString() -> String {
        let separatedBreedNames = breed.components(separatedBy: "/")
        let mainBreed = separatedBreedNames[0].capitalized
        let subBreed = separatedBreedNames[1].capitalized
        let modifiedString = "\(subBreed) \(mainBreed)"

        return modifiedString
    }
    
    func backgroundViewColor() -> some View {
        switch breed {
        case "whippet":
            return Color.pink
        case "greyhound/italian":
            return Color.purple
        default:
            return colorScheme == .dark ? Color.black : Color.white
        }
    }
}

struct BreedDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BreedDetailView(breed: "chihuaha")
    }
}
