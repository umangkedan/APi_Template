//
//  DataController.swift
//  APIjson
//
//  Created by Umang Kedan on 26/02/24.
//

import UIKit

var sysObj = SystemModel()

class DataController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var activityIndicator: UIActivityIndicatorView!
    var entriesArray = [Entries]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDataFromAPI()
        setupTableView()
        addLoader()
    }
    
    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "UserCell", bundle: .main), forCellReuseIdentifier: "user")
    }
    
    func addLoader() {
        activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.center = CGPoint(x: tableView.bounds.midX, y: tableView.bounds.midY)
        activityIndicator.color = .blue
        activityIndicator.startAnimating()
        tableView.addSubview(activityIndicator)
    }
    
    func fetchDataFromAPI() {
        sysObj.convertPublicData(url: "https://api.publicapis.org/entries") { isSucceeded, data, error in
            DispatchQueue.main.async {
                if isSucceeded {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.removeFromSuperview()
                    guard let data = data else {return}
                    self.entriesArray = data
                    print(self.entriesArray)
                } else if let error = error {
                    print(error.localizedCapitalized)
                }
            }
        }
    }
}

extension DataController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        entriesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "user", for: indexPath) as? UserCell else {
            return UITableViewCell()
        }
        
        let apiResult = entriesArray[indexPath.row]
        cell.setupCellView(id: apiResult.API , name: apiResult.Description)
        return cell
        
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextViewController = DetailsControlelr()
        nextViewController.singleData = entriesArray[indexPath.row]
        navigationController?.pushViewController(nextViewController, animated: true)
          }
    }
    
    
