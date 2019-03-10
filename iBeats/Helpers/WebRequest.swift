//
//  WebRequest.swift
//  GenericRest
//
//  Created by Mukesh on 10/03/19.
//  Copyright © 2019 Mukesh. All rights reserved.
//
import Foundation
import UIKit
import Alamofire
import SVProgressHUD

struct WebServiceRequest {
    
    static func fetchRequest<T>(serviceURL: URL?,
                                  resultStruct: T.Type,
                                  completionHandler:@escaping ((Any?) -> Void ))  where T: Decodable  {
        
        guard let url = serviceURL else {
            
            debugPrint("No url found")
            completionHandler(nil)
            return
        }
        
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.show()
        
        Alamofire.request(url,
                          method: .get,
                          parameters: nil)
            .validate()
            .responseJSON { response in
                
                SVProgressHUD.dismiss()
                guard response.result.isSuccess else {
                    debugPrint("Error while fetching details: \(String(describing: response.result.error))")
        
                    completionHandler(nil)
                    return
                }
                
                guard let value = response.result.value as? NSDictionary
                    else {
                        debugPrint("Error: Malformed data received")
                        
                        completionHandler(nil)
                        return
                }
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                    
                    let decoder = JSONDecoder()
                    
                    let resultantModel = try decoder.decode(resultStruct, from: jsonData)
                    completionHandler(resultantModel)

                } catch {
                    debugPrint(error.localizedDescription)
                }
            }
    }
    
    func loadQueryParams(_ params : NSMutableDictionary?, toURL url : URL) -> URL {
        
        var fullURL = url
        
        if  params != nil && (params?.count)! > 0 {
            
            var urlComponents = URLComponents(string: "\(fullURL)")
            
            var queryItems = [URLQueryItem]()
            
            for (key, value) in params! {
                let queryItem = URLQueryItem(name: key as! String, value: String(describing: value))
                queryItems.append(queryItem)
            }
            
            urlComponents?.queryItems = queryItems
            fullURL = (urlComponents?.url)!
        }
        
        return fullURL
    }
}
