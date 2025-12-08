//
//  ContentView.swift
//  movie_swiftui
//
//  Created by Abdelrahman Arfat on 03/12/2025.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        ZStack {
            MainTabView()
            
            SnackbarView(
                isShowing: $authManager.showSnackbar,
                message: authManager.snackbarMessage,
                type: authManager.snackbarType
            )
        }
    }
}

#Preview {
    ContentView()
}
