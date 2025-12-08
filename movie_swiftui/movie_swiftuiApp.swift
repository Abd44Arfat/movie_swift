//
//  movie_swiftuiApp.swift
//  movie_swiftui
//
//  Created by Abdelrahman Arfat on 03/12/2025.
//

import SwiftUI

@main
struct movie_swiftuiApp: App {
    @StateObject private var homeViewModel = HomeViewModel()
    @StateObject private var favoritesManager = FavoritesManager.shared
    @StateObject private var bookingManager = BookingManager.shared
    @StateObject private var authManager = AuthManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(homeViewModel)
                .environmentObject(favoritesManager)
                .environmentObject(bookingManager)
                .environmentObject(authManager)
        }
    }
}
