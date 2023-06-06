//
//  BreedsView.swift
//  DoggieGallery
//
//  Created by Kevin Velazco on 6/5/23.
//

import SwiftUI

struct BreedListView: View {
    
    @StateObject var breedViewModel = BreedListViewModel()
    @ObservedObject var favoriteViewModel = FavoriteListViewModel.shared
    @Environment(\.colorScheme) var colorScheme
    @State var savedBreeds: Set<String> = Set<String>()
    @State var isButtonPressed: [String: Bool] = [:]
    
    var body: some View {
    
        NavigationView {
            ScrollView {
                ForEach(breedViewModel.dogBreeds.sorted(), id: \.self) { breed in
                    VStack {
                        NavigationLink(destination: BreedDetailView(breed: breed)) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(.systemGray6))
                                    .padding(.leading, 15)
                                    .padding(.trailing, 15)
                                
                                HStack(spacing: 10) {
                                    
                                    //Image
                                    if let imageURL = breedViewModel.dogImages[breed],
                                        let url = URL(string: imageURL) {
                                        loadImage(url: url)
                                        } else {
                                            ProgressView()
                                        }
                                    
                                    //Breed name
                                    parseBreedString(breed: breed)
                                        
                                    Spacer()
                                    //Favorite button
                                    Button(action: {
                                        isButtonPressed[breed] = true
                                        let pressedBreeds = isButtonPressed.filter { $0.value }.map { $0.key }
                                        savedBreeds = Set(pressedBreeds)
                                        UserDefaults.standard.set(Array(savedBreeds), forKey: "Favorites")
                                        favoriteViewModel.fetchFavorites()
                                    }) {
                                        Image(systemName: isButtonPressed[breed, default: false] ? "star.fill" : "star")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 30, height: 30)
                                            .foregroundColor(.yellow)
                                            .padding(.trailing, 25)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Breeds")
            .onAppear {
                fetchButtonStates()
            }
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
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 75, height: 75)
            .foregroundColor(.gray)
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
    
    func fetchButtonStates() {
        if let favorites = UserDefaults.standard.array(forKey: "Favorites") as? [String] {
            isButtonPressed = Dictionary(uniqueKeysWithValues: favorites.map { ($0, true) })
        }
    }
}

struct BreedsView_Previews: PreviewProvider {
    static var previews: some View {
        BreedListView()
    }
}
