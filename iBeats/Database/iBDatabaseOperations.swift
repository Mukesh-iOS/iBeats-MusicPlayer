//
//  iBDatabaseOperations.swift
//  iBeats
//
//  Created by Mukesh on 10/03/19.
//  Copyright © 2019 Mukesh. All rights reserved.
//

import UIKit
import CoreData

class iBDatabaseOperations: NSObject {

    // MARK: Saving Context
    
    private func saveContext() {
        let context = iBDatabaseManager.sharedInstance.managedObjectContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
  }
    
    // MARK: Check for Duplicates
    
    class func checkIfAlreadyInsertedWith(albumInfo: AlbumDetail) -> Bool {

        let managedContext = iBDatabaseManager.sharedInstance.managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AlbumInfo")
    
        let artistName = NSPredicate(format: "albumName = %@", albumInfo.name ?? "")
        let albumName = NSPredicate(format: "artistName = %@", albumInfo.artist ?? "")
        let fetchPredicate = NSCompoundPredicate(type: .and, subpredicates: [artistName, albumName])
        fetchRequest.predicate = fetchPredicate
        
        do {
            if let result = try managedContext.fetch(fetchRequest) as? [AlbumInfo] , result.count > 0{
                
                return true
            }
        }
        catch let error as NSError {
            debugPrint(error.localizedDescription)
        }
        
        return false
    }
    
    class func fetchSingleAlbumWith(albumInfo: AlbumDetail) -> AlbumInfo? {
        
        let managedContext = iBDatabaseManager.sharedInstance.managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AlbumInfo")
        
        let artistName = NSPredicate(format: "albumName = %@", albumInfo.name ?? "")
        let albumName = NSPredicate(format: "artistName = %@", albumInfo.artist ?? "")
        let fetchPredicate = NSCompoundPredicate(type: .and, subpredicates: [artistName, albumName])
        fetchRequest.predicate = fetchPredicate
        
        do {
            if let result = try managedContext.fetch(fetchRequest) as? [AlbumInfo] , result.count == 1 {
                
                return result[0]
            }
        }
        catch let error as NSError {
            debugPrint(error.localizedDescription)
        }
        
        return nil
    }
    
    // MARK: Inserting Data into DB
    
    class func insertDatasInDBWith(albumInfo: AlbumDetail, withTracks: [TrackInfo]?, isFromSearch: Bool) {
        var tracks = [String]()
        var durations = [String]()
        
        if withTracks?.count ?? 0  > 0 {
            for (_, element) in withTracks!.enumerated()
            {
                tracks.append(element.name ?? "")
                durations.append(element.duration ?? "")
            }
        }
        
        let managedContext = iBDatabaseManager.sharedInstance.managedObjectContext
        
        let entity = NSEntityDescription.entity(forEntityName: "AlbumInfo", in: managedContext)!
        let albumInfos = AlbumInfo(entity: entity, insertInto: managedContext)
        albumInfos.albumName = albumInfo.name
        albumInfos.artistName = albumInfo.artist
        albumInfos.tracks = tracks
        albumInfos.durations = durations
        
        let coverImageURL = isFromSearch ? albumInfo.image?[2].image : albumInfo.image?[0].image
        albumInfos.coverPicURL = coverImageURL
        
        iBDatabaseOperations().saveContext()
    }
    
    // MARK: Deleting data from DB
    
    class func deleteAlbumWith(albumInfo: AlbumDetail) {
        let managedContext = iBDatabaseManager.sharedInstance.managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AlbumInfo")
        
        let artistName = NSPredicate(format: "albumName = %@", albumInfo.name ?? "")
        let albumName = NSPredicate(format: "artistName = %@", albumInfo.artist ?? "")
        let fetchPredicate = NSCompoundPredicate(type: .and, subpredicates: [artistName, albumName])
        fetchRequest.predicate = fetchPredicate
        
        do {
            if let result = try managedContext.fetch(fetchRequest) as? [AlbumInfo] , result.count > 0 {
                
                for object in result {
                    managedContext.delete(object)
                }
            }
        }
        catch let error as NSError {
            debugPrint(error.localizedDescription)
        }
    
        iBDatabaseOperations().saveContext()
    }
    
    // MARK: Get all Album Details
    
    class func getAlbumDetails() -> [AlbumInfo]? {
        let managedContext = iBDatabaseManager.sharedInstance.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AlbumInfo")
        do {
            if let fetchResults = try  managedContext.fetch(fetchRequest) as? [AlbumInfo] , fetchResults.count > 0 {
                return fetchResults
            }
        }
        catch let error as NSError {
            debugPrint(error.localizedDescription)
        }
        return nil
    }
}
