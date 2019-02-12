//
//  logTableViewCell.swift
//  MyFoodExpense
//
//  Created by 123 on 2019/02/10.
//  Copyright © 2019 123. All rights reserved.
//

var ing1s = [String]()
var ing2s = [String]()
var ing3s = [String]()
var ing4s = [String]()
var ing5s = [String]()
var ing6s = [String]()
var ct1s = [String]()
var ct2s = [String]()
var ct3s = [String]()
var ct4s = [String]()
var ct5s = [String]()
var ct6s = [String]()
var taxFlags1 = [String]()
var taxFlags2 = [String]()
var taxFlags3 = [String]()
var taxFlags4 = [String]()
var taxFlags5 = [String]()
var taxFlags6 = [String]()
var titles = [String]()
var dates = [String]()
var person = [String]()


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
