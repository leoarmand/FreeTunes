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
                fetchPlaylistsWithFallback()
            }
        }
    }
    
    func fetchPlaylistsWithFallback() {
        Task {
            var remotePlaylists: [Playlist] = []
            do {
                remotePlaylists = try await FreeboxAPI.fetchPlaylists()

                for playlist in remotePlaylists {
                    let folderURL = FileManager.default.temporaryDirectory.appendingPathComponent(playlist.name)
                    if !FileManager.default.fileExists(atPath: folderURL.path) {
                        try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
                    }
                }
            } catch {
                errorMessage = error.localizedDescription
            }
            playlists = loadPlaylists(remotePlaylists: remotePlaylists)
            isLoading = false
        }
    }

    func loadPlaylists(remotePlaylists: [Playlist]) -> [Playlist] {
        let tempDirectory = FileManager.default.temporaryDirectory

        guard let contents = try? FileManager.default.contentsOfDirectory(at: tempDirectory, includingPropertiesForKeys: nil) else {
            return []
        }

        let folders = contents.filter { $0.hasDirectoryPath && !$0.lastPathComponent.hasPrefix(".") }

        return folders.map { folderURL in
            let folderName = folderURL.lastPathComponent

            let matchingRemote = remotePlaylists.first { $0.name == folderName }

            return Playlist(
                name: folderName,
                boxPath: matchingRemote?.boxPath ?? "",
                localURLPath: folderURL.path
            )
        }
    }
}
