//
//  secondViewController.swift
//  MyFoodExpense
//
//  Created by 123 on 2019/02/09.
//  Copyright © 2019 123. All rights reserved.
//

import UIKit


class secondViewController: UIViewController,UITableViewDelegate,UITableViewDataSource ,UINavigationControllerDelegate,UIImagePickerControllerDelegate{

    @IBOutlet weak var tableView: UITableView!
    let userDefaults = UserDefaults.standard
    var index:Int?
    var indexPath:IndexPath?
    var fileName = ""
    var images = [String]()

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

        let image = readimage(indexPath: indexPath)
        cell.setCell(imageName: image ?? nil, title: dataSet[2], date: dataSet[1])

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

    @IBAction func imageTapped(_ sender: UIButton) {
        let cell = sender.superview?.superview as! UITableViewCell
        indexPath = tableView.indexPath(for: cell)!
        pickerController()
    }


    func fileManage(){
        let fileManager = FileManager()

        // ファイル一覧の場所であるpathを文字列で取得
        let path = Bundle.main.bundlePath
        do {
            let files = try fileManager.contentsOfDirectory(atPath: path)

            // png画像だけを集める配列を用意
            var images : [String] = []

            for file in files {
                // ファイル名の後方が.pngであればtrueとなる
                if file.hasSuffix(".png") {
                    images.append(file)
                }
            }
            print(images,"あったよ")

        }
        catch let error {
            print(error)
        }
    }

    func pickerController(){
        let pickerController = UIImagePickerController()
        pickerController.sourceType = .photoLibrary
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)

    }

    func startCamera(){

        let sourceType:UIImagePickerController.SourceType =
            UIImagePickerController.SourceType.camera
        // カメラが利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerController.SourceType.camera){
            // インスタンスの作成
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
        }
        else{
        }

    }


    func imagePickerController(_ imagePicker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        if let pickedImage = info[.originalImage] as? UIImage {
            view.contentMode = .scaleAspectFit
            let pngImageData:Data = pickedImage.pngData()!
            let documentsURL:URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            fileName = String(indexPath!.row) + ".png"
            let fileURL:URL = documentsURL.appendingPathComponent(fileName)
            do{
                try pngImageData.write(to: fileURL)

                reload()
            }catch{
                print("書き込み失敗")
            }
        }
        fileManage()
        dismiss(animated: true, completion: nil)
    }

    func readimage(indexPath:IndexPath) -> UIImage?  {
        fileName = String(indexPath.row) + ".png"
        let documentsURL:URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL:URL = documentsURL.appendingPathComponent(fileName)
        if let image = UIImage(contentsOfFile: fileURL.path){
            return image
        }
        return nil
    }

    func reload(){
//ここでファイルの名前"インデックス番号.png"を与える
        fileName = String(indexPath!.row) + ".png"
        let cell = tableView.cellForRow(at: indexPath!)
        let img = cell?.viewWithTag(1) as! UIImageView
        img.image = readimage(indexPath: indexPath!)
    }

}







