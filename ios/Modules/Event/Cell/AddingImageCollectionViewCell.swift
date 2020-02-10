//
//  AddingImageCollectionViewCell.swift
//  Cupid
//
//  Created by Quan Tran on 12/19/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import UIKit

class AddingImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    
    var didDeleteCallback: ((UIImage?) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func deleteAction(_ sender: UIButton) {
        didDeleteCallback?(imgView.image)
    }
}
