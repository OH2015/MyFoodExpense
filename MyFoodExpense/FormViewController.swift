//
//  FormViewController.swift
//  MyFoodExpense
//
//  Created by 123 on 2019/02/26.
//  Copyright © 2019 123. All rights reserved.
//

import UIKit

class FormViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate{

    var ingredients = [String]()
    var prices = [String]()
    var tax = [String]()
    var cellCount = 3
    //ピッカービュー
    private var pickerView:UIPickerView!
    private let pickerViewHeight:CGFloat = 160

    //pickerViewの上にのせるtoolbar
    private var pickerToolbar:UIToolbar!
    private let toolbarHeight:CGFloat = 40.0

    @IBOutlet weak var tableView: UITableView!
//---------------------------------viewDidLoad----------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        let width = self.view.frame.width
        let height = self.view.frame.height

        //pickerView
        pickerView = UIPickerView(frame:CGRect(x:0,y:height + toolbarHeight,
                                               width:width,height:pickerViewHeight))
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.backgroundColor = UIColor.gray
        self.view.addSubview(pickerView)


    }
//----------------------------------tableView----------------------------------------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let ingField = cell.viewWithTag(1) as! UITextField
        ingField.delegate = self

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if tableView.isEditing {
            return .delete
        }
        return .none
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        cellCount -= 1
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }

//------------------------------------pickerView-------------------------------------------
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 10
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(row)
    }

//------------------------------------------------------------------------------------------

    @IBAction func wrote(_ sender: UITextField) {
        reloadValue()
    }

    @IBAction func costChanged(_ sender: PickerTextField) {
        reloadValue()
    }

    @IBAction func taxChanged(_ sender: UIButton) {
        if sender.currentTitle == "税抜き"{
            sender.setTitle("税込", for: .normal)
            sender.setTitleColor(UIColor.red, for: .normal)
        }else{
            sender.setTitle("税抜き", for: .normal)
            sender.setTitleColor(UIColor.black, for: .normal)
        }
        reloadValue()
    }

    @IBAction func check(_ sender: Any) {
        print(ingredients)
        print(prices)
        print(tax)
    }
    @IBAction func send(_ sender: Any) {
    }

    @IBAction func insertCell(_ sender: Any) {
        cellCount += 1
        tableView.reloadData()
    }

    @IBAction func edit(_ sender: Any) {
        tableView.isEditing = !tableView.isEditing
    }
    //-------------------------------------------------------------------------------------------

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    func reloadValue(){
        ingredients.removeAll()
        prices.removeAll()
        tax.removeAll()
        for i in 0...cellCount-1{
            let cell = tableView.cellForRow(at: [0,i])
            let ingField = cell?.viewWithTag(1) as! UITextField
            let priceField = cell?.viewWithTag(2) as! PickerTextField
            let taxButton = cell?.viewWithTag(3) as! UIButton
            ingredients.append(ingField.text ?? "")
            prices.append(priceField.text ?? "0")
            tax.append(taxButton.currentTitle!)
        }

    }
}

