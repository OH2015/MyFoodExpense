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
    @IBOutlet var subTitle: UILabel!
    @IBOutlet var listImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setCell(imageName:UIImage?,title:String,date:String){
        self.title.text = title
        if let img = imageName{
            self.listImage.image = img
        }else{
            self.listImage.image = nil
        }
        self.subTitle.text = date
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

