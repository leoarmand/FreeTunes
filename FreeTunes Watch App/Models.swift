//
//  Models.swift
//  FreeTunes
//
//  Created by Léo Armand on 29/04/2025.
//

import Foundation

struct Playlist: Identifiable, Hashable {
    var id: String { name }  // Le nom est unique donc on peut l’utiliser comme ID
    let name: String
    let path: String
}

struct Track: Identifiable, Hashable {
    var id: String { name }
    let name: String
    let path: String
}
