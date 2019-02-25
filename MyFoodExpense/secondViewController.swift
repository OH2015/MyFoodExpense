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

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        tableView.rowHeight = 100
//        self.tableView.register(UINib(nibName: "customCell", bundle: nil), forCellReuseIdentifier: "cell")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pickDataFromKey()
        return DataArray.count
    }



    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! logTableViewCell
        let dataSet = DataArray[indexPath.row] as! [String]

        let image = UIImage(named: "flog")
        cell.setCell(imageName: image!, title: dataSet[2], date: dataSet[1])

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
        BoxArray.remove(at: indexPath.row)
        DataArray.remove(at: indexPath.row)

        DispatchQueue.main.async {
            self.userDefaults.set(BoxArray, forKey: KEY.box.rawValue)
            self.userDefaults.set(DataArray, forKey: KEY.data.rawValue)
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
        BoxArray.swapAt(sourceIndexPath.row, destinationIndexPath.row)
        DataArray.swapAt(sourceIndexPath.row, destinationIndexPath.row)

        DispatchQueue.main.async {
            self.userDefaults.set(BoxArray, forKey: KEY.box.rawValue)
            self.userDefaults.set(DataArray, forKey: KEY.data.rawValue)
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
        BoxArray = userDefaults.array(forKey: KEY.box.rawValue) as! [[[String]]]
        DataArray = userDefaults.array(forKey: KEY.data.rawValue)!
    }
    



}
