//
//  PickerTextField.swift
//  MyFoodExpense
//
//  Created by 123 on 2019/02/26.
//  Copyright © 2019 123. All rights reserved.
//

import UIKit

class NumberTextField: UITextField{


    init() {
        super.init(frame: CGRect.zero)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 40))

        let doneItem = UIBarButtonItem(title: "完了", style: .done, target: self, action: #selector(done))
        let spaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let cancelItem = UIBarButtonItem(title: "キャンセル", style: .done, target: self, action: #selector(cancel))
        toolbar.setItems([cancelItem,spaceItem,doneItem], animated: true)

        self.inputAccessoryView = toolbar
    }



    @objc func cancel() {
        self.text = "0"
        self.endEditing(true)
    }

    @objc func done() {
        self.endEditing(true)
    }

}
