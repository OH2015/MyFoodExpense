//
//  logTableViewCell.swift
//  MyFoodExpense
//
//  Created by 123 on 2019/02/10.
//  Copyright © 2019 123. All rights reserved.
//






import UIKit

class logTableViewCell: UITableViewCell, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    @IBOutlet var title: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet var listImage: UIImageView!

    var timeID:String?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setCell(imageName:UIImage?,title:String,price:String,time:String){
        self.title.text = title
        self.timeID = time
        if let img = imageName{
            self.listImage.image = img
            self.listImage.backgroundColor = UIColor.white
        }else{
            self.listImage.image = nil
        }

        self.priceLabel.text = "合計\(price)円"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

