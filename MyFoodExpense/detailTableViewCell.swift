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

    @IBOutlet weak var ingField: UITextField!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var taxButton: UIButton!
    
    func setCell(ing:String,price:String,tax:String){
        ingField.text = ing
        priceLabel.text = price
        if tax == "税込"{
            taxButton.setTitle("税込", for: .normal)
            taxButton.setTitleColor(UIColor.red, for: .normal)
        }else{
            taxButton.setTitle("税抜き", for: .normal)
            taxButton.setTitleColor(UIColor.black, for: .normal)
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
