//
//  AlbumInfoCell.swift
//  iBeats
//
//  Created by Mukesh on 10/03/19.
//  Copyright © 2019 Mukesh. All rights reserved.
//

import UIKit

class AlbumInfoCell: UITableViewCell {
    
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var duration: UILabel!
    
    func loadData(trackInfo: TrackInfo) {
        
        trackName.text = trackInfo.name ?? "Not available"
        
        let songDuration = trackInfo.duration ?? "0"
        let (m,s) = secondsToMinutesSeconds(seconds: Int(songDuration)!)
        let playDuration = "\(m)m \(s)s"
        
        duration.text = playDuration
    }
    
    private func secondsToMinutesSeconds (seconds: Int) -> (Int, Int) {
        return ((seconds % 3600) / 60, (seconds % 3600) % 60)
    }
}
