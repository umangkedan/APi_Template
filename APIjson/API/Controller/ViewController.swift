//
//  ViewController.swift
//  APIjson
//
//  Created by Umang Kedan on 25/02/24.
//

import UIKit


struct Animal : Codable {
   var fact : String
   var length : Int
}

class ViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIView!
    var dataFromAPI: [String: Any] = [:]
    
    let modelObject = SystemModel()
    var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callApi()
        addLoader()
    }
    
    func addLoader() {
        activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.center = CGPoint(x: scrollView.bounds.midX, y: scrollView.bounds.midY)
        activityIndicator.color = .blue
        activityIndicator.startAnimating()
        scrollView.addSubview(activityIndicator)
    }
    
    func callApi(){
        modelObject.getApi(url: "https://catfact.ninja/fact") { is_succeding, data, error in
            DispatchQueue.main.async {
                if is_succeding {
                    do {
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.removeFromSuperview()
                        let decoder = JSONDecoder()
                        let jsonObject = try decoder.decode(Animal.self, from: data)
                        self.dataFromAPI = [jsonObject.fact : jsonObject.length ]
                        print(self.dataFromAPI)
                        addLabels()
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                } else {
                    print("API request failed: \(error ?? "Unknown error")")
                }
                
            }
        }
        
        func addLabels() {
            var labelYPosition: CGFloat = 100
            for (key, value) in dataFromAPI {
                let label = UILabel(frame: CGRect(x: 20, y: labelYPosition, width: scrollView.frame.width - 25, height: 100))
                print("\(key ) \(value)")
                label.text = "\(key): \(value)"
                label.numberOfLines = 0
                label.lineBreakMode = .byWordWrapping
                label.sizeToFit()
                
                self.view.addSubview(label)
                labelYPosition += 40
            }
        }
    }
}
