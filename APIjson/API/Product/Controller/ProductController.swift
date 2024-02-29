//
//  ProductController.swift
//  APIjson
//
//  Created by Umang Kedan on 26/02/24.
//

import UIKit

class ProductController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let modelObj = ProductModel()
    var productArray : [APIProduct] = []
    var dataObj = Data()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // fetchData1()  
        fetchDataFromApi()
        activityIndicator(start: true)
        tableView.register(UINib(nibName: "UserCell", bundle: .main), forCellReuseIdentifier: "user")
        tableView.delegate = self
        tableView.dataSource = self
        
    }

    let url = "https://dummyjson.com/products"
    
    func convertProductsModelData(completionHandler: @escaping (_ isSucceeded: Bool, _ data: [APIProduct]?, _ error: String?)->()) {
        NetworkModel.connectWithServer(url: url, httpRequest: .GET) { isSucceeded, data, error in
            DispatchQueue.main.async {
                if isSucceeded {
                    do {
                        self.activityIndicator(start: false)
                        let decoder = JSONDecoder()
                        let usableData = try decoder.decode(Product.self, from: data!)
                        print(usableData.products)
                        let entriesData = usableData.products
                        completionHandler(true, entriesData, nil)
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
    }
    
    func fetchDataFromApi() {      //fetch data
        convertProductsModelData { isSucceeded, data, error in
            if isSucceeded{
                self.productArray = data!
                print(self.productArray)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func activityIndicator(start: Bool) {
            if start {
                let activIndicator = UIActivityIndicatorView(style: .large)
                activIndicator.color = .gray
                activIndicator.startAnimating()
                tableView.backgroundView = activIndicator
            } else {
                tableView.backgroundView = nil
            }
        }
}

extension ProductController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "user", for: indexPath) as? UserCell else {
            return UITableViewCell()
        }
        let idf = productArray[indexPath.row].id
        
        let names = productArray[indexPath.row].brand
        
        cell.setupCellView(id: "\(idf ?? 0 )", name: names ?? "" )
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let savedController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "SavedController") as? SavedController {
            savedController.details = productArray[indexPath.row]
            
            savedController.onDelete = { [weak self] in
                // Remove the deleted product from the productArray
                self?.productArray.remove(at: indexPath.row)
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: {_ in
                        self?.navigationController?.popViewController(animated: true)
                    })
                    NetworkModel.showAlert(title: "Record Deleted ", message: "Record is deleted Successfully ", view: self!, action: okAction)
                }
            }
            navigationController?.pushViewController(savedController, animated: true)
        }
    }
}

extension ProductController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        modelObj.searchAPIRequest(with: "\(searchBar.text ?? "")") { isSucceded, data, error in
            DispatchQueue.main.async {
                if isSucceded{
                    if !data.isEmpty{
                        do{
                            let decoder = JSONDecoder()
                            let response = try decoder.decode(Product.self, from: data)
                            let products = response.products
                            self.productArray = products
                            print(products)
                            self.tableView.reloadData()
                        }
                        catch {
                            print(error)
                        }
                    }
                } else {
                    print(error!.localizedDescription)
                }
            }
        }
    }
}





