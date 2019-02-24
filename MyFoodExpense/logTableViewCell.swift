//
//  logTableViewCell.swift
//  MyFoodExpense
//
//  Created by 123 on 2019/02/10.
//  Copyright © 2019 123. All rights reserved.
//


var PriceArray = [Int]()
var ingSet = [String]()
var costSet = [String]()
var taxSet = [String]()
var BoxSet = [[String]]()
var BoxArray = [[[String]]]()
var DataSet = [String]()
var DataArray = [Any]()

enum KEY:String {
    case box = "boxKey"
    case data = "dataKey"
}


import UIKit

class logTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }

}
