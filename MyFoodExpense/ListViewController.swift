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
let randomStrings = "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"

class ListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource ,UINavigationControllerDelegate,UIImagePickerControllerDelegate{

    @IBOutlet weak var trashButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    let systemBlueColor = UIColor(red: 0, green: 122 / 255, blue: 1, alpha: 1)
    let uds = UserDefaults.standard
    var index:Int?
    var indexPath:IndexPath?
    let fileManager = FileManager.default
    var keys = randomStrings.splitInto(8)

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100
        trashButton.isEnabled = false
        trashButton.tintColor = UIColor.clear
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
//======================================================tableView====================================================

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pickDataFromKey()
        return RecordArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! logTableViewCell
        let DataArray = RecordArray[indexPath.row]
        let title = DataArray[5][0]
        let date = DataArray[4][0]
        let name = keys[indexPath.row]
        let image:UIImage? = readimage(fileName: name)
        cell.setCell(imageName: image ?? nil, title: title, date: date)

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
// ===============================================================================================================
    @IBAction func edit(_ sender: Any) {
        tableView.isEditing = !tableView.isEditing
        if tableView.isEditing && RecordArray.count != 0{
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
    @IBAction func imageTapped(_ sender: UIButton) {
        let cell = sender.superview?.superview as! UITableViewCell
        indexPath = tableView.indexPath(for: cell)!
        pickerController()
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

//----------------------------------------------------------------------------------------------------------------

    func pickDataFromKey(){
        RecordArray = uds.array(forKey: KEY.record.rawValue) as! [[[String]]]
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

    


//===========================================画像処理==============================================================
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
            let name = keys[(indexPath?.row)!]
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
            let name = keys[indexPath.row]
            let filePath = dir.appendingPathComponent(name)
            do {
                if let _ = UIImage(contentsOfFile: filePath.path){
                    try FileManager.default.removeItem(at: filePath)
                }
                for i in indexPath.row...RecordArray.count{
                    let path = keys[i+1]
                    let path2 = keys[i]
                    let fileURL:URL = dir.appendingPathComponent(path)
                    let fileURL2:URL = dir.appendingPathComponent(path2)
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
        if let dir = fileManager.urls( for: .documentDirectory, in: .userDomainMask ).first {
            let fromName = keys[from.row]
            let toName = keys[to.row]
            let fromFilePath = dir.appendingPathComponent(fromName)
            let toFilePath = dir.appendingPathComponent(toName)
            let postFilePath = dir.appendingPathComponent("post.png")
            do {
                if let _ = UIImage(contentsOfFile: fromFilePath.path){
                    try self.fileManager.moveItem(at: fromFilePath,to: postFilePath)
                }
                if let _ = UIImage(contentsOfFile: toFilePath.path){
                    try self.fileManager.moveItem(at: toFilePath, to: fromFilePath)
                }
                if let _ = UIImage(contentsOfFile: fromFilePath.path){
                    try self.fileManager.moveItem(at: postFilePath,to: fromFilePath)
                }
            } catch {
                print(error)
            }
        }

    }





}







