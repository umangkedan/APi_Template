//
//  UserCell.swift
//  APIjson
//
//  Created by Umang Kedan on 25/02/24.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label1: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCellView(id:String, name:String){
        label1.text = id
        label2.text = name
    }
}
