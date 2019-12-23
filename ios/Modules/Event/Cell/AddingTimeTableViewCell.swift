//
//  AddingTimeTableViewCell.swift
//  Cupid
//
//  Created by Quan Tran on 12/15/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import UIKit

class AddingTimeTableViewCell: UITableViewCell, MDDatePickerDialogDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timePickingView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    
    var didSelectDate: ((String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let displayCalendar = UITapGestureRecognizer(target: self, action: #selector(showCalendar))
        timePickingView.addGestureRecognizer(displayCalendar)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc private func showCalendar() {
        let datePicker = MDDatePickerDialog()
        datePicker.delegate = self
        datePicker.show()
    }
    
    func datePickerDialogDidSelect(_ date: Date) {
        let dateText = date.toString(.custom(kEventDateFormat))
        didSelectDate?(dateText)
    }
}
