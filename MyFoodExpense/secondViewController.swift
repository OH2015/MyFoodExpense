//
//  secondViewController.swift
//  MyFoodExpense
//
//  Created by 123 on 2019/02/09.
//  Copyright © 2019 123. All rights reserved.
//

import UIKit

class secondViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    let userDefaults = UserDefaults.standard
    var index:Int?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pickDataFromKey()
        return titles.count

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dataCell", for: indexPath)
        let DataArray:[[String]] = userDefaults.array(forKey: "KEY_dataArray") as! [[String]]
        cell.textLabel?.text = DataArray[18][indexPath.row]
        let subTitle = cell.viewWithTag(2) as! UILabel
        subTitle.text = DataArray[19][indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        performSegue(withIdentifier: "showSegue", sender: nil)
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if tableView.isEditing {
            return .delete
        }
        return .none
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        var DataArray:[[String]] = userDefaults.array(forKey: "KEY_dataArray") as! [[String]]
        for i in 0...20{
            DataArray[i].remove(at: indexPath.row)
        }
        DispatchQueue.main.async {
            self.userDefaults.set(DataArray, forKey: "KEY_dataArray")
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }

    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        //override前の処理を継続してさせる
        super.setEditing(editing, animated: animated)
        //tableViewの編集モードを切り替える
        tableView.isEditing = editing
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if tableView.isEditing == true{
            return true
        }
        return false
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        var DataArray:[[String]] = userDefaults.array(forKey: "KEY_dataArray") as! [[String]]
        for i in 0...20{
            DataArray[i].swapAt(sourceIndexPath.row, destinationIndexPath.row)
        }
        DispatchQueue.main.async {
            self.userDefaults.set(DataArray, forKey: "KEY_dataArray")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }

    @IBAction func edit(_ sender: Any) {
        if tableView.isEditing == true{
            tableView.isEditing = false
        }
        tableView.isEditing = true
    }



    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSegue"{
            let nextVC:ViewController = segue.destination as! ViewController
            let DataArray:[[String]] = self.userDefaults.array(forKey: "KEY_dataArray") as! [[String]]
            print(DataArray)

            nextVC.newIng1 = DataArray[0][index!]
            nextVC.newIng2 = DataArray[1][index!]
            nextVC.newIng3 = DataArray[2][index!]
            nextVC.newIng4 = DataArray[3][index!]
            nextVC.newIng5 = DataArray[4][index!]
            nextVC.newIng6 = DataArray[5][index!]
            nextVC.newCT1 = DataArray[6][index!]
            nextVC.newCT2 = DataArray[7][index!]
            nextVC.newCT3 = DataArray[8][index!]
            nextVC.newCT4 = DataArray[9][index!]
            nextVC.newCT5 = DataArray[10][index!]
            nextVC.newCT6 = DataArray[11][index!]
            nextVC.newTax1 = DataArray[12][index!]
            nextVC.newTax2 = DataArray[13][index!]
            nextVC.newTax3 = DataArray[14][index!]
            nextVC.newTax4 = DataArray[15][index!]
            nextVC.newTax5 = DataArray[16][index!]
            nextVC.newTax6 = DataArray[17][index!]
            nextVC.newPerson = DataArray[20][index!]

            DispatchQueue.main.async {
                nextVC.reloadData()
            }
        }
    }

    func pickDataFromKey(){
        guard let DataArray:[[String]] =  userDefaults.array(forKey: "KEY_dataArray") as? [[String]] else{return}
        ing1s = DataArray[0]
        ing2s = DataArray[1]
        ing3s = DataArray[2]
        ing4s = DataArray[3]
        ing5s = DataArray[4]
        ing6s = DataArray[5]
        ct1s = DataArray[6]
        ct2s = DataArray[7]
        ct3s = DataArray[8]
        ct4s = DataArray[9]
        ct5s = DataArray[10]
        ct6s = DataArray[11]
        taxFlags1 = DataArray[12]
        taxFlags2 = DataArray[13]
        taxFlags3 = DataArray[14]
        taxFlags4 = DataArray[15]
        taxFlags5 = DataArray[16]
        taxFlags6 = DataArray[17]
        titles = DataArray[18]
        dates = DataArray[19]
        person = DataArray[20]

    }
    



}
