//
//  AddingNameTableViewCell.swift
//  Cupid
//
//  Created by Quan Tran on 2/10/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import UIKit

class AddingNameTableViewCell: UITableViewCell, UITextViewDelegate {
    
    @IBOutlet weak var nameField: UITextView!
    
    var didChangeTextCallback: ((String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameField.delegate = self
        nameField.textColor = .lightGray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        didChangeTextCallback?(textView.text)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Write something..." {
            textView.text = ""
            if #available(iOS 13.0, *) {
                textView.textColor = .label
            } else {
                textView.textColor = .darkText
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Write something..."
            textView.textColor = .lightGray
        }
    }
}
