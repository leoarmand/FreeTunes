//
//  TrackListView.swift
//  FreeTunes
//
//  Created by Léo Armand on 29/04/2025.
//


import SwiftUI
import AVFoundation
import Network

struct TrackListView: View {
    var playlist: Playlist
    @State private var tracks: [Track] = []
    @State private var selectedTrack: Track?
    @State private var localTrackURLs: [String: URL] = [:]
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var audioPlayer: AVAudioPlayer?

    var body: some View {
        List(tracks, id: \.id) { track in
            Button(action: {
                if let localURL = localTrackURLs[track.name] {
                    selectedTrack = track
                    playTrack(url: localURL)
                } else {
                    FreeboxAPI.downloadTrack(track) { localURL in
                        if let localURL = localURL {
                            DispatchQueue.main.async {
                                localTrackURLs[track.id] = localURL
                                selectedTrack = track
                                playTrack(url: localURL)
                            }
                        } else {
                            alertMessage = "Échec du téléchargement de \(track.name)"
                            showAlert = true
                        }
                    }
                }
            }) {
                Text(track.name.replacingOccurrences(of: ".mp3", with: ""))
            }
        }
        .navigationTitle(playlist.name)
        .onAppear {
            loadTracks()
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Erreur"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }

    func loadTracks() {
        do {
            showAlert = false
            try FreeboxAPI.fetchTracks(in: playlist) { fetchedTracks in
                DispatchQueue.main.async {
                    self.tracks = fetchedTracks
                }
            }
        } catch {
            alertMessage = "Pas de connexion Internet"
            showAlert = true
        }
    }

    func playTrack(url: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            alertMessage = "Erreur lors de la lecture du fichier"
            showAlert = true
        }
    }
}
