//
//  AddRecordController.swift
//  APIjson
//
//  Created by Umang Kedan on 29/02/24.
//

import UIKit

class AddRecordController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    
    let modelObj = ProductModel()
    var productDetail: APIProduct?
    var keyNamesArray: [String] = [
        "title",
        "description",
        "brand",
        "category"
    ]
    
    var key: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPickerView()
    }
    
    func setupPickerView(){
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    @IBAction func submitButtonAction(_ sender: Any) {
        guard let keyValue = textField.text else { return }
        modelObj.addPostModelData(key: key ?? "", keyValue: keyValue) { [weak self] isSucceeded, data, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                if isSucceeded {
                    self.productDetail = data
                    self.addDataLabels()
                } else if let error = error {
                    NetworkModel.showAlert(title:  "Error While Getting Data", message: "An error occurred while fetching data from the API: \(error)", view: self, action: UIAlertAction(title: "Ok", style: .cancel))
                }
            }
        }
    }
    
    func addDataLabels() {
        guard let productDetail = productDetail else { return }
        var labelYPosition: CGFloat = 560
        let mirror = Mirror(reflecting: productDetail)
        for case let (label?, value) in mirror.children {
            if let stringValue = value as? String {
                let labelText = "\(label): \(stringValue)"
                let label = UILabel(frame: CGRect(x: 20, y: labelYPosition, width: 250, height: 30))
                label.text = labelText
                self.view.addSubview(label)
                labelYPosition += 40
            }
        }
    }
}

extension AddRecordController : UIPickerViewDelegate , UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return keyNamesArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return keyNamesArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        key = keyNamesArray[row]
    }
    
    
}
