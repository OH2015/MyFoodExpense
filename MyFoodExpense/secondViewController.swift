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
        let DataArray:[[String]] = userDefaults.array(forKey: "KEY_dataArray") as! [[String]]
        titles = DataArray[18]
        return titles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dataCell", for: indexPath)
        let userDefaults = UserDefaults.standard
        let DataArray:[[String]] = userDefaults.array(forKey: "KEY_dataArray") as! [[String]]
        cell.textLabel?.text = DataArray[18][indexPath.row]
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        performSegue(withIdentifier: "showSegue", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSegue"{
            let userDefaults = UserDefaults.standard
            let nextVC:ViewController = segue.destination as! ViewController
            let DataArray:[[String]] = userDefaults.array(forKey: "KEY_dataArray") as! [[String]]

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

            print(DataArray)

            DispatchQueue.main.async {
                nextVC.reloadData()
            }
        }

    }

    func reloadTableViewData(){
        tableView.reloadData()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
