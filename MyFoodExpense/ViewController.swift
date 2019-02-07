//
//  ViewController.swift
//  MyFoodExpense
//
//  Created by 123 on 2019/02/05.
//  Copyright © 2019 123. All rights reserved.
//

import UIKit



var Prices = [String]()
var Ingredients = ["なし"]
let Person = ["1","2","3","4"]

class ViewController: UIViewController,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIScrollViewDelegate {

    var TotalCost = 0
    var currentPerson = 1
    var cost1 = 0
    var cost2 = 0
    var cost3 = 0
    var cost4 = 0
    var cost5 = 0


    @IBOutlet weak var ingredients1: UITextField!
    @IBOutlet weak var ingredients2: UITextField!
    @IBOutlet weak var ingredients3: UITextField!
    @IBOutlet weak var ingredients4: UITextField!
    @IBOutlet weak var ingredients5: UITextField!


    @IBOutlet weak var prices1: UIPickerView!
    @IBOutlet weak var prices2: UIPickerView!
    @IBOutlet weak var prices3: UIPickerView!
    @IBOutlet weak var prices4: UIPickerView!
    @IBOutlet weak var prices5: UIPickerView!
    var ingpickerView: UIPickerView! = UIPickerView()
    @IBOutlet weak var personPickerView: UIPickerView!

    @IBOutlet weak var totalCost: UILabel!
    @IBOutlet weak var perCost: UILabel!

    @IBOutlet weak var scrollView: MyScrollView!
    @IBOutlet weak var contentView: UIView!

    @IBOutlet weak var pageControll: UIPageControl!

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == ingpickerView{
            return Ingredients.count
        }else if pickerView == personPickerView{
            return Person.count
        }else{
            return Prices.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == ingpickerView{
            return Ingredients[row]
        }else if pickerView == personPickerView{
            return Person[row]
        }else{
            return Prices[row]
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == personPickerView{
            currentPerson = Int(Person[row])!
        }else if pickerView == ingpickerView{
            return
        }else{
            switch pickerView.tag{
            case 1:cost1 = Int(Prices[row])!
            case 2:cost2 = Int(Prices[row])!
            case 3:cost3 = Int(Prices[row])!
            case 4:cost4 = Int(Prices[row])!
            case 5:cost5 = Int(Prices[row])!
            default:
                return
            }
        }

        TotalCost = cost1 + cost2 + cost3 + cost4 + cost5
        if TotalCost == 0{
            perCost.text = "0"
        }else{
            let perc = TotalCost / currentPerson
            perCost.text = String(perc)

        }
        totalCost.text = String(TotalCost)

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        for i in 0...100{
            Prices.append(String(10*i))
        }

        scrollView.isDirectionalLockEnabled = true

//        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 35))
//        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
//        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
//        toolbar.setItems([cancelItem, doneItem], animated: true)


//        ingpickerView.delegate = self
//        ingpickerView.showsSelectionIndicator = true
//        ingpickerView.dataSource = self

//        ingredients1.inputView = ingpickerView
//        ingredients1.inputAccessoryView = toolbar
//        ingredients2.inputView = ingpickerView
//        ingredients2.inputAccessoryView = toolbar
//        ingredients3.inputView = ingpickerView
//        ingredients3.inputAccessoryView = toolbar
//        ingredients4.inputView = ingpickerView
//        ingredients4.inputAccessoryView = toolbar
//        ingredients5.inputView = ingpickerView
//        ingredients5.inputAccessoryView = toolbar

        self.prices1.delegate = self
        self.prices2.delegate = self
        self.prices3.delegate = self
        self.prices4.delegate = self
        self.prices5.delegate = self

        scrollView.delegate = self
    }



    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        done()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        done()
        return true
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControll.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.maxX)
    }

    @objc
    func cancel() {
        ingredients1.text = ""
        ingredients1.endEditing(true)
        ingredients2.text = ""
        ingredients2.endEditing(true)
        ingredients3.text = ""
        ingredients3.endEditing(true)
        ingredients4.text = ""
        ingredients4.endEditing(true)
        ingredients5.text = ""
        ingredients5.endEditing(true)
    }

//    @objc
    func done() {
        ingredients1.endEditing(true)
        ingredients2.endEditing(true)
        ingredients3.endEditing(true)
        ingredients4.endEditing(true)
        ingredients5.endEditing(true)
    }



}


