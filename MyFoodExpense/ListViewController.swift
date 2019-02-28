//
//  ListViewController.swift
//  MyFoodExpense
//
//  Created by 123 on 2019/02/27.
//  Copyright © 2019 123. All rights reserved.
//


import UIKit



class ListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource ,UINavigationControllerDelegate,UIImagePickerControllerDelegate{


    @IBOutlet weak var trashButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    let systemBlueColor = UIColor(red: 0, green: 122 / 255, blue: 1, alpha: 1)
    let uds = UserDefaults.standard
    var index:Int?
    var indexPath:IndexPath?
    let fileManager = FileManager.default
    var sortFlag = false

    var sendImage:UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlValueChanged(sender:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        trashButton.isEnabled = false
        trashButton.tintColor = UIColor.clear
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showImage"{
            let imgVC = segue.destination as! imageViewController
            imgVC.img = self.sendImage
            imgVC.row = indexPath!.row
        }else if segue.identifier == "detailSegue"{
            let detailVC = segue.destination as! DetailViewController
            detailVC.Row = indexPath!.row
        }

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
        var totalPrice = 0
        for price in DataArray[1]{
            totalPrice += Int(price)!
        }
        let name = "\(indexPath.row).JPEG"
        let image:UIImage? = readimage(fileName: name)
        cell.setCell(imageName: image ?? nil, title: title, date: date,price:String(totalPrice))

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.indexPath = indexPath
        performSegue(withIdentifier: "detailSegue", sender: nil)

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
    @objc func refreshControlValueChanged(sender: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            sender.endRefreshing()
        })
        tableView.reloadData()
        print("テーブルを下に引っ張った時に呼ばれる")
    }
// ======================================================================================
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
        let imageView = cell.viewWithTag(1) as! UIImageView
        if let img = imageView.image{
            sendImage = img
            performSegue(withIdentifier: "showImage", sender: nil)
        }else{
            let actionSheet = UIAlertController(title: "画像を追加します", message: "", preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "アルバムから追加する", style: .default, handler: {_ in
                self.openAlbum()
                }))
            actionSheet.addAction(UIAlertAction(title: "カメラで撮影する", style: .default, handler: {_ in
                self.launchCamera()
            }))
            actionSheet.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
            self.present(actionSheet, animated: true, completion: nil)
        }
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

    @IBAction func sortButtonTapped(_ sender: Any) {
        sort()
    }


//===================================================================================

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
    func openAlbum(){
        let pickerController = UIImagePickerController()
        pickerController.sourceType = .photoLibrary
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }

    func launchCamera(){
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
            writeImageAsJPEG(img: pickedImage, row: indexPath!.row)
        }
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }


    func writeImageAsJPEG(img:UIImage,row:Int){
        let quality:CGFloat = 0.1
        let pngImageData:Data = img.jpegData(compressionQuality: quality)!
        let documentsURL:URL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let name = "\(row).JPEG"
        let fileURL:URL = documentsURL.appendingPathComponent(name)
        do{
            try pngImageData.write(to: fileURL)
        }catch{
            print("書き込み失敗")
        }

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
            let name = "\(indexPath.row).JPEG"
            let filePath = dir.appendingPathComponent(name)
            do {
                if let _ = UIImage(contentsOfFile: filePath.path){
                    try FileManager.default.removeItem(at: filePath)
                }
                for i in indexPath.row...RecordArray.count{
                    let path = "\(i+1).JPEG"
                    let path2 = "\(i).JPEG"
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
            let fromName = "\(from.row).JPEG"
            let toName = "\(to.row).JPEG"
            let fromFilePath = dir.appendingPathComponent(fromName)
            let toFilePath = dir.appendingPathComponent(toName)
            let postFilePath = dir.appendingPathComponent("postFile")
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

    func sort(){
        RecordArray = uds.array(forKey: KEY.record.rawValue) as! [[[String]]]
        var date = [String]()
        for i in 0...RecordArray.count-1{
            date.append(RecordArray[i][4][0])
        }
        var newRecordArray = [[[String]]]()
        if sortFlag{
            let sortedEnumDate = date.enumerated().sorted{$0 > $1}
            for sortedDate in sortedEnumDate{
                newRecordArray.append(RecordArray[sortedDate.offset])
            }
        }else{
            let sortedEnumDate = date.enumerated().sorted{$1 > $0}
            for sortedDate in sortedEnumDate{
                newRecordArray.append(RecordArray[sortedDate.offset])
            }
        }

        DispatchQueue.main.async {
            RecordArray = newRecordArray
            self.uds.set(RecordArray, forKey: KEY.record.rawValue)
        }
        sortFlag = !sortFlag
        tableView.reloadData()
    }





}







