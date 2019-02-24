//
//  secondViewController.swift
//  MyFoodExpense
//
//  Created by 123 on 2019/02/09.
//  Copyright © 2019 123. All rights reserved.
//

import UIKit
//DataArray = [BoxArray,Person,date,Title]

class secondViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    let userDefaults = UserDefaults.standard
    var index:Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        pickDataFromKey()
        let RecordArray = userDefaults.array(forKey: "KEY_RecordArray")
        return RecordArray?.count ?? 0

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dataCell", for: indexPath)
        let recordArray = userDefaults.array(forKey: "KEY_RecordArray") as! [[Any]]
        cell.textLabel?.text = recordArray[indexPath.row][3] as! String
        let subTitle = cell.viewWithTag(2) as! UILabel
        subTitle.text = recordArray[indexPath.row][2] as! String
        print("ok")
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
        var recordArray:[[Any]] = userDefaults.array(forKey: "KEY_RecordArray") as! [[String]]
        recordArray.remove(at: indexPath.row)

        DispatchQueue.main.async {
            self.userDefaults.set(recordArray, forKey: "KEY_RecordArray")
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if tableView.isEditing == true{
            return true
        }
        return false
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        var RecordArray:[[Any]] = userDefaults.array(forKey: "KEY_RecordArray") as! [[Any]]

        RecordArray.swapAt(sourceIndexPath.row, destinationIndexPath.row)

        DispatchQueue.main.async {
            self.userDefaults.set(RecordArray, forKey: "KEY_recordArray")
        }
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        //override前の処理を継続してさせる
        super.setEditing(editing, animated: animated)
        //tableViewの編集モードを切り替える
        tableView.isEditing = editing
    }

    @IBAction func edit(_ sender: Any) {
        if tableView.isEditing == true{
            tableView.isEditing = false
        }
        tableView.isEditing = true
    }



    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSegue"{
            let nextVC = segue.destination as! ViewController

            nextVC.reloadData(Ind: index!)
        }
    }

    func pickDataFromKey(){
        var RecordArray = userDefaults.array(forKey: "KEY_RecordArray")
        guard let recordArray:[[Any]] =  userDefaults.array(forKey: "KEY_RecordArray") as? [[Any]] else{return}
        RecordArray = recordArray
        print(RecordArray)
    }
    



}
