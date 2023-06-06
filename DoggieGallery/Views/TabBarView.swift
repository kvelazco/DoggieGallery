//
//  TabBarView.swift
//  DoggieGallery
//
//  Created by Kevin Velazco on 6/5/23.
//

import SwiftUI

struct TabBarView: View {
    
    //@StateObject var breedViewModel = BreedListViewModel()
    @State var selectedTab: Int = 0
    
    var body: some View {
        
        TabView(selection: $selectedTab) {
            
            BreedListView()
                .tabItem() {
                    Label("Breeds", systemImage: "pawprint")
                }
                .tag(0)
            FavoriteListView()
                .tabItem() {
                    Label("Favorites", systemImage: "heart")
                }
                .tag(1)
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
