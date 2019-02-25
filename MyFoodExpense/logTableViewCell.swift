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
var imgArray = [String]()

enum KEY:String {
    case box = "boxKey"
    case data = "dataKey"
    case img = "imageKey"
}

import UIKit

class logTableViewCell: UITableViewCell, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    @IBOutlet var title: UILabel!
    @IBOutlet var subTitle: UILabel!
    @IBOutlet var listImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setCell(imageName:UIImage?,title:String,date:String){
        self.title.text = title
        if let img = imageName{
            self.listImage.image = imageName
        }
        self.subTitle.text = date
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

