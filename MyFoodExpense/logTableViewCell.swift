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
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet var listImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setCell(image:UIImage?,title:String,price:String,date:String){
        self.title.text = title
        if let img = image{
            self.listImage.image = img
            self.listImage.backgroundColor = UIColor.white
        }else{
            self.listImage.image = UIImage(named: "noImage")
            self.listImage.contentMode = UIImageView.ContentMode.scaleAspectFill
        }
        self.priceLabel.text = "合計\(price)円"
        let weekDay = date.suffix(1)
        let day = date.prefix(date.count - 1)
        dateLabel.text = "\(day)日\(weekDay)曜日"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

