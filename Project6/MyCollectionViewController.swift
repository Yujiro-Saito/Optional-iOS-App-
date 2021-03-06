//
//  MyCollectionViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/08/27.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import AlamofireImage


class MyCollectionViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        // ナビゲーションを透明にする処理
        
        self.navigationItem.title = "VolBox"
        
        // フォント種をTime New Roman、サイズを10に指定
        self.navigationController?.navigationBar.titleTextAttributes
            = [NSFontAttributeName: UIFont(name: "MarkerFelt-Wide", size: 20)!]
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.black]
        //self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        //self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.barTintColor = UIColor.rgb(r: 250, g: 250, b: 250, alpha: 1.0)
        // UIColor.rgb(r: 255, g: 255, b: 255, alpha: 1)
        self.navigationController?.hidesBarsOnSwipe = false
        
        
        
            }
    
    @IBOutlet weak var modalView: UIView!
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var linkImage: UIImageView!
    @IBOutlet weak var youtubeImage: UIImageView!
    @IBOutlet weak var youtubeLabel: UILabel!
    @IBOutlet weak var youtubeButton: UIButton!
    @IBAction func youtubeDidTap(_ sender: Any) {
        
        self.tabBarController?.tabBar.isHidden = false
        bottomConstraint.constant = -300
        
        self.isVideo = true
        
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
            self.backgroundButton.alpha = 0
        }
        
        
        self.isPhoto = false
        self.isVideo = true
        self.isLink = false
        
        
        
        self.performSegue(withIdentifier: "Options", sender: nil)

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        if FIRAuth.auth()?.currentUser == nil {
            performSegue(withIdentifier: "TesterLogout", sender: nil)
        } else {
            
            //ユーザーのコレクションの読み込み
            DataService.dataBase.REF_BASE.child("users").queryOrdered(byChild: "uid").queryEqual(toValue: FIRAuth.auth()?.currentUser?.uid).observe(.value, with: { (snapshot) in
                
                
                if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    
                    for snap in snapshot {
                        
                        
                        
                        if let postDict = snap.value as? Dictionary<String, AnyObject> {
                            
                            
                            
                            if postDict["followers"] as? Dictionary<String, String> == nil {
                                
                                let followerdata = ["followerNum" : 0 ]
                                
                                
                                DataService.dataBase.REF_BASE.child("users/\(FIRAuth.auth()!.currentUser!.uid)").updateChildValues(followerdata)
                                
                            }
                            
                            if postDict["following"] as? Dictionary<String, String> == nil {
                                let followingData = ["followingNum" : 0]
                                DataService.dataBase.REF_BASE.child("users/\(FIRAuth.auth()!.currentUser!.uid)").updateChildValues(followingData)
                                
                                
                            }
                            
                            
                        }
                    }
                }
            })

            
        }
        
        
        
    }
    
    
    
    @IBOutlet weak var myCollection: UICollectionView!
    var userPosts = [Post]()
    var detailPosts: Post?
    var amountOfFollowers = Int()
    var numOfFollowing = [String]()
    var numOfFollowers = [String]()
    
    //new data
    var folderNameBox = [String]()
    var folderName = String()
    var folderImageURLBox = [String]()
    var isPrivates = [String]()
    
    var isPhoto = Bool()
    var isLink = Bool()
    var postingType = Int()
    
    //data
    var isFollow = Bool()
    
    @IBOutlet weak var noBoxView: UIView!
    
   

    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
       
        myCollection.delegate = self
        myCollection.dataSource = self
        
        self.tabBarController?.tabBar.isHidden = false
        bottomConstraint.constant = -300
        

        
        
        
        //Individuals
        
        
        
        self.folderNameBox = []
        self.folderImageURLBox = []
        
        
        
        //ユーザーのコレクションの読み込み
        DataService.dataBase.REF_BASE.child("users").queryOrdered(byChild: "uid").queryEqual(toValue: FIRAuth.auth()?.currentUser?.uid).observe(.value, with: { (snapshot) in
            
            self.userPosts = []
            self.folderNameBox = []
            self.folderImageURLBox = []
            self.isPrivates = []
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshot {
                    
                    
                                        
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        
                    /*
                        if postDict["followers"] as? Dictionary<String, String> == nil {
                            
                            let followerdata = ["followerNum" : 0 ]
                            
                            
                            DataService.dataBase.REF_BASE.child("users/\(FIRAuth.auth()!.currentUser!.uid)").updateChildValues(followerdata)
                            
                        }
                        
                        if postDict["following"] as? Dictionary<String, String> == nil {
                            let followingData = ["followingNum" : 0]
                            DataService.dataBase.REF_BASE.child("users/\(FIRAuth.auth()!.currentUser!.uid)").updateChildValues(followingData)
                            
                            
                        }
*/
                        
                        
                       /*
                        if postDict["followingNum"] as? Int == nil {
                            print("おおおおおおおおおおおおお")
                            
                            
                            let followingData = ["followingNum" : 0]
                            DataService.dataBase.REF_BASE.child("users/\(FIRAuth.auth()!.currentUser!.uid)").updateChildValues(followingData)
                            
                        } else {
                            
                        }
                        
                        if postDict["followerNum"] as? Int == nil {
                            
                            let followerdata = ["followerNum" : 0 ]
                            
                            
                            DataService.dataBase.REF_BASE.child("users/\(FIRAuth.auth()!.currentUser!.uid)").updateChildValues(followerdata)
                        } else {
                            
                        }
                        */
                        
                        
                        //guard postDict["followerNum"] as? Int != nil else {
                         ///   print("iiiiいいいあああああああああああああ")
                        //}
                        
                       // guard postDict["followingNum"] as? Int != nil else {
                       ///     print("uuuuuuuuいいいあああああああああああああ")
                       // }
                        
                       

                        
                        
                        
                        if postDict["folderName"] as? Dictionary<String, Dictionary<String, AnyObject?>> != nil {
                            
                            
                            let folderName = postDict["folderName"] as? Dictionary<String, Dictionary<String, String>>
                            
                            for (key,value) in folderName! {
                                
                                let valueImageURL = value["imageURL"] as! String
                                let valueText = value["name"] as! String
                                let isLocked = value["isPrivate"] as! String
                                self.folderImageURLBox.append(valueImageURL)
                                self.folderNameBox.append(valueText)
                                self.isPrivates.append(isLocked)
                                
                                
                            }
                            
                            
                            
                            
                        }
                        
                    }
                    
                    
                    
                }
                
                
                
                
                
            }
            
            
            self.isPrivates.reverse()
            self.folderNameBox.reverse()
            self.folderImageURLBox.reverse()
            
            self.myCollection.reloadData()
            
            if self.folderNameBox.count == 0 {
                self.noBoxView.isHidden = false
            } else {
                self.noBoxView.isHidden = true
            }
            
            
            
        })
        
        
       
        
        
        
    }
    
    
    
    @IBAction func toFollowing(_ sender: Any) {
        performSegue(withIdentifier: "followingLists", sender: nil)
    }
    
    @IBAction func toFollower(_ sender: Any) {
        performSegue(withIdentifier: "followLists", sender: nil)
    }
    
    
    
  
    
    
    
    //traditional
    
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var mainButton: UIButton!
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var photoLabel: UILabel!
    @IBOutlet weak var linkButton: UIButton!
    @IBOutlet weak var linkLabel: UILabel!
    
    
    
    
    //Base 
    @IBOutlet weak var appLabel: UILabel!
    @IBOutlet weak var musicLabel: UILabel!
    @IBOutlet weak var movieLabel: UILabel!
    @IBOutlet weak var bookLabel: UILabel!
    
    @IBOutlet weak var appImage: UIImageView!
    @IBOutlet weak var musicImage: UIImageView!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var bookImage: UIImageView!
    
    @IBOutlet weak var AppButton: UIButton!
    @IBOutlet weak var musicButton: UIButton!
    @IBOutlet weak var movieButton: UIButton!
    @IBOutlet weak var bookButton: UIButton!
    
    @IBAction func appTapped(_ sender: Any) {
        
        
        self.postingType = 0
        self.tabBarController?.tabBar.isHidden = false
        bottomConstraint.constant = -300
        
        
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
            
            
            self.backgroundButton.alpha = 0
            
            
            
        }
        performSegue(withIdentifier: "ItemSearch", sender: nil)
    }
    
    @IBAction func musicTapped(_ sender: Any) {
        
        self.postingType = 1
        self.tabBarController?.tabBar.isHidden = false
        bottomConstraint.constant = -300
        
        
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
            
            
            self.backgroundButton.alpha = 0
            
            
            
        }
        performSegue(withIdentifier: "ItemSearch", sender: nil)
    }
    
    @IBAction func movieTapped(_ sender: Any) {
        self.postingType = 2
        self.tabBarController?.tabBar.isHidden = false
        bottomConstraint.constant = -300
        
        
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
            
            
            self.backgroundButton.alpha = 0
            
            
            
        }
        performSegue(withIdentifier: "ItemSearch", sender: nil)
    }
    
    @IBAction func bookTapped(_ sender: Any) {
        self.postingType = 3
        self.tabBarController?.tabBar.isHidden = false
        bottomConstraint.constant = -300
        
        
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
            
            
            self.backgroundButton.alpha = 0
            
            
            
        }
        performSegue(withIdentifier: "ItemSearch", sender: nil)
    }
    
    
    
    @IBOutlet weak var backgroundButton: UIButton!
    
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBAction func closeModal(_ sender: Any) {
        
        self.tabBarController?.tabBar.isHidden = false
        bottomConstraint.constant = -300
        
        
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
            
            
            self.backgroundButton.alpha = 0
            
            
            
        }

        
        
    }
    
    
    
    @IBAction func newFolder(_ sender: Any) {
        self.tabBarController?.tabBar.isHidden = false
        bottomConstraint.constant = -300
        
        
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
            
            
            self.backgroundButton.alpha = 0
            
            
            
        }
        self.performSegue(withIdentifier: "MakeFolder", sender: nil)
    }
    
    
    @IBAction func photo(_ sender: Any) {
        self.tabBarController?.tabBar.isHidden = false
        bottomConstraint.constant = -300
        
        
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
            self.backgroundButton.alpha = 0
        }
        self.isPhoto = true
        self.isLink = false
        self.isVideo = false
        self.performSegue(withIdentifier: "Options", sender: nil)
    }
    
    @IBAction func link(_ sender: Any) {
        self.tabBarController?.tabBar.isHidden = false
        bottomConstraint.constant = -300
        
        
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
            
            self.backgroundButton.alpha = 0
            
        }
        
        self.isPhoto = false
        self.isVideo = false
        self.isLink = true
        
        self.performSegue(withIdentifier: "Options", sender: nil)
        
        
    }
    
    @IBAction func actionButtonDidTap(_ sender: Any) {
        
        self.tabBarController?.tabBar.isHidden = true
        
        bottomConstraint.constant = 0
        
        
        UIView.animate(withDuration: 0.15) {
            self.view.layoutIfNeeded()
            
            
            self.backgroundButton.alpha = 0.5
            
            
            
        }
        
        
        
        
    }
    
    @IBAction func editing(_ sender: Any) {
        
        
        performSegue(withIdentifier: "edit", sender: nil)
        
        
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return folderNameBox.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = myCollection.dequeueReusableCell(withReuseIdentifier: "myCollectionCell", for: indexPath) as? MyCollectionViewCell
        
        
        //読み込むまで画像は非表示
        cell?.itemImage.image = nil
        cell?.bgView.layer.cornerRadius = 3.0
        
        cell?.bgView.layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.7).cgColor
        
        cell?.bgView.layer.shadowOpacity = 0.9
        cell?.bgView.layer.shadowRadius = 5.0
        cell?.bgView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        
        cell?.bgView.layer.borderWidth = 1.0
        cell?.bgView.layer.borderColor = UIColor.white.cgColor // 枠線の色
        
        
        
        
        if self.isPrivates[indexPath.row] == "YES" {
            cell?.lockButton.isHidden = false
        } else if self.isPrivates[indexPath.row] == "NO" {
            cell?.lockButton.isHidden = true
        } else {
            cell?.lockButton.isHidden = false
        }
        
        cell?.itemTitleLabel.text = folderNameBox[indexPath.row]
        
        let photoURL = FIRAuth.auth()?.currentUser?.photoURL
        
        if folderImageURLBox[indexPath.row] == "" {
            cell?.itemImage.af_setImage(withURL: photoURL!)
        } else if folderImageURLBox[indexPath.row] != "" {
            cell?.itemImage.af_setImage(withURL:  URL(string: self.folderImageURLBox[indexPath.row])!)
        }
        
        
       
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let screenWidth = UIScreen.main.bounds.width
        //let scaleFactor = (screenWidth / 3) - 4
        //let scaleFactor = screenWidth - 32
        let cellSize:CGFloat = self.view.frame.size.width/2-2

        return CGSize(width: cellSize, height: cellSize)
    }
    
    //縦の間隔を決定する
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    //横の間隔
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    
     func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        let headerView = myCollection.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Head", for: indexPath) as! SectionHeaderCollectionReusableView
        
        
        
            headerView.profImage.layer.borderWidth = 3.0
            headerView.profImage.layer.borderColor = UIColor.white.cgColor // 枠線の色
        
        
        /*
            headerView.separator.setTitle("Basic", forSegmentAt: 0)
            headerView.separator.setTitle("自分", forSegmentAt: 1)
            headerView.separator.backgroundColor = UIColor.clear
            headerView.separator.tintColor = UIColor.white
        */
        
        
        
                
                //////////////////////
                let user = FIRAuth.auth()?.currentUser
        
        
        
        if user == nil {
            performSegue(withIdentifier: "TesterLogout", sender: nil)
        } else {
            
            
            let userName = user?.displayName
            let photoURL = user?.photoURL
            let selfUID = user?.uid
            
            
            
            
            
            //ユーザー名
            headerView.userProfileName.text = userName
            
            
            //ユーザーのプロフィール画像
            if photoURL != nil {
                
                headerView.profImage.af_setImage(withURL: photoURL!)
            }
            
            
            //Followのチェック follower数のチェック
            DataService.dataBase.REF_BASE.child("users").queryOrdered(byChild: "uid").queryEqual(toValue: selfUID!).observe(.value, with: { (snapshot) in
                
                
                if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    
                    for snap in snapshot {
                        print("SNAP: \(snap)")
                        
                        if let postDict = snap.value as? Dictionary<String, AnyObject> {
                            
                            //followwer人数をラベルに表示
                            if postDict["followerNum"] as? Int != nil {
                                let countOfFollowers = postDict["followerNum"] as? Int
                                headerView.followerLabel.text = String(describing: countOfFollowers!)
                                self.amountOfFollowers = countOfFollowers!

                            } else {
                                headerView.followerLabel.text = "0"
                            }
                                
                                
                                
                                
                                
                                
                                
                                
                            //let countOfFollowers = postDict["followerNum"] as? Int
                            //headerView.followerLabel.text = String(describing: countOfFollowers!)
                            
                            
                            //self.amountOfFollowers = countOfFollowers!
                            
                            
                            //let follwingount = postDict["followingNum"] as? Int
                            //headerView.followingLabel.text = String(describing: follwingount!)
                            //self.amountOfFollowers = countOfFollowers!
                            
                            if postDict["followingNum"] as? Int != nil {
                                let follwingount = postDict["followingNum"] as? Int
                                headerView.followingLabel.text = String(describing: follwingount!)
                                //self.amountOfFollowers = countOfFollowers!
                                
                            } else {
                                headerView.followingLabel.text = "0"
                            }
                            
                            
                            
                            if postDict["following"] as? Dictionary<String, AnyObject?> != nil {
                                
                                let followingDictionary = postDict["following"] as? Dictionary<String, AnyObject?>
                                
                                
                                
                                
                                for (followKey,followValue) in followingDictionary! {
                                    
                                    print("キーは\(followKey)、値は\(followValue)")
                                    
                                    self.numOfFollowing.append(followKey)
                                    
                                    
                                }
                                
                            }
                            
                        }
                        
                    }
                }
                
            })
            
            
            //フォロー数
            //headerView.followingLabel.text = String(self.numOfFollowing.count)
            
            self.numOfFollowing = []
            
            
            return headerView
            
        }
        
        return headerView
    }
    
    var numInt = Int()
    //Item Tapped
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //detailPosts = self.userPosts[indexPath.row]
        
        
        folderName = self.folderNameBox[indexPath.row]
        
        
        
        performSegue(withIdentifier: "toysToFun", sender: nil)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ItemSearch" {
          
            let itemSearchVC = (segue.destination as? AddbasicsViewController)!
            
            
            
            
        
            
            
        } else if segue.identifier == "followLists" {
            
            let followVC = (segue.destination as? FriendsListsViewController)!
            
            let currentUserID = FIRAuth.auth()?.currentUser?.uid
            
            followVC.userID = currentUserID!
            
            followVC.isFollowing = false
            
            
        } else if segue.identifier == "followingLists" {
            
            
            let followVC = (segue.destination as? FriendsListsViewController)!
            
            let currentUserID = FIRAuth.auth()?.currentUser?.uid
            
            followVC.userID = currentUserID!
            
            followVC.isFollowing = true
        } else if segue.identifier == "toysToFun" {
            
            let another = (segue.destination as? MyToysViewController)!
            
            
            another.folderName = folderName
            
            another.isFriend = false
            
            
          
            
        } else if segue.identifier == "Options" {
            
            let optionVC = (segue.destination as? FolderNameListsViewController)!
            optionVC.photoData = isPhoto
            optionVC.linkData = isLink
            optionVC.isYoutube = self.isVideo
            
        }
       
        
        
        
        
    }
    
    var isVideo = Bool()
    
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
