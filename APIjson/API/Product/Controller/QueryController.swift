//
//  QueryController.swift
//  APIjson
//
//  Created by Umang Kedan on 29/02/24.
//

import UIKit

class QueryController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var limitTextField: UITextField!
    
    let model = ProductModel()
    var productDetail = [APIProduct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextFields()
        
    }
    
    func setupTextFields(){
        titleTextField.delegate = self
        limitTextField.delegate = self
    }
    
    @IBAction func goButtonAction(_ sender: Any) {
        let limit:Int = Int(limitTextField.text ?? "") ?? 0
        model.queryParamsModelData(limit: limit, key: titleTextField.text ?? "") { isSucceeded, data, error in
                if isSucceeded {
                    guard let data = data else {return}
                    print(data)
                    self.productDetail = data
                    print(self.productDetail)
                    DispatchQueue.main.async {
                        self.addDataLabels()
                    }
                } else if let error = error {
                    NetworkModel.showAlert(title: "Error While Getting Data", message: "An error occurred while fetching data from the API: \(error)", view: self, action: UIAlertAction(title: "Ok", style: .default))
                }
            }
        }
    
    func addDataLabels() {
        var labelYPosition: CGFloat = 360
        
        for (index, detail) in productDetail.enumerated() {
            let mirror = Mirror(reflecting: detail)
            for case let (label?, value) in mirror.children {
                if let stringValue = value as? String {
                    let labelText = "\(label): \(stringValue)"
                    let label = UILabel(frame: CGRect(x: 20, y: labelYPosition, width: 250, height: 30))
                    label.text = labelText
                    self.view.addSubview(label)
                    labelYPosition += 40
                }
            }
            // Add space after printing one device Details
            if index < productDetail.count - 1 {
                labelYPosition += 40
            }
        }
    }
}

extension QueryController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
