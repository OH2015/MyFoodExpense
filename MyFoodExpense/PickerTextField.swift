//
//  PickerTextField.swift
//  MyFoodExpense
//
//  Created by 123 on 2019/02/26.
//  Copyright © 2019 123. All rights reserved.
//

import UIKit

class PickerTextField: UITextField ,UIPickerViewDataSource,UIPickerViewDelegate{

    var thou = 0
    var hund = 0
    var ten = 0
    var one = 0
    var number = 0
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
    }

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
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        picker.showsSelectionIndicator = true

        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 35))
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        toolbar.setItems([cancelItem, doneItem], animated: true)

        self.inputView = picker
        self.inputAccessoryView = toolbar
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 10
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(row)
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:thou = row
        case 1:hund = row
        case 2:ten = row
        case 3:one = row
        default:break}
        number = thou*1000 + hund*100 + ten*10 + one
        self.text = String(number)
    }

    @objc func cancel() {
        self.text = "0"
        self.endEditing(true)
    }

    @objc func done() {
        self.endEditing(true)
    }

}
