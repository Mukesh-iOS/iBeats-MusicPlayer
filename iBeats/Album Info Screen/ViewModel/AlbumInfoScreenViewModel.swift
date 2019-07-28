//
//  AlbumInfoScreenViewModel.swift
//  iBeats
//
//  Created by Mukesh on 10/03/19.
//  Copyright © 2019 Mukesh. All rights reserved.
//

import UIKit

class AlbumInfoScreenViewModel: NSObject {
    
    var albumInfos: Variable<AlbumInfoModel> = Variable<AlbumInfoModel>()
    
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
                
                strongSelf.albumInfos.value = album
            }
        }
   }
    
    func checkIfAlbumAlreadyInserted(albumInfo: AlbumDetail) -> Bool {
        
        return iBDatabaseOperations.checkIfAlreadyInsertedWith(albumInfo: albumInfo)
    }
    
    func deleteAlbum(albumInfo: AlbumDetail) {
        
        iBDatabaseOperations.deleteAlbumWith(albumInfo: albumInfo)
    }
    
    func insertAlbumInfoIntoDB(albumInfo: AlbumDetail, isFromSearch: Bool) {
        
        let track = albumInfos.value?.album?.tracks?.track
        iBDatabaseOperations.insertDatasInDBWith(albumInfo: albumInfo, withTracks: track, isFromSearch: isFromSearch)
    }
    
    func getSavedAlbumTrackCount(albumInfo: AlbumDetail) -> Int {
        
        let trackFullDetail = iBDatabaseOperations.fetchSingleAlbumWith(albumInfo: albumInfo)
        return trackFullDetail?.tracks?.count ?? 0
    }
    
    func getAlbumTrackCount() -> Int {
        
        return albumInfos.value?.album?.tracks?.track?.count ?? 0
    }
    
    func fetchSingleAlbumInfoFromDB(albumInfo: AlbumDetail, index: Int) -> TrackInfo {
        
        let trackFullDetail = iBDatabaseOperations.fetchSingleAlbumWith(albumInfo: albumInfo)
        let trackInfo = TrackInfo.init(name: trackFullDetail?.tracks?[index], duration: trackFullDetail?.durations?[index])
        
        return trackInfo
    }
    
    func fetchSingleAlbumInfo(index: Int) -> TrackInfo? {
        
        return albumInfos.value?.album?.tracks?.track?[index]
    }
}
