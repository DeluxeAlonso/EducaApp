//
//  PendingApprovalPaymentTableViewCell.swift
//  EducaApp
//
//  Created by inf227al on 9/11/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

class PendingApprovalPaymentTableViewCell: UITableViewCell {
    @IBOutlet weak var amountLabel: UILabel!

    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupPayment(payment: Payment) {
        amountLabel.text = "\(payment.amount)"
        statusLabel.text = "Por Aprobar"
        let date = payment.dueDate
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/Y"
        let dateString = dateFormatter.stringFromDate(date)
        dateLabel.text = dateString
    }

}
