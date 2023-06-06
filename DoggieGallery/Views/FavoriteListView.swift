//
//  FavoritesView.swift
//  DoggieGallery
//
//  Created by Kevin Velazco on 6/5/23.
//

import SwiftUI

struct FavoriteListView: View {
    
    @ObservedObject var favoriteViewModel = FavoriteListViewModel.shared
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(favoriteViewModel.favoriteBreeds.sorted(), id: \.self) { breed in
                    VStack {
                        NavigationLink(destination: BreedDetailView(breed: breed)) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(.systemGray6))
                                    .padding(.leading, 15)
                                    .padding(.trailing, 15)
                                
                                HStack(spacing: 50) {
                                    
                                    //Image
                                    if let imageURL = favoriteViewModel.dogImages[breed],
                                        let url = URL(string: imageURL) {
                                        loadImage(url: url)
                                        } else {
                                            ProgressView()
                                        }
                                    
                                    //Breed name
                                    parseBreedString(breed: breed)

                                }
                            }
                        }
                    }
                }
            } .navigationTitle("Favorites")
        }
    }
    
    func loadImage(url: URL) -> some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
            case .failure(_):
                imagePlaceHolder()
            @unknown default:
                ProgressView()
            }
        }
        .padding(.top, 5)
        .padding(.leading, 20)
        .padding(.bottom, 5)
        .padding(.trailing, 0)
    }
    
    func imagePlaceHolder() -> some View {
        Image(systemName: "photo")
            .aspectRatio(contentMode: .fit)
            .frame(width: 100, height: 100)
    }
    
    @ViewBuilder
    func parseBreedString(breed: String) -> some View {
        if breed.contains("/") {
            
            let separatedBreedNames = breed.components(separatedBy: "/")
            let mainBreed = separatedBreedNames[0]
            let subBreed = separatedBreedNames[1]
            
            VStack {
                Text("\(subBreed.capitalized)")
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                Text("\(mainBreed.capitalized)")
                    .foregroundColor(colorScheme == .dark ? .white : .black)
            }
            .padding(.leading, 0)
        } else {
            Text(breed.capitalized)
                .foregroundColor(colorScheme == .dark ? .white : .black)
                .padding(.leading, 0)
        }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteListView()
    }
}
