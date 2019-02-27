//
//  ListViewController.swift
//  MyFoodExpense
//
//  Created by 123 on 2019/02/27.
//  Copyright © 2019 123. All rights reserved.
//


import UIKit

//DataArray = [[ingredients,prices,tax,person,date,Title]...]
var RecordArray = [[[String]]]()
class ListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource ,UINavigationControllerDelegate,UIImagePickerControllerDelegate{

    @IBOutlet weak var trashButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    let systemBlueColor = UIColor(red: 0, green: 122 / 255, blue: 1, alpha: 1)
    let uds = UserDefaults.standard
    var index:Int?
    var indexPath:IndexPath?
    let fileManager = FileManager.default

    override func viewDidLoad() {

        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100
        trashButton.isEnabled = false
        trashButton.tintColor = UIColor.clear
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pickDataFromKey()
        return RecordArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! logTableViewCell
        let DataArray = RecordArray[indexPath.row]
        let title = DataArray[5][0]
        let date = DataArray[4][0]
        let name = String(indexPath.row) + ".png"
        let image:UIImage? = readimage(fileName: name)
        cell.setCell(imageName: image ?? nil, title: title, date: date)

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

    //削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        RecordArray.remove(at: indexPath.row)
        removeImage(indexPath: indexPath)

        DispatchQueue.main.async {
            self.uds.set(RecordArray, forKey: KEY.record.rawValue)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if tableView.isEditing{
            return true
        }
        return false
    }

    //入れ替え
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        RecordArray.swapAt(sourceIndexPath.row, destinationIndexPath.row)
        swapImage(from: sourceIndexPath, to: destinationIndexPath)

        DispatchQueue.main.async {
            self.uds.set(RecordArray, forKey: KEY.record.rawValue)
        }
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        //override前の処理を継続してさせる
        super.setEditing(editing, animated: animated)
        //tableViewの編集モードを切り替える
        tableView.isEditing = editing
    }
    //編集ボタン
    @IBAction func edit(_ sender: Any) {
        tableView.isEditing = !tableView.isEditing
        if tableView.isEditing && DataArray.count != 0{
            trashButton.tintColor = systemBlueColor
            trashButton.isEnabled = true
        }else{
            trashButton.tintColor = UIColor.clear
            trashButton.isEnabled = false
        }
        let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let contentUrls = try FileManager.default.contentsOfDirectory(at: documentDirectoryURL, includingPropertiesForKeys: nil)
            let files = contentUrls.map{$0.lastPathComponent}
            print(files) //-> ["test1.txt", "test2.txt"]
        } catch {
            print(error)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSegue"{
            let nextVC = segue.destination as! ViewController

            nextVC.reloadData(Ind: index!)
        }
    }

    func pickDataFromKey(){
        RecordArray = uds.array(forKey: KEY.record.rawValue) as! [[[String]]]

    }

    @IBAction func imageTapped(_ sender: UIButton) {
        let cell = sender.superview?.superview as! UITableViewCell
        indexPath = tableView.indexPath(for: cell)!
        pickerController()
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
            let documentsURL:URL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
            let name = String(indexPath!.row) + ".png"
            let fileURL:URL = documentsURL.appendingPathComponent(name)
            do{
                try pngImageData.write(to: fileURL)
                tableView.reloadData()
            }catch{
                print("書き込み失敗")
            }
        }
        dismiss(animated: true, completion: nil)
    }

    func readimage(fileName:String) -> UIImage?  {
        let documentsURL:URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL:URL = documentsURL.appendingPathComponent(fileName)
        if let image = UIImage(contentsOfFile: fileURL.path){
            return image
        }
        return nil
    }

    func removeImage(indexPath:IndexPath){
        if let dir = fileManager.urls( for: .documentDirectory, in: .userDomainMask ).first {
            let name = String(indexPath.row)+".png"
            let filePath = dir.appendingPathComponent(name).path
            do {
                if let _ = UIImage(contentsOfFile: filePath){
                    try FileManager.default.removeItem(atPath: filePath)
                }
                for i in indexPath.row...DataArray.count{
                    let path = String(i+1)+".png"
                    let path2 = String(i)+".png"
                    let documentsURL:URL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
                    let fileURL:URL = documentsURL.appendingPathComponent(path)
                    let fileURL2:URL = documentsURL.appendingPathComponent(path2)
                    if let _ = UIImage(contentsOfFile: fileURL.path){
                        try fileManager.moveItem(at: fileURL, to: fileURL2)
                    }
                }
            } catch {
                print(error)
            }
        }
    }

    func swapImage(from:IndexPath,to:IndexPath){

    }

    @IBAction func trash(_ sender: Any) {
        let alert = UIAlertController(title: "削除しますか？", message: "全てのデータが消去されます", preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "削除", style: .destructive, handler: {_ in
            self.destroy()
        }))
        self.present(alert,animated: true)
    }

    func destroy(){
        RecordArray.removeAll()
        uds.removeObject(forKey: KEY.record.rawValue)

        let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {

            try fileManager.removeItem(at: documentDirectoryURL)
            tableView.reloadData()
        } catch  {
            print(error)
        }
        tableView.isEditing = false
        trashButton.isEnabled = false
        trashButton.tintColor = UIColor.clear
        tableView.reloadData()
    }


}







