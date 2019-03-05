//
//  customButton.swift
//  MyFoodExpense
//
//  Created by 123 on 2019/03/04.
//  Copyright © 2019 123. All rights reserved.
//

import UIKit

class customButton: UIButton {
    let color1 = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    let color2 = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)

    @IBInspectable var highlightedBackgroundColor :UIColor?
    @IBInspectable var nonHighlightedBackgroundColor :UIColor?
    override var isHighlighted :Bool {
        didSet {
            if isHighlighted {
                self.backgroundColor = color2
            }
            else {
                self.backgroundColor = color1
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
        self.setTitleColor(UIColor.black, for: .normal)
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 10
        self.clipsToBounds = true


    }

    override func layoutSubviews() {
        super.layoutSubviews()


    }

}
