//
//  HomeScreenModel.swift
//  iBeats
//
//  Created by Mukesh on 10/03/19.
//  Copyright © 2019 Mukesh. All rights reserved.
//

import UIKit

struct AlbumSearchModel: Codable {
    private enum CodingKeys: String, CodingKey {
        case results
    }
    let results: AlbumResults?
}

struct AlbumResults: Codable {
    private enum CodingKeys: String, CodingKey {
        case albummatches
    }
    
    let albummatches: Album?
}

struct Album: Codable {
    private enum CodingKeys: String, CodingKey {
        case album
    }

    let album: [AlbumDetail]?
}

struct AlbumDetail: Codable {
    private enum CodingKeys: String, CodingKey {
        case name
        case artist
        case url
        case image
    }

    let name: String?
    let artist: String?
    let url: String?
    let image: [CoverImage]?
}

struct CoverImage: Codable {
    private enum CodingKeys: String, CodingKey {
        case image = "#text"
        case size
    }
    
    let image: String?
    let size: String?
}
