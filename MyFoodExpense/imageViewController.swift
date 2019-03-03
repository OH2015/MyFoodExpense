//
//  imageViewController.swift
//  MyFoodExpense
//
//  Created by 123 on 2019/02/27.
//  Copyright © 2019 123. All rights reserved.
//

import UIKit

class imageViewController: UIViewController ,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate{
    var img:UIImage?
    var row:Int?
    var currentScale:CGFloat = 1.0

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    let fileManager = FileManager.default

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.0
        scrollView.isScrollEnabled = true
        let doubleTapGesture = UITapGestureRecognizer(target: self, action:#selector(self.doubleTap))
        doubleTapGesture.numberOfTapsRequired = 2
        self.imageView.addGestureRecognizer(doubleTapGesture)
        if let img = img{
            imageView.image = img
        }
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    @objc func doubleTap(gesture: UITapGestureRecognizer){
        if (self.scrollView.zoomScale < self.scrollView.maximumZoomScale) {
            let newScale = self.scrollView.zoomScale * 3
            let zoomRect = self.zoomRectForScale(scale: newScale, center: gesture.location(in: gesture.view))
            self.scrollView.zoom(to: zoomRect, animated: true)
        } else {
            self.scrollView.setZoomScale(1.0, animated: true)
        }
    }

    func zoomRectForScale(scale:CGFloat, center: CGPoint) -> CGRect{
        let size = CGSize(
            width: self.scrollView.frame.size.width / scale,
            height: self.scrollView.frame.size.height / scale
        )
        return CGRect(
            origin: CGPoint(
                x: center.x - size.width / 2.0,
                y: center.y - size.height / 2.0
            ),
            size: size
        )
    }

    @IBAction func close(_ sender: Any) {
        let storyboard = self.storyboard!
        let nextView = storyboard.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
        nextView.selectedIndex = 1

        self.present(nextView, animated: false, completion: nil)
//        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func done(_ sender: Any) {
        let listVC = ListViewController()
        listVC.writeImageAsJPEG(img: imageView.image!,row: row!)
        let storyboard = self.storyboard!
        let nextView = storyboard.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
        nextView.selectedIndex = 1

        self.present(nextView, animated: false, completion: nil)

    }

    @IBAction func album(_ sender: Any) {
        openAlbum()
    }
    
    @IBAction func camera(_ sender: Any) {
        launchCamera()
    }

    @IBAction func share(_ sender: Any) {
        guard let shareImage = imageView.image else {return}
        let sharedText = "シェアします"
        let activities = [sharedText,shareImage] as [Any]
        let activityVC = UIActivityViewController(activityItems: activities, applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
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
