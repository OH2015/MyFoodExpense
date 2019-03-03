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

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setCell(imageName:UIImage?,title:String,price:String){
        self.title.text = title
        if let img = imageName{
            self.listImage.image = img
            self.listImage.backgroundColor = UIColor.white
        }else{
            self.listImage.image = UIImage(named: "noImage")
            self.listImage.contentMode = UIImageView.ContentMode.scaleAspectFill
        }
        self.priceLabel.text = "合計\(price)円"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

