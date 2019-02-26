//
//  FormViewController.swift
//  MyFoodExpense
//
//  Created by 123 on 2019/02/26.
//  Copyright © 2019 123. All rights reserved.
//

import UIKit

class FormViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource{


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
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

            
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

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
    }

    @IBAction func costSelect(_ sender: PickerTextField) {
        sender.setup()
    }
//-------------------------------------------------------------------------------------------
    func doneTapped(){
        UIView.animate(withDuration: 0.2){
            self.pickerToolbar.frame = CGRect(x:0,y:self.view.frame.height,
                                              width:self.view.frame.width,height:self.toolbarHeight)
            self.pickerView.frame = CGRect(x:0,y:self.view.frame.height + self.toolbarHeight,
                                           width:self.view.frame.width,height:self.pickerViewHeight)
            self.tableView.contentOffset.y = 0
        }
    }
}

