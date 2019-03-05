//
//  customButton.swift
//  MyFoodExpense
//
//  Created by 123 on 2019/03/04.
//  Copyright © 2019 123. All rights reserved.
//

import UIKit

class customButton: UIButton {

    @IBInspectable var highlightedBackgroundColor :UIColor?
    @IBInspectable var nonHighlightedBackgroundColor :UIColor?
    override var isHighlighted :Bool {
        didSet {
            if isHighlighted {
                self.backgroundColor = highlightedBackgroundColor
            }
            else {
                self.backgroundColor = nonHighlightedBackgroundColor
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        myInit()
    }

    func myInit() {
        // 角を丸くする
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 10
        self.clipsToBounds = true


    }

    override func layoutSubviews() {
        super.layoutSubviews()


    }

}
