//
//  AlbumInfoScreenViewModel.swift
//  iBeats
//
//  Created by Mukesh on 10/03/19.
//  Copyright © 2019 Mukesh. All rights reserved.
//

import UIKit

protocol AlbumInfoScreenNotification: class {
    
    func updateScreen()
}

class AlbumInfoScreenViewModel: NSObject {
    
    var albumInfos: AlbumInfoModel?
    var delegate: AlbumInfoScreenNotification?
    
    func searchAlbumInfo(album: String, artist: String) {
        
        let params = NSMutableDictionary()
        params.setValue(album, forKey: "album")
        params.setValue(artist, forKey: "artist")
        params.setValue(APIKey.lastFM.rawValue, forKey: "api_key")
        params.setValue("album.getinfo", forKey: "method")
        params.setValue("json", forKey: "format")
        
        let searchURL: URL = WebServiceRequest().loadQueryParams(params, toURL: URL(string: ServiceURL.baseURL)!)
        
        WebServiceRequest.fetchRequest(serviceURL: searchURL, resultStruct: AlbumInfoModel.self) { [weak self] (albumInfo) in
            
            if let strongSelf = self, let album = albumInfo as? AlbumInfoModel {
                
                strongSelf.albumInfos = album
                strongSelf.delegate?.updateScreen()
            }
        }
   }
}
