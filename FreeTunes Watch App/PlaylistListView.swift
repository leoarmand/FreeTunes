//
//  PlaylistListView.swift
//  FreeTunes
//
//  Created by Léo Armand on 29/04/2025.
//


import SwiftUI

struct PlaylistListView: View {
    @State private var playlists: [Playlist] = []
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            List(playlists, id: \.id) { playlist in
                NavigationLink(destination: TrackListView(playlist: playlist)) {
                    Text(playlist.name)
                }
            }
            .navigationTitle("Playlists")
            .onAppear {
                loadPlaylists()
            }
            //.alert(item: $errorMessage) { error in
            //    Alert(title: Text("Erreur"), message: Text(error), dismissButton: .default(Text("OK")))
            //}
        }
    }

    private func loadPlaylists() {
        isLoading = true
        Task {
            do {
                playlists = try await FreeboxAPI.fetchPlaylists()
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
}
