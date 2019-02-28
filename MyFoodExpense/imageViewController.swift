//
//  imageViewController.swift
//  MyFoodExpense
//
//  Created by 123 on 2019/02/27.
//  Copyright © 2019 123. All rights reserved.
//

import UIKit

class imageViewController: UIViewController ,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    var img:UIImage?
    var row:Int?

    @IBOutlet weak var imageView: UIImageView!
    let fileManager = FileManager.default

    override func viewDidLoad() {
        super.viewDidLoad()
        if let img = img{
            imageView.image = img
        }

    }

    @IBAction func close(_ sender: Any) {
        let storyboard = self.storyboard!
        let nextView = storyboard.instantiateViewController(withIdentifier: "listNavigationController") as! UINavigationController

        self.present(nextView, animated: true, completion: nil)
//        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func done(_ sender: Any) {
        let listVC = ListViewController()
        listVC.writeImageAsJPEG(img: imageView.image!, row: row!)
        dismiss(animated: true, completion: nil)
    }

    @IBAction func album(_ sender: Any) {
        openAlbum()
    }
    
    @IBAction func camera(_ sender: Any) {
        launchCamera()
    }

//==========================================================================================
    func openAlbum(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let pickerController = UIImagePickerController()
            pickerController.sourceType = .photoLibrary
            pickerController.delegate = self
            present(pickerController, animated: true, completion: nil)
        }
    }

    func launchCamera(){
        let sourceType:UIImagePickerController.SourceType = UIImagePickerController.SourceType.camera
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
        }

    }
    func imagePickerController(_ imagePicker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        if let pickedImage = info[.originalImage] as? UIImage{
            view.contentMode = .scaleAspectFit
            imageView.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }

}
