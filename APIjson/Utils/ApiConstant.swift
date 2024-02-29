//
//  ApiConstant.swift
//  APIjson
//
//  Created by Umang Kedan on 29/02/24.
//

import UIKit

class ApiConstant: NSObject {
    
    enum API {
       
        case CatFact
        case DogImage
        case Products
        
        func name() -> String {
            switch self {
            case .CatFact:
                return "fact"
            case .DogImage:
                return "random"
            case .Products:
                return "products"
            }
        }
        
        func baseUrl() -> String {
            switch self {
            case .CatFact:
                return "https://catfact.ninja/"
            case .DogImage:
                return "https://dog.ceo/api/breeds/image/"
            case .Products:
                return "https://dummyjson.com/"
            }
        }
        
        func apiUrl() -> String {
            return "\(baseUrl())\(name())"
        }
    }
}

