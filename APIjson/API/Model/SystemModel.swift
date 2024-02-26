//
//  SystemModel.swift
//  APIjson
//
//  Created by Umang Kedan on 25/02/24.
//

import UIKit

struct DogModel:Codable{
    var message:String?
    var status:String?
}

struct Numbers : Codable {
    var entries : [Entries]
}

struct Entries : Codable {
    var API : String
    var Description : String
    var Auth : String
    var HTTPS : Bool
    var Cors : String
    var Link : String
    var Category : String
}

class SystemModel: NSObject {

    func getApi(url : String , completionHandler : @escaping (_ is_succeding : Bool , _ data : Data , _ error : String?) -> ()) {
        
        let apiUrl = URL(string: url)
        var apiRequest = URLRequest(url: apiUrl!)
        apiRequest.httpMethod = "Get"
        apiRequest.timeoutInterval = 20
        
        let task = URLSession.shared.dataTask(with: apiRequest){ data , response , error in
            if error != nil {
                let empty = Data()
                completionHandler(false, empty, "error")
                return
            }
            
            guard response != nil else {
                return
            }
            
            if let data = data {
                completionHandler(true, data, "no erroor")
            }
            print(data)
        }
        task.resume()
    }
    
    func convertPublicData(url:String, completionHandler: @escaping(_ isSucceeded: Bool, _ data:[Entries]?, _ error: String?)->()) {
        getApi(url: url) { isSucceeded, data, error in
            if isSucceeded {
                do {
                    let decorder = JSONDecoder()
                    let usableData = try decorder.decode(Numbers.self, from: data)
                    let entriesData = usableData.entries
                    print(entriesData)
                    completionHandler(true, entriesData, "")
                } catch {
                    print(error.localizedDescription)
                }
            } else if let error = error {
                completionHandler(false, nil, "\(error)")
            }
        }
    }
    
    func convertDogModelData(url:String, completionHandler: @escaping(_ isSucceeded: Bool, _ data:UIImage?, _ error: String?)->()) {
        // Fetch API Data
        getApi(url: url) { isSucceeded, data, error in
            if isSucceeded {
                do {
                    let decorder = JSONDecoder()
                    let usableData = try decorder.decode(DogModel.self, from: data)
                    
        // we have Data and now use getApi Function to get Image from url
                    guard let imageUrl = usableData.message else {return}
                    self.getApi(url: imageUrl) { isSucceeded, data, error in
                        if isSucceeded {
                            if let image = UIImage(data: data) {
                                completionHandler(true, image, "")
                            }
                        } else if error != nil {
                            completionHandler(false, nil, "")
                        }
                    }
                    
                } catch {
                    print(error.localizedDescription)
                }
            } else if error != nil {
                completionHandler(false, nil, "failed to get Data from API \(error?.localizedCapitalized ?? "")")
            }
        }
    }
}

