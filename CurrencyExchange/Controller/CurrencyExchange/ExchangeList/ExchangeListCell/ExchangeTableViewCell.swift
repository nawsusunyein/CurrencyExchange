//
//  ExchangeTableViewCell.swift
//  CurrencyExchange
//
//  Created by Naw Su Su Nyein on 12/4/19.
//  Copyright © 2019 Naw Su Su Nyein. All rights reserved.
//

import UIKit

class ExchangeTableViewCell: UITableViewCell {

    @IBOutlet weak var lblCurrencyType: UILabel!
    
    @IBOutlet weak var lblCurrencyUnitValue: UILabel!
    
    @IBOutlet weak var lblCurrencyEnteredAmountValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
