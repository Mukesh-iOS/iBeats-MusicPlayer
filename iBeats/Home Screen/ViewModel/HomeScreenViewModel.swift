//
//  HomeScreenViewModel.swift
//  iBeats
//
//  Created by Mukesh on 10/03/19.
//  Copyright © 2019 Mukesh. All rights reserved.
//

import UIKit

class HomeScreenViewModel: NSObject {
    
    var albumDetails: Variable<AlbumSearchModel> = Variable<AlbumSearchModel>()
    
    func searchAlbum(name: String) {
        
        let params = NSMutableDictionary()
        params.setValue(name, forKey: "album")
        params.setValue(APIKey.lastFM.rawValue, forKey: "api_key")
        params.setValue("album.search", forKey: "method")
        params.setValue("json", forKey: "format")

        let searchURL = WebServiceRequest().loadQueryParams(params, toURL: URL(string: ServiceURL.baseURL)!)
        
        WebServiceRequest.fetchRequest(serviceURL: searchURL, resultStruct: AlbumSearchModel.self) { [weak self] (album) in
            guard let album = album as? AlbumSearchModel, let strongSelf = self else {
                return
            }
            strongSelf.albumDetails.value = album
        }
    }
}
