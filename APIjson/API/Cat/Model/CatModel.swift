//
//  CatModel.swift
//  APIjson
//
//  Created by Umang Kedan on 29/02/24.
//

import UIKit

struct CatFactModel: Codable {
    var fact: String?
    var length: Int?
}

class CatModel: NSObject {
    func getCatData(url: String, completionHandler: @escaping (_ isSucceeded: Bool, _ data: [CatFactModel]?, _ error: String?)->()) {
        NetworkModel.connectWithServer(url: url, httpRequest: .GET) { isSucceeded, data, error in
            if isSucceeded {
                do {
                    let decoder = JSONDecoder()
                    let usableData = try decoder.decode(CatFactModel.self, from: data!)
                    completionHandler(true, [usableData], nil)
                } catch {
                    completionHandler(false, nil, error.localizedDescription)
                }
            } else {
                completionHandler(false, nil, error)
            }
        }
    }
}
