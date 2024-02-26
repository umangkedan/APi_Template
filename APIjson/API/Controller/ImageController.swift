//
//  ImageController.swift
//  APIjson
//
//  Created by Umang Kedan on 25/02/24.
//

import UIKit

class ImageController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    let model = SystemModel()
    let apiUrl = "https://dog.ceo/api/breeds/image/random"
    var dataFromAPI:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDatafromAPI()
        
    }
    
    func fetchDatafromAPI() {
        model.convertDogModelData(url: apiUrl) { isSucceeded, data, error in
            if isSucceeded {
                self.dataFromAPI = data
                DispatchQueue.main.async {
                    self.imageView.image = self.dataFromAPI
                }
               
            } else if let error = error {
                self.alertUser(title: "Error", message: "Error getting data from API: \(error)")
            }
        }
    }
    
    func alertUser(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okay = UIAlertAction(title: "Okay", style: .default)
        alert.addAction(okay)
        self.present(alert, animated: true)
    }
    
}

