//
//  AlbumInfoScreenVC.swift
//  iBeats
//
//  Created by Mukesh on 10/03/19.
//  Copyright © 2019 Mukesh. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

private enum AlbumInfoScreenStrings: String {
    case albumInfoCell = "AlbumInfoCell"
    case noTracksAvailable = "Sorry!! No tracks available"
}

private enum AlbumInfoScreenConstants: Int {
    case trackCellHeight = 80
}

class AlbumInfoScreenVC: UIViewController {
    
    var albumDetail: AlbumDetail?
    var isFromSearch: Bool?
    private var albumInfoVM : AlbumInfoScreenViewModel?
    
    static let identifier = "AlbumInfoScreenVC"
    
    @IBOutlet weak var infoTable: UITableView!
    @IBOutlet weak var albumCover: UIImageView!
    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var rightBarBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    // MARK: Setup View
    
    private func viewSetup() {

        albumInfoVM = AlbumInfoScreenViewModel()
        
        guard let albumDetails = albumDetail, let albumInfoVM = albumInfoVM else {
            
            return
        }
        
        albumInfoVM.albumInfos.notify(notifier: { [weak self] (info) in
            
            self?.updateScreen()
        })
        
        let isAlreadySavedAlbum = albumInfoVM.checkIfAlbumAlreadyInserted(albumInfo: albumDetails)
        
        rightBarBtn.image = isAlreadySavedAlbum ? UIImage(named: "Delete") : UIImage(named: "Download")
        
        albumCover.image = UIImage(named: "PlaceholderImage")

        if let isFromSearchType = isFromSearch, let imageURL = (isFromSearchType ? albumDetail?.image?[2].image : albumDetail?.image?[0].image) {
            
            // Download image in background
            DispatchQueue.global(qos: .background).async {
                
                Alamofire.request(imageURL).responseImage { [weak self] response in
                    
                    if let image = response.result.value, let strongSelf = self {
                        // Update image in main thread
                        DispatchQueue.main.async {
                            strongSelf.albumCover.image = image
                        }
                    }
                }
            }
        }
        
        albumName.text = "Album Name: \(albumDetail?.name ?? "")"
        artistName.text = "Artist Name: \(albumDetail?.artist ?? "")"
        
        // Search tracks for the album
        if isAlreadySavedAlbum {
            updateScreen()
        } else {
            albumInfoVM.searchAlbumInfo(album: albumDetail?.name ?? "", artist: albumDetail?.artist ?? "")
        }
    }
    
    func updateScreen() {
        
        infoTable.reloadData()
    }
    
    // MARK: Button Actions
    
    @IBAction func backBtnTapped(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveDeleteBtnTapped(_ sender: Any) {
        
        rightBarBtn.image = rightBarBtn.image == UIImage(named: "Delete") ?  UIImage(named: "Download") : UIImage(named: "Delete")
        
        guard let albumDetails = albumDetail else {
            
            return
        }
        
        if (rightBarBtn.image == UIImage(named: "Download")) {
            
            albumInfoVM?.deleteAlbum(albumInfo: albumDetails)
        } else {
            
            guard let isFromSearchType = isFromSearch else {
                
                return
            }
            
            albumInfoVM?.insertAlbumInfoIntoDB(albumInfo: albumDetails, isFromSearch: isFromSearchType)
        }
    }
}

// MARK: Tableview Delegates & Datasource

extension AlbumInfoScreenVC: UITableViewDelegate, UITableViewDataSource {
    
    private func calculateTrackCount() -> Int{
        
        guard let albumDetails = albumDetail, let albumInfoVM = albumInfoVM else {
            
            return 0
        }
        
        let isAlreadySavedAlbum = albumInfoVM.checkIfAlbumAlreadyInserted(albumInfo: albumDetails)
        
        let trackCount = isAlreadySavedAlbum ? albumInfoVM.getSavedAlbumTrackCount(albumInfo: albumDetails) : albumInfoVM.getAlbumTrackCount()

        return trackCount
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return CGFloat(AlbumInfoScreenConstants.trackCellHeight.rawValue)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return calculateTrackCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AlbumInfoScreenStrings.albumInfoCell.rawValue) as? AlbumInfoCell, let albumDetail = albumDetail, let albumInfoVM = albumInfoVM else {
            
            return UITableViewCell()
        }
        
        let isAlreadySavedAlbum = albumInfoVM.checkIfAlbumAlreadyInserted(albumInfo: albumDetail)
        
        if isAlreadySavedAlbum {
            
            let trackInfo = albumInfoVM.fetchSingleAlbumInfoFromDB(albumInfo: albumDetail, index: indexPath.row)
            cell.loadData(trackInfo: trackInfo)
        }
        else {
            if let trackInfo = albumInfoVM.fetchSingleAlbumInfo(index: indexPath.row) {
               
                cell.loadData(trackInfo: trackInfo)
            }
        }
        return cell
    }
    
    // Show empty message when no track from album is available
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        if calculateTrackCount() > 0 {
            tableView.separatorStyle = .singleLine
            numOfSections            = 1
            tableView.backgroundView = nil
        }
        else {
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = AlbumInfoScreenStrings.noTracksAvailable.rawValue
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }
        return numOfSections
    }
}
