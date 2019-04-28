//
//  ListScreenVC.swift
//  iBeats
//
//  Created by Mukesh on 10/03/19.
//  Copyright © 2019 Mukesh. All rights reserved.
//

import UIKit
import Alamofire

private enum ListScreenConstants : Int{
    case numberOfSections = 1
    case largeSizeImage = 2
}

private enum ListScreenStrings: String{
    case listCell = "ListCell"
    case albumInfoScreenIdentifier = "AlbumInfoScreenVC"
    case noAlbumAvailable = "Sorry!! No albums available"
}

class ListScreenVC: UIViewController {
    
    @IBOutlet weak var listTable: UITableView!

    var albumDetails: AlbumSearchModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listTable.reloadData()
        
        // Navigation bar setup
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.backgroundColor = UIColor.black
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: Tableview Delegates & Datasource

extension ListScreenVC: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let albumCount = albumDetails?.results?.albummatches?.album?.count
        return albumCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListScreenStrings.listCell.rawValue) as? ListCell else {
            return UITableViewCell()
        }
        
        cell.albumPic.image = UIImage.init(named: "PlaceholderImage")
        
        // Load cell with datas
        
        let detail = albumDetails?.results?.albummatches?.album
        
        if let albumDetail = detail?[indexPath.row] {
            
            cell.loadDataWithModel(albumDetail: albumDetail)
            if let imageURL = albumDetail.image?[ListScreenConstants.largeSizeImage.rawValue].image {
                
                // Download image in background
                DispatchQueue.global(qos: .background).async {
                    
                    Alamofire.request(imageURL).responseImage { response in
                        
                        if let image = response.result.value {
                            // Update image in main thread
                            DispatchQueue.main.async {
                                cell.albumPic.image = image
                            }
                        }
                    }
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Preparing data to pass
        
        let detail = albumDetails?.results?.albummatches?.album

        guard let albumInfoScreenVC = storyboard?.instantiateViewController(withIdentifier: ListScreenStrings.albumInfoScreenIdentifier.rawValue) as? AlbumInfoScreenVC, let albumDetail = detail?[indexPath.row] else {
            return
        }
        albumInfoScreenVC.albumDetail = albumDetail
        albumInfoScreenVC.isFromSearch = true
        
        // Navigate to Album info screen
        self.navigationController?.pushViewController(albumInfoScreenVC, animated: true)
    }
    
    // Show empty message when no album from search is available
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        if albumDetails?.results?.albummatches?.album?.count ?? 0 > 0 {
            tableView.separatorStyle = .singleLine
            numOfSections            = ListScreenConstants.numberOfSections.rawValue
            tableView.backgroundView = nil
        }
        else {
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = ListScreenStrings.noAlbumAvailable.rawValue
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }
        return numOfSections
    }
}
