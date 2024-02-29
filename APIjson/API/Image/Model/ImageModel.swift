//
//  ImageModel.swift
//  APIjson
//
//  Created by Umang Kedan on 28/02/24.
//

import UIKit

struct ImageApi :Codable{
    var message:String?
    var status:String?
}

class ImageModel: NSObject {
    
    func convertDogModelData(url:String, completionHandler: @escaping(_ isSucceeded: Bool, _ data:ImageApi, _ error: String?)->()) {
        // Fetch API Data
        NetworkModel.connectWithServer(url: url, httpRequest: .GET) { isSucceeded, data, error in
            if isSucceeded {
                do {
                    let decorder = JSONDecoder()
                    let usableData = try decorder.decode(ImageApi.self, from: data!)
                    completionHandler(true, usableData, "")
                } catch {
                    print(error
                    )
                }
            }
        }
    }
}
