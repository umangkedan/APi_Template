//
//  SystemModel.swift
//  APIjson
//
//  Created by Umang Kedan on 25/02/24.
//

import UIKit



enum httpRequest  : String{
    case GET
    case POST
    case DELETE
    case PUT
}

struct Product:Codable {
    var products:[APIProduct]
}

struct APIProduct: Codable {
    var id : Int?
    var title : String?
    var description : String?
    var price : Int?
    var discountPercentage : Float?
    var rating : Float?
    var stock : Int?
    var brand : String?
    var category : String?
    var thumbnail : String?
    var images : [String]?
}

class ProductModel: NSObject {
    
    func addPostModelData(key:String, keyValue:String, completionHandler: @escaping (_ isSucceeded: Bool, _ data: APIProduct?, _ error: String?) -> ()) {
        
        //  dictionary for the request body
        let parameters = [
            key: keyValue
        ]
        
        // update url
        var updatedURL = ApiConstant.API.Products.apiUrl()
        updatedURL = updatedURL + "/add"
        
        NetworkModel.connectWithServer(url: updatedURL, httpRequest: .POST, queryParameters: parameters) { isSucceeded, data, error in // Passing .POST as httpRequest
            if isSucceeded {
                do {
                    let decoder = JSONDecoder()
                    let usableData = try decoder.decode(APIProduct.self, from: data!)
                    let entriesData = usableData
                    completionHandler(true, entriesData, nil)
                } catch {
                    print(error.localizedDescription)
                    completionHandler(false, nil, error.localizedDescription)
                }
            } else {
                completionHandler(false, nil, error)
            }
        }
    }
    
    func updatePostModelData(productID:Int, key:String, keyValue:String, completionHandler: @escaping (_ isSucceeded: Bool, _ data: APIProduct?, _ error: String?) -> ()) {
        
        //  dictionary for the request body
        let parameters = [
            key: keyValue
        ]
        
        // update url
        var updatedURL = ApiConstant.API.Products.apiUrl()
        updatedURL = updatedURL + "/"
        updatedURL = updatedURL + "\(productID)"
        
        NetworkModel.connectWithServer(url: updatedURL, httpRequest: .PUT, queryParameters: parameters) { isSucceeded, data, error in // Passing .PUT as httpRequest
            if isSucceeded {
                do {
                    let decoder = JSONDecoder()
                    let usableData = try decoder.decode(APIProduct.self, from: data!)
                    let entriesData = usableData
                    completionHandler(true, entriesData, nil)
                } catch {
                    print(error.localizedDescription)
                    completionHandler(false, nil, error.localizedDescription)
                }
            } else {
                completionHandler(false, nil, error)
            }
        }
    }
    
    func queryParamsModelData(limit: Int, key:String, completionHandler: @escaping (_ isSucceeded: Bool, _ data: [APIProduct]?, _ error: String?) -> ()) {
        
        // query parameters
        let queryParameters = [
            "limit": "\(limit)",
            "skip": "\(0)",
            "select": key
        ]
        
        NetworkModel.connectWithServer(url: ApiConstant.API.Products.apiUrl(), httpRequest: .GET, queryParameters: queryParameters) { isSucceeded, data, error in // Passing .GET as httpRequest
            if isSucceeded {
                do {
                    let decoder = JSONDecoder()
                    let usableData = try decoder.decode(Product.self, from: data!)
                    let entriesData = usableData.products
                    completionHandler(true, entriesData, "no error")
                } catch {
                    print(data!)
                    print(error.localizedDescription)
                    completionHandler(false, nil, error.localizedDescription)
                }
            } else {
                completionHandler(false, nil, error)
            }
        }
    }
    
//    func postDataToAPI(title: String) {
//        
//        let urlString = "https://dummyjson.com/products/add"
//        
//        guard let url = URL(string: urlString) else {
//            print("Invalid URL")
//            return
//        }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        
//        // Set the headers
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        //  dictionary for the request body
//        let parameters: [String: Any] = [
//            "title": title
//        ]
//        
//        // Convert the dictionary to JSON data
//        guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters) else {
//            print("Failed to serialize JSON data")
//            return
//        }
//        print(jsonData)
//        // Set the request body
//        request.httpBody = jsonData
//        
//        // Perform the request
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            
//            if let error = error {
//                print("Error: \(error)")
//                return
//            }
//            
//            // Check the response
//            guard let httpResponse = response as? HTTPURLResponse else {
//                print("Invalid response")
//                return
//            }
//            print("Response status code: \(httpResponse.statusCode)")
//            
//            
//            // Handle the response data
//            if let data = data {
//                if let responseData = String(data: data, encoding: .utf8) {
//                    print("Response data: \(responseData)")
//                    
//                } else {
//                    print("No response data")
//                }
//            }
//        }
//        task.resume()
//    }
    
    
    func searchAPIRequest(with query: String , completionHandler : @escaping (
        _ isSucceded : Bool , _ data : Data , _ error : Error? ) -> ()) {
            
            let urlString = "https://dummyjson.com/products/search?q=\(query)"
            
            let urlRequest = URLRequest(url: URL(string: urlString)!)
            let session = URLSession.shared
            let task = session.dataTask(with: urlRequest) { data, response, error in
                
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    print("Invalid response")
                    return
                }
                
                if let data = data {
                    completionHandler(true, data, nil)
                } else {
                    print("Invalid URL")
                }
            }
            task.resume()
        }

    
    func deleteProduct(productId: Int, completionHandler: @escaping (_ isSuccess: Bool, _ data : APIProduct? , _ error: String?) -> Void) {
        let urlString = "https://dummyjson.com/products/\(productId)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completionHandler(false,nil, "Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                completionHandler(false,nil, error.localizedDescription)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                completionHandler(false,nil, "Invalid response")
                return
            }
            
            print("Response status code: \(httpResponse.statusCode)")
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(APIProduct.self, from: data)
                    print(response)
                    completionHandler(true, response, nil)
                } catch {
                    print(error.localizedDescription)
                } } else {
                    print("No response data")
                    completionHandler(false,nil, "No response data")
                }
            }
        task.resume()
        }

    
    }


