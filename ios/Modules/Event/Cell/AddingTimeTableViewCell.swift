//
//  AddingTimeTableViewCell.swift
//  Cupid
//
//  Created by Quan Tran on 12/15/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import UIKit

class AddingTimeTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timePickingView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    
    var didSelectDate: ((String) -> Void)?
    var isStartDate: Bool = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let displayCalendar = UITapGestureRecognizer(target: self, action: #selector(showDatePicker))
        timePickingView.addGestureRecognizer(displayCalendar)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc private func showDatePicker() {
        DatePickerDialog().show(isStartDate ? "When did it start?" : "When did it end?", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate: Date(), datePickerMode: .date) { (date) in
            if let date = date {
                let dateString = date.toString(.custom(kEventDateFormat))
                self.timeLabel.text = dateString
                self.didSelectDate?(dateString)
            }
        }
    }
}
