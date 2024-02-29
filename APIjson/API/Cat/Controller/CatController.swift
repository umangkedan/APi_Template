//
//  CatController.swift
//  APIjson
//
//  Created by Umang Kedan on 29/02/24.
//

import UIKit

class CatController: UIViewController {

    @IBOutlet weak var factLabel: UILabel!
    let catObj = CatModel()
    
    var dataFromAPI = [CatFactModel]()
    var fact = "waiting for API Data"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }
    
    func fetchData(){
        catObj.getCatData(url: ApiConstant.API.CatFact.apiUrl()) { isSucceeded, data, error in
            if isSucceeded {
                guard let data = data else { return }
                self.dataFromAPI = data
                self.fact = self.dataFromAPI[0].fact ?? ""
                DispatchQueue.main.async {
                    self.factLabel.text = self.fact
                }
            } else if let error = error {
                print(error)
            }
        }
    }
    @IBAction func reloadAction(_ sender: Any) {
        fetchData()
    }
}
