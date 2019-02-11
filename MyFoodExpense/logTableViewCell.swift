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



import UIKit

class logTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var ing1: UILabel!
    @IBOutlet weak var ing2: UILabel!
    @IBOutlet weak var ing3: UILabel!
    @IBOutlet weak var ing4: UILabel!
    @IBOutlet weak var ing5: UILabel!
    @IBOutlet weak var ing6: UILabel!
    @IBOutlet weak var ct1: UILabel!
    @IBOutlet weak var ct2: UILabel!
    @IBOutlet weak var ct3: UILabel!
    @IBOutlet weak var ct4: UILabel!
    @IBOutlet weak var ct5: UILabel!
    @IBOutlet weak var ct6: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        print("hello")

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
