//
//  AlbumInfoScreenModel.swift
//  iBeats
//
//  Created by Mukesh on 10/03/19.
//  Copyright © 2019 Mukesh. All rights reserved.
//


struct AlbumInfoModel: Codable {
    
    private enum CodingKeys: String, CodingKey {
        case album
    }
    let album: Tracks?
}

struct Tracks: Codable {
    
    private enum CodingKeys: String, CodingKey {
        case tracks
    }
    
    let tracks: Track?
}

struct Track: Codable {
    
    private enum CodingKeys: String, CodingKey {
        
        case track
    }
    
    let track: [TrackInfo]?
}

struct TrackInfo: Codable {
    
    private enum CodingKeys: String, CodingKey {
        
        case name
        case duration
    }
    
    let name: String?
    let duration: String?
}
