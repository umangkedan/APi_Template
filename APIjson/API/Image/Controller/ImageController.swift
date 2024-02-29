//
//  ImageController.swift
//  APIjson
//
//  Created by Umang Kedan on 25/02/24.
//

import UIKit

class ImageController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    let apiUrl = "https://dog.ceo/api/breeds/image/random"
    var dataFromAPI:UIImage?
    var imageObj = ImageApi()
    let model = ImageModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDatafromAPI()
        
    }
    
    func fetchDatafromAPI() {
        model.convertDogModelData(url: apiUrl) { isSucceeded, data, error in
            if isSucceeded {
                self.imageObj = data
                DispatchQueue.main.async {
                    self.imageObj = data
                    self.imageView.downloaded(from: self.imageObj.message!)
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
    @IBAction func reloadAction(_ sender: Any) {
        fetchDatafromAPI()
    }
    
}

// singleton
//extension UIImageView {
//    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
//        contentMode = mode
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            guard
//                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
//                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
//                let data = data, error == nil,
//                let image = UIImage(data: data)
//                else { return }
//            DispatchQueue.main.async() { [weak self] in
//                self?.image = image
//            }
//        }.resume()
//    }
//    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
//        guard let url = URL(string: link) else { return }
//        downloaded(from: url, contentMode: mode)
//    }
//}
