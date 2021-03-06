//
//  PhotoPostViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/09/06.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import Firebase
import AlamofireImage

class PhotoPostViewController: UIViewController, UIImagePickerControllerDelegate ,UINavigationControllerDelegate,UITextFieldDelegate {

    @IBOutlet weak var postPhoto: UIImageView!
    var mainImageBox = UIImage()
    
    @IBOutlet weak var folName: UILabel!

    var privateStr = String()
    
    //データ
    var folderName = String()
    let uid = FIRAuth.auth()?.currentUser?.uid
    let userName = FIRAuth.auth()?.currentUser?.displayName
    var mainBool = false
    var folderNameDictionary = Dictionary<String, Dictionary<String, String?>>()
    var isPRivate = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.darkGray]
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = UIColor.darkGray
        self.navigationController?.hidesBarsOnSwipe = false
        
       
        folName.text = self.folderName
        
        self.postPhoto.layer.masksToBounds = true
        self.postPhoto.layer.cornerRadius = 15
        
        
        
    }
    

    
    @IBAction func photoTapped(_ sender: Any) {
        
        
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                
                let imagePickerController = UIImagePickerController()
                imagePickerController.delegate = self
                imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
                imagePickerController.allowsEditing = true
                self.present(imagePickerController, animated: true, completion: nil)
            } else {
                print("カメラロール許可をしていない時の処理")
                //UIViewで許可のお願いを出す
                
            }
            
        
        
    }
    
    
    
    func postButtonDidTap() {
        
        showIndicator()
        
        
        let firebasePost = DataService.dataBase.REF_USER.child(uid!).child("posts").childByAutoId()
        let key = firebasePost.key
        let keyvalue = ("\(key)")
        
        var post: Dictionary<String, AnyObject> = [
            
            
            "folderName" :  folderName as AnyObject,
            "linkURL" : "" as AnyObject,
            "pvCount" : 0 as AnyObject,
            "userID" : uid as AnyObject,
            "userName" : userName as AnyObject,
            "name" : "" as AnyObject,
            "postID" : keyvalue as AnyObject,
            "isPrivate" : self.privateStr as AnyObject
        ]
        
        
        
        //画像処理
        
        let mainImgData = UIImageJPEGRepresentation(postPhoto.image!, 0.2)
        
        let metaData = FIRStorageMetadata()
        metaData.contentType = "image/jpeg"
        let mainImgUid = NSUUID().uuidString
        
        DispatchQueue.global().async {
            
            DataService.dataBase.REF_POST_IMAGES.child(mainImgUid).put(mainImgData!, metadata: metaData) {
                (metaData, error) in
                
                if error != nil {
                    print("画像のアップロードに失敗しました")
                } else {
                    
                    print("画像のアップロードに成功しました")
                    //DBへ画像のURL飛ばす
                    let firstDownloadURL = metaData?.downloadURL()?.absoluteString
                    
                    //メイン画像を追加
                    post["imageURL"] = firstDownloadURL as AnyObject
                    
                    
                    //folder name
                    let folderInfo: Dictionary<String,String> = ["imageURL" : firstDownloadURL!, "name" : self.folderName, "isPrivate" : self.privateStr]
                    
                    self.folderNameDictionary = [self.folderName : folderInfo]
                    
                    self.mainBool = true
                    
                }
            }
            
        }
        
        
        
        
        
        
        
        self.wait( {self.mainBool == false} ) {
            
            firebasePost.setValue(post)
            DataService.dataBase.REF_BASE.child("users/\(self.uid!)/folderName").updateChildValues(self.folderNameDictionary)
            
            self.mainBool = false
            
            
            DispatchQueue.main.async {
                self.indicator.stopAnimating()
                self.performSegue(withIdentifier: "wallll", sender: nil)
                
            }
            
            
            
            
            
            
        }

        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        let rightSearchBarButtonItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.save, target: self, action: #selector(PhotoPostViewController.postButtonDidTap))
        self.navigationItem.setRightBarButtonItems([rightSearchBarButtonItem], animated: true)
        
        if postPhoto.image == nil {
            
            //self.view.backgroundColor = UIColor.rgb(r: 123, g: 34, b: 44, alpha: 1.0)
            
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                
                let imagePickerController = UIImagePickerController()
                imagePickerController.delegate = self
                imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
                imagePickerController.allowsEditing = true
                self.present(imagePickerController, animated: true, completion: nil)
            } else {
                print("カメラロール許可をしていない時の処理")
                //UIViewで許可のお願いを出す
                
                
                
                
            }
            
        }

        
        
        
        
        
    }
    
    
   
   
   
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if info[UIImagePickerControllerOriginalImage] != nil {
            
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                
                self.mainImageBox = image
                
                self.postPhoto.image = self.mainImageBox
                
                
            }
            
            
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    let indicator = UIActivityIndicatorView()
    
    func showIndicator() {
        
        indicator.activityIndicatorViewStyle = .whiteLarge
        
        indicator.center = self.view.center
        
        indicator.color = UIColor.white
        
        indicator.hidesWhenStopped = true
        
        self.view.addSubview(indicator)
        
        self.view.bringSubview(toFront: indicator)
        
        indicator.startAnimating()
        
    }
    
    
    func wait(_ waitContinuation: @escaping (()->Bool), compleation: @escaping (()->Void)) {
        var wait = waitContinuation()
        
        
        // 0.01秒周期で待機条件をクリアするまで待ちます。
        let semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.global().async {
            while wait {
                DispatchQueue.main.async {
                    wait = waitContinuation()
                    semaphore.signal()
                }
                semaphore.wait()
                Thread.sleep(forTimeInterval: 0.01)
            }
            
            
            // 待機条件をクリアしたので通過後の処理を行います。
            DispatchQueue.main.async {
                compleation()
                
                
                
            }
        }
    }
   

}
