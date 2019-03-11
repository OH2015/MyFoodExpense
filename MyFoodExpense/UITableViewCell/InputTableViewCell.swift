//
//  InputTableViewCell.swift
//  
//
//  Created by 123 on 2019/02/26.
//

import UIKit

class InputTableViewCell: UITableViewCell {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var taxButton: UIButton!
    @IBOutlet weak var priceField: NumberTextField!

    func setValue(name:String,tax:String,price:String){
        nameField.text = name
        if tax == "税抜き"{
            taxButton.setTitle("税抜き", for: .normal)
            taxButton.setTitleColor(UIColor.black, for: .normal)
        }else{
            taxButton.setTitle("税込", for: .normal)
            taxButton.setTitleColor(UIColor.red, for: .normal)
        }

        if price == "0"{
            priceField.text = ""
        }else{
            priceField.text = price
        }
    }

  
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
