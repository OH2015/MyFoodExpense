//
//  CustomHeaderFooterView.swift
//  MyFoodExpense
//
//  Created by 123 on 2019/03/02.
//  Copyright © 2019 123. All rights reserved.
//

import UIKit

class CustomHeaderFooterView: UITableViewHeaderFooterView {

    private var arrow = UIImageView()
    var section: Int = 0

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.arrow.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.arrow)
        self.contentView.addConstraints([
            NSLayoutConstraint(item: arrow, attribute: .trailing, relatedBy: .equal, toItem: self.contentView, attribute: .trailing, multiplier: 1.0, constant: -8),
            NSLayoutConstraint(item: arrow, attribute: .centerY, relatedBy: .equal, toItem: self.contentView, attribute: .centerY, multiplier: 1.0, constant: 0)])
        self.backgroundColor = UIColor.green
        self.textLabel?.textColor = UIColor.black
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setExpanded(expanded: Bool) {
        arrow.image = UIImage(named: expanded ? "ArrowDown" : "ArrowUp")
    }

}
