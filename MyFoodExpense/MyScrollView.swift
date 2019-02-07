//
//  MyScrollView.swift
//  MyFoodExpense
//
//  Created by 123 on 2019/02/07.
//  Copyright © 2019 123. All rights reserved.
//

import UIKit

class MyScrollView: UIScrollView {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        superview?.touchesBegan(touches, with: event)
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
