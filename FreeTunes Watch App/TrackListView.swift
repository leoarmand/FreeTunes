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
                let destination = FileManager.default.temporaryDirectory
                    .appendingPathComponent(playlist.name)
                    .appendingPathComponent(track.name)
                let fileExists = FileManager.default.fileExists(atPath: destination.path)

                if fileExists {
                    selectedTrack = track
                    playTrack(url: destination)
                } else {
                    FreeboxAPI.downloadTrack(track, destination: destination) { localURL in
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
                HStack {
                    Text(track.name.replacingOccurrences(of: ".mp3", with: ""))
                    Spacer()
                    let destination = FileManager.default.temporaryDirectory
                        .appendingPathComponent(playlist.name)
                        .appendingPathComponent(track.name)
                    let fileExists = FileManager.default.fileExists(atPath: destination.path)

                    Image(systemName: fileExists ? "checkmark.circle.fill" : "arrow.down.circle")
                        .foregroundColor(fileExists ? .green : .gray)
                }
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
            fetchLocalTracks()
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
    
    func fetchLocalTracks() {
        let localDirectory = FileManager.default.temporaryDirectory.appendingPathComponent(playlist.name)
        
        guard let contents = try? FileManager.default.contentsOfDirectory(at: localDirectory, includingPropertiesForKeys: nil) else {
            self.tracks = []
            return
        }

        let mp3Files = contents.filter { $0.pathExtension.lowercased() == "mp3" }

        let localTracks = mp3Files.map { fileURL -> Track in
            Track(
                name: fileURL.lastPathComponent,
                boxPath: "",
                isDownloaded: true
            )
        }

        self.tracks = localTracks
    }
}
