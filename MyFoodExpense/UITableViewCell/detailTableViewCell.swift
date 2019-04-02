//
//  detailTableViewCell.swift
//  MyFoodExpense
//
//  Created by 123 on 2019/02/27.
//  Copyright © 2019 123. All rights reserved.
//

import UIKit
//DataArray = [ingredients,prices,tax,[String(person)],[date],[Title]]
class detailTableViewCell: UITableViewCell {

    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var taxButton: UIButton!
    @IBOutlet weak var yenLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    
    func setCell(name:String,price:String,tax:String,number: String){
        if price == ""{
            nameLabel.text = ""
            priceLabel.text = ""
            yenLabel.text = ""
            numberLabel.text = ""
            taxButton.setTitle("", for: .normal)
            return
        }
        nameLabel.text = name
        priceLabel.text = price
        numberLabel.text = number
        if tax == "税込"{
            taxButton.setTitle("税込", for: .normal)
            taxButton.setTitleColor(UIColor.red, for: .normal)
        }else {
            taxButton.setTitle("税抜き", for: .normal)
            taxButton.setTitleColor(UIColor.black, for: .normal)
        }

        if name == ""{
            nameLabel.text = "no name"
        }

    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
