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
            let RecordArray:[Any] = self.userDefaults.array(forKey: "KEY_RecordArray") as! [[String]]




            DispatchQueue.main.async {
                nextVC.reloadData()
            }
        }
    }

    func pickDataFromKey(){
        guard let RecordArray:[[Any]] =  userDefaults.array(forKey: "KEY_RecordArray") as? [[String]] else{return}


    }
    



}
