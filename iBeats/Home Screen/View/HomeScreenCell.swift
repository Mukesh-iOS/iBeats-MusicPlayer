//
//  HomeScreenCell.swift
//  iBeats
//
//  Created by Mukesh on 10/03/19.
//  Copyright © 2019 Mukesh. All rights reserved.
//

import UIKit

class HomeScreenCell: UICollectionViewCell {
    
    @IBOutlet weak var albumCover: UIImageView!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var deleteAlbumBtn: UIButton!
    @IBOutlet weak var tappableView: UIView!
    
    func loadDataWith(albumInfo: AlbumInfo) {
        
        artistName.text = albumInfo.artistName ?? ""
        deleteAlbumBtn.setImage(UIImage(named: "Delete"), for: .normal)
    }
}
