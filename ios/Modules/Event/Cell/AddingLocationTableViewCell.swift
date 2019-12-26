//
//  AddingLocationTableViewCell.swift
//  Cupid
//
//  Created by Quan Tran on 12/15/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import UIKit

class AddingLocationTableViewCell: UITableViewCell {

    @IBOutlet weak var locationField: UITextField!
    
    var didEndEditingCallback: ((String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func textDidChange(_ sender: UITextField) {
        if let text = sender.text {
            didEndEditingCallback?(text)
        }
    }
}
