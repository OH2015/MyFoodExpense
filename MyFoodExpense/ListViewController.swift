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
    var sectionFlgs = [Bool]()
    var oldDateComponents = [DateComponents]()
    let GVC = GraphViewController()

    var sendImage:UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        pickDataFromKey()
        sectionFlgs = [Bool](repeating: true, count: stringMonths().count)
        tableView.delegate = self
        tableView.dataSource = self
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlValueChanged(sender:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        trashButton.isEnabled = false
        trashButton.tintColor = UIColor.clear
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = tableView.cellForRow(at: indexPath!) as! logTableViewCell
        if segue.identifier == "showImage"{
            let imgVC = segue.destination as! imageViewController
            imgVC.img = self.sendImage
            imgVC.row = cell.tag
        }else if segue.identifier == "detailSegue"{
            let detailVC = segue.destination as! DetailViewController
            detailVC.Row = cell.tag
        }

    }
//======================================================tableView====================================================

    func numberOfSections(in tableView: UITableView) -> Int {
        pickDataFromKey()
        oldDateComponents = dateComponentsByMonth()
        return stringMonths().count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Header") as? CustomHeaderFooterView
        if cell == nil {
            cell = CustomHeaderFooterView(reuseIdentifier: "Header")
            cell?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapHeader)))
        }
        cell!.tag = section
        cell!.textLabel!.text = stringMonths()[section]
        cell!.textLabel!.textColor = UIColor.black
        cell!.section = section
        cell!.setExpanded(expanded:sectionFlgs[section])
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let recordsInMonth = RecordArray.filter{GVC.strToDateComponents(strDate: $0[4][0]) == dateComponentsByMonth()[section]}
        if sectionFlgs[section]{
            return recordsInMonth.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! logTableViewCell
        let RecordTuple = RecordArray.enumerated()
        let filterdRecordTuple = RecordTuple.filter{GVC.strToDateComponents(strDate: $0.element[4][0]) == dateComponentsByMonth()[indexPath[0]]}
        let DataTuple = filterdRecordTuple[indexPath.row]
        let DataArray = DataTuple.element
        let row = DataTuple.offset

//RecordArrayの中で何番めか
        cell.tag = row
        let title = DataArray[5][0]
        let totalPrice = DataArray[6][0]
        let name = "\(DataArray[4][0]).JPEG"
        let image:UIImage? = readimage(fileName: name)
        let dateComponents = GVC.stringToDateComponents(strDate:DataArray[4][0])
        let strDate = dateComponentsToString(dateComponents: dateComponents)
        cell.setCell(imageName: image ?? nil, title: title,price:String(totalPrice),date:strDate)

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
        let cell = tableView.cellForRow(at: indexPath) as! logTableViewCell
        let queue = DispatchQueue(label: "queue")
        queue.sync {
            self.removeImage(row: cell.tag)
        }
        RecordArray.remove(at: cell.tag)
        self.uds.set(RecordArray, forKey: KEY.record.rawValue)
        let recordsInMonth = RecordArray.filter{GVC.strToDateComponents(strDate: $0[4][0]) == oldDateComponents[indexPath.section]}
        if recordsInMonth.count == 0{
            sectionFlgs.remove(at: indexPath.section)
            tableView.reloadData()
        }else{
            tableView.deleteRows(at: [indexPath], with: .automatic)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5){
                tableView.reloadData()
            }
        }
        oldDateComponents = dateComponentsByMonth()
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if tableView.isEditing{
            return true
        }
        return false
    }

    //入れ替え
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let souceCell = tableView.cellForRow(at: sourceIndexPath) as! logTableViewCell
        let destinationCell = tableView.cellForRow(at: destinationIndexPath) as! logTableViewCell
        RecordArray.swapAt(souceCell.tag, destinationCell.tag)

        DispatchQueue.main.async {
            self.uds.set(RecordArray, forKey: KEY.record.rawValue)
        }
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.isEditing = editing
    }
    @objc func refreshControlValueChanged(sender: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            sender.endRefreshing()
        })
        tableView.reloadData()
    }

    @objc func tapHeader(gestureRecognizer: UITapGestureRecognizer) {
        guard let section = gestureRecognizer.view?.tag as Int! else {return}
        sectionFlgs[section] = !sectionFlgs[section]
        tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .none)
//        tableView.reloadData()
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
    }

    @IBAction func imageTapped(_ sender: UIButton) {
        let cell = sender.superview?.superview as! logTableViewCell
        let name = "\(RecordArray[cell.tag][4][0]).JPEG"
        indexPath = tableView.indexPath(for: cell)!
        if let img = readimage(fileName: name){
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

    @IBAction func sortButtonTapped(_ sender: UIBarButtonItem) {
        sender.title = sortFlag ? "日付(降順)":"日付(昇順)"
        sort()
    }

    @IBAction func closeSections(_ sender: UIBarButtonItem) {
        sectionFlgs = sectionFlgs.map{_ in false}
        tableView.reloadData()
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
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerController.SourceType.camera){
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
        }

    }

    func imagePickerController(_ imagePicker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        if let pickedImage = info[.originalImage] as? UIImage {
            let cell = tableView.cellForRow(at: indexPath!) as! logTableViewCell
            writeImageAsJPEG(img: pickedImage, row: cell.tag)
        }
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }


    func writeImageAsJPEG(img:UIImage,row:Int){
        let quality:CGFloat = 0.1
        let pngImageData:Data = img.jpegData(compressionQuality: quality)!
        let documentsURL:URL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let name = "\(RecordArray[row][4][0]).JPEG"
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

    func removeImage(row:Int){
        if let dir = fileManager.urls( for: .documentDirectory, in: .userDomainMask ).first {
            let name = "\(RecordArray[row][4][0]).JPEG"
            let filePath = dir.appendingPathComponent(name)
            do {
                if let _ = UIImage(contentsOfFile: filePath.path){
                    try FileManager.default.removeItem(at: filePath)
                }
            } catch {
                print(error)
            }
        }
    }

// ==================================================================================

    func sort(){
// 要変更
        RecordArray = uds.array(forKey: KEY.record.rawValue) as! [[[String]]]
        var times = [Date]()
        if RecordArray.count == 0{return}
        for i in 0...RecordArray.count-1{
            let dateComponents = GVC.stringToDateComponents(strDate: RecordArray[i][4][0])
            let time = Calendar.current.date(from: dateComponents)
            times.append(time!)
        }
        let enumtimes = times.enumerated()
        var newRecordArray = [[[String]]]()

        let sortedEnumTimes = sortFlag ? enumtimes.sorted{$0.element > $1.element}:enumtimes.sorted{$0.element < $1.element}
        for sortedTime in sortedEnumTimes{
            newRecordArray.append(RecordArray[sortedTime.offset])
        }

        DispatchQueue.main.async {
            RecordArray = newRecordArray
            self.uds.set(RecordArray, forKey: KEY.record.rawValue)
            self.sortFlag = !self.sortFlag
            self.tableView.reloadData()
        }
    }

    func dateComponentsToString(dateComponents:DateComponents)->String{
        let f = DateFormatter()
        f.locale = Locale(identifier: "ja_JP")
        f.dateFormat = DateFormatter.dateFormat(fromTemplate: "d日", options: 0, locale: .current)
        let date = Calendar.current.date(from: dateComponents)
        let strDate = f.string(from: date!)
        return strDate
    }

    func dateComponentsByMonth()->[DateComponents]{
        RecordArray = uds.array(forKey: KEY.record.rawValue) as! [[[String]]]
        var months = [DateComponents]()
        for DataArray in RecordArray{
            let strDate = DataArray[4][0]
            print("\(strDate)strDAte")
            let dateComponents = GVC.strToDateComponents(strDate: strDate)
            if !(months.contains(dateComponents)){
                months.append(dateComponents)
            }
        }
        return months

    }

    func stringMonths()->[String]{
        let f = DateFormatter()
        f.locale = Locale(identifier: "ja_JP")
        f.dateFormat = DateFormatter.dateFormat(fromTemplate: "yM", options: 0, locale: .current)
//[DateComponents]>[Date]>[String]
        let months = dateComponentsByMonth().map{Calendar.current.date(from: $0)}
        let stringMonths = months.map{f.string(from: $0 as! Date)}
        return stringMonths
    }
}







