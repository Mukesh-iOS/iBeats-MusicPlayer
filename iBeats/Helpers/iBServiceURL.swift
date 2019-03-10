//
//  iBServiceURL.swift
//  iBeats
//
//  Created by Mukesh on 10/03/19.
//  Copyright © 2019 Mukesh. All rights reserved.
//

import UIKit

enum APIKey: String {
    
    case lastFM = "15ab8c32f905c1c006b90ab32ca46b82"
}

class ServiceURL: NSObject {
    
     static  let baseURL : String = {
        
        return "http://ws.audioscrobbler.com/2.0/"
    }()
}
