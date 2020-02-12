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
        
        timeLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        let displayCalendar = UITapGestureRecognizer(target: self, action: #selector(showDatePicker))
        timePickingView.addGestureRecognizer(displayCalendar)
    }
    
    @objc private func showDatePicker() {
        let dialog = DatePickerDialog(textColor: UIColor.black, buttonColor: UIColor.systemPink, font: .boldSystemFont(ofSize: 15), locale: nil, showCancelButton: true)
        
        dialog.show(isStartDate ? "When did it start?" : "When did it end?", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate: Date(), datePickerMode: .date) { (date) in
            guard let date = date else { return }
            
            if date < Date() {
                let dateString = date.toString(.custom(kEventDateFormat))
                self.timeLabel.textColor = .black
                self.timeLabel.text = dateString
                self.didSelectDate?(dateString)
            } else {
                self.timeLabel.text = "Invalid date!"
                self.timeLabel.textColor = .red
            }
        }
    }
}
