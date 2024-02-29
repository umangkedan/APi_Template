//
//  HomeControllerViewController.swift
//  APIjson
//
//  Created by Umang Kedan on 25/02/24.
//

import UIKit

class HomeControllerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func detailsAction(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Products View", message: "Select Option from below for action to perform!", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Fetch All", style: .default, handler: { (_) in
            let fetchAllView = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "productController")
            self.navigationController?.pushViewController(fetchAllView, animated: true)
        }))
       
        actionSheet.addAction(UIAlertAction(title: "Query", style: .default, handler: { (_) in
            let queryView = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "queryController")
            self.navigationController?.pushViewController(queryView, animated: true)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Add", style: .default, handler: { (_) in
            let addView = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "addRecordController")
            self.navigationController?.pushViewController(addView, animated: true)
        }))

        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        // Present the action sheet
        present(actionSheet, animated: true, completion: nil)
    }
}
  
