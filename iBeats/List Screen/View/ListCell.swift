//
//  ListCell.swift
//  iBeats
//
//  Created by Mukesh on 10/03/19.
//  Copyright © 2019 Mukesh. All rights reserved.
//

import UIKit

class ListCell: UITableViewCell {
    
    @IBOutlet weak var albumPic: UIImageView!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var albumName: UILabel!
    
    func loadDataWithModel(albumDetail: AlbumDetail) {
        albumName.text = "Album Name: \(albumDetail.name ?? "")"
        artistName.text = "Artist Name: \(albumDetail.artist ?? "")"
    }
}
