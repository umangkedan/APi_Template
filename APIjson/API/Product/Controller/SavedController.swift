//
//  SavedController.swift
//  APIjson
//
//  Created by Umang Kedan on 26/02/24.
//

import UIKit

class SavedController: UIViewController {
    
    let modelOBJ = ProductModel()
    var details : APIProduct?
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var scrollView: UIView!
    var onDelete: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let details = details {
            addLabels(for: details)
        }
    }
    
    func addLabels(for product: APIProduct) {
        var labelYPosition: CGFloat = 100
        let labelWidth: CGFloat = 200
        let labelHeight: CGFloat = 30
        let labelMargin: CGFloat = 20
        
        let attributes = [
            "Description": product.description ?? "",
            "Price": "\(product.price ?? 0)",
            "Discount Percentage": "\(product.discountPercentage ?? 0.0)",
            "Rating": "\(product.rating ?? 0.0)",
            "Stock": "\(product.stock ?? 0)",
            "Brand": product.brand ?? 0,
            "Category": product.category ?? "",
            "title" : product.title ?? ""
        ] as [String : Any]
        
        for (key, value) in attributes {
            let label = UILabel(frame: CGRect(x: labelMargin, y: labelYPosition, width: labelWidth, height: labelHeight))
            label.text = "\(key): \(value)"
            self.view.addSubview(label)
            labelYPosition += labelHeight + labelMargin
        }
    }
    
    @IBAction func deleteButtonAction(_ sender: Any) {
        guard let productId = details?.id else {
            print("Product ID not found")
            return
        }
        
        modelOBJ.deleteProduct(productId: productId) { [weak self] isSuccess, _, error in
            if isSuccess {
                // Call the onDelete closure if it's not nil
                self?.onDelete?()
                print("Successfully deleted product")
            } else {
                print("Error deleting product: \(error ?? "Unknown error")")
            }
        }
    }
}
