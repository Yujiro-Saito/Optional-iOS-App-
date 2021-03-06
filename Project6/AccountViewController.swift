//
//  AccountViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/06/27.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import Firebase
import AlamofireImage
import SafariServices


class AccountViewController: UIViewController,UINavigationBarDelegate, UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate {
    
    
    @IBOutlet weak var profilePostTable: UITableView!
    @IBOutlet weak var profileNavBar: UINavigationBar!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileImage: ProfileImage!
    @IBOutlet weak var nonRegisterView: UIView!
    @IBOutlet weak var profileDescLabel: UILabel!
    @IBOutlet weak var profileCard: UIView!
    
    
    
    @IBOutlet weak var scroller: UIScrollView!
    
    
    var realUserName: String?
    var initialURL = URL(string: "")
    
    var userPosts = [Post]()
    var detailPosts: Post?
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    var deleteCheck = false
    
    
   
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.scroller.isAtBottom == true {
            //テーブルビューのスクロール許可
            self.profilePostTable.isScrollEnabled = true
            
            
            
        } else {
            //テーブルビューのスクロール許可しない
            if profilePostTable.isAtTop == false {
                self.profilePostTable.isScrollEnabled = true
            } else {
                self.profilePostTable.isScrollEnabled = false
            }
            
            
        }

    }
    
    
    @IBAction func goUser(_ sender: Any) {
        
        do {
            
            
            let userDefaults = UserDefaults.standard
            userDefaults.removeObject(forKey: "previousCounts")
            
            try FIRAuth.auth()?.signOut()
            
            
            
            
            self.performSegue(withIdentifier: "logout", sender: nil)
        } catch let error as NSError {
            print("\(error.localizedDescription)")
        }

    }
    
    
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        scroller.delegate = self
        
        profilePostTable.delegate = self
        profilePostTable.dataSource = self
        profileNavBar.delegate = self
        
        self.profilePostTable.isScrollEnabled = false
        
        self.nonRegisterView.isHidden = true
        
        //バーの高さ
        self.profileNavBar.frame = CGRect(x: 0,y: 0, width: UIScreen.main.bounds.size.width, height: 60)
        
        
        
        self.profilePostTable.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        
        
        
        
       
    }
    
    @IBAction func postDataDidTap(_ sender: Any) {
        
        
        
        performSegue(withIdentifier: "postData", sender: nil)
        
    }
    
    let currentUserCheck = FIRAuth.auth()?.currentUser
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        
        
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        
        self.nonRegisterView.isHidden = false
       
        var anonymousUser = currentUserCheck!.isAnonymous
        
        if anonymousUser == true {
            //ゲストユーザー
            print("匿名")
            print(currentUserCheck?.displayName!)
            self.nonRegisterView.isHidden = false
        } else if anonymousUser == false {
            //
            self.nonRegisterView.isHidden = true
            
            let user = FIRAuth.auth()?.currentUser
            
            let userName = user?.displayName
            let photoURL = user?.photoURL
            let uid = user?.uid
            
            print("ユーザーあり")
            print(userName)
            print(photoURL)
            print(uid)
            
            self.profileName.text = userName
            
            
            if photoURL == nil {
                profileImage.image = UIImage(named: "AddPhoto")
            } else {
                profileImage.af_setImage(withURL: photoURL!)
            }
        }
        
        
        
        
            
            DataService.dataBase.REF_BASE.child("posts").queryOrdered(byChild: "userID").queryEqual(toValue: FIRAuth.auth()?.currentUser?.uid).observe(.value, with: { (snapshot) in
                
                self.userPosts = []
                print(snapshot.value)
                
                if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    
                    for snap in snapshot {
                        print("SNAP: \(snap)")
                        
                        if let postDict = snap.value as? Dictionary<String, AnyObject> {
                            
                            let key = snap.key
                            let post = Post(postKey: key, postData: postDict)
                            
                            self.userPosts.append(post)
                            
                            
                            
                        }
                        
                        
                    }
                    
                    
                }
                
                
                self.userPosts.reverse()
                self.profilePostTable.reloadData()
                
                
                
                
            })
        
        
        
        DataService.dataBase.REF_BASE.child("users").queryOrdered(byChild: "uid").queryEqual(toValue: FIRAuth.auth()?.currentUser?.uid).observe(.value, with: { (snapshot) in
            
            //ユーザーのデータ取得
            
            
            print(snapshot.value)
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        
                        let profileDesc = postDict["profileDesc"] as! String?
                        
                        self.profileDescLabel.text = profileDesc
                        
                        
                            let key = snap.key
                            let post = Post(postKey: key, postData: postDict)
                            
                        
                       
                        
                        
                        
                        
                    }
                    
                    
                }
                
                
            }
        
            
            
        })
        
        
        
        
        
        
        
        
        
        
        
        
        }
    
    
        
            
    
            
            
            
    
            
    
            
    
        
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
      
        detailPosts = self.userPosts[indexPath.row]
        
        performSegue(withIdentifier: "ToDetail", sender: nil)
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ToDetail" {
            
            let detailVc = (segue.destination as? InDetailViewController)!
            
            detailVc.name = detailPosts?.name
            detailVc.numLikes = (detailPosts?.pvCount)!
            detailVc.whatContent = detailPosts?.whatContent
            detailVc.imageURL = detailPosts?.imageURL
            detailVc.linkURL = detailPosts?.linkURL
            detailVc.userName = detailPosts?.userProfileName
            detailVc.userImageURL = detailPosts?.userProfileImage
            detailVc.userID = detailPosts?.userID
            
            
        } 
        
        
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteButton: UITableViewRowAction = UITableViewRowAction(style: .normal, title: "削除") { (action, index) -> Void in
            
            
            
            let postID = self.userPosts[indexPath.row].postID
            
            
            
            
            let alertViewControler = UIAlertController(title: "確認", message: "本当に削除しますか？", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler:{
                // ボタンが押された時の処理を書く（クロージャ実装）
                (action: UIAlertAction!) -> Void in
                
                
                self.deleteCheck = true
                
            })
            
            let cancel = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler: {
                (action: UIAlertAction!) in
                
                self.profilePostTable.isEditing = false
            })

            
            
            alertViewControler.addAction(okAction)
            alertViewControler.addAction(cancel)
            
            
            self.present(alertViewControler, animated: true, completion: nil)
            
            
    
            
            self.wait( {self.deleteCheck == false} ) {
                
                //DBの削除
                DispatchQueue.global().async {
                    
                    DataService.dataBase.REF_BASE.child("posts/\(String(describing: postID))").removeValue()
                    
                }
                
                self.userPosts.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                
                
            }

                
                self.deleteCheck = false
                
            }
            
            deleteButton.backgroundColor = UIColor.rgb(r: 31, g: 158, b: 187, alpha: 1)
            
        
        
        return [deleteButton]
    }
    
   
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userPosts.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = profilePostTable.dequeueReusableCell(withIdentifier: "profilePosts", for: indexPath) as! ProfilePostsTableViewCell
        
        cell.profileImage.image = nil
        
        
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 10
        cell.clipsToBounds = true
        
        
        let post = userPosts[indexPath.row]
        
        
        if self.userPosts[indexPath.row].imageURL != nil {
            cell.profileImage.af_setImage(withURL: URL(string: userPosts[indexPath.row].imageURL)!)
        }
        
        
        if let img = AccountViewController.imageCache.object(forKey: post.imageURL as! NSString) {
            
            cell.configureCell(post: post, img: img)
            
        } else {
            cell.configureCell(post: post)
        }
        
        
        return cell
    }
    
    
    @IBAction func actionButtonDidTap(_ sender: Any) {
        
        let anonymousUser = currentUserCheck!.isAnonymous
        
        let actionSheet = UIAlertController(title: "選択", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        actionSheet.view.tintColor = UIColor.rgb(r: 31, g: 158, b: 187, alpha: 1)
        
        
        let edit = UIAlertAction(title: "プロフィールを編集", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            
            
            if anonymousUser == true {
                //ゲストユーザー
                let alertViewControler = UIAlertController(title: "登録をお願いします", message: "登録をすると投稿ができます", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                alertViewControler.addAction(okAction)
                self.present(alertViewControler, animated: true, completion: nil)
                print(self.currentUserCheck?.displayName!)
                
            } else if anonymousUser == false {
                //
                self.performSegue(withIdentifier: "goEdit", sender: nil)
                
            }
            
           
            
            
            
            
            
        })
        
        let contact = UIAlertAction(title: "運営者に違反を報告", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            
            
            //サファリ開く
            let contactURL = URL(string: "https://peraichi.com/landing_pages/view/portiphoneiosapp")
            
            if contactURL != nil {
                
                let safariVC = SFSafariViewController(url:  URL(string: "https://peraichi.com/landing_pages/view/portiphoneiosapp")!)
                    
                self.present(safariVC, animated: true, completion: nil)
                
            } else {
                
                //alert
                
                let alertController = UIAlertController(title: "エラー", message: "エラーが発生しました", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "Ok", style: .default) {
                    (action) in
                    self.dismiss(animated: true, completion: nil)
                }
                
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                
                
                
                
            }
            
            
        })
        
        
        
        let logout = UIAlertAction(title: "ログアウト", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            
            do {
                
                
                let userDefaults = UserDefaults.standard
                userDefaults.removeObject(forKey: "previousCounts")
                
                try FIRAuth.auth()?.signOut()
                
                
                
                
                self.performSegue(withIdentifier: "logout", sender: nil)
            } catch let error as NSError {
                print("\(error.localizedDescription)")
            }
            
            
            
        })
        
        
        let cancel = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler: {
            (action: UIAlertAction!) in
        })
        
        actionSheet.addAction(edit)
        actionSheet.addAction(contact)
        actionSheet.addAction(logout)
        actionSheet.addAction(cancel)
        
        self.present(actionSheet, animated: true, completion: nil)
        
        
        
        
        
        
    }
    
    
    @IBAction func postButtonDidTap(_ sender: Any) {
        
        let anonymousUser = currentUserCheck!.isAnonymous
        
        if anonymousUser == true {
            //ゲストユーザー
            let alertViewControler = UIAlertController(title: "登録をお願いします", message: "登録をすると投稿ができます", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alertViewControler.addAction(okAction)
            self.present(alertViewControler, animated: true, completion: nil)
            
            print(currentUserCheck?.displayName!)
        } else if anonymousUser == false {
            
            //ログインユーザー
            performSegue(withIdentifier: "ToPostsss", sender: nil)

            
        }
        
       
        
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


extension UIScrollView {
    
    var isAtTop: Bool {
        return contentOffset.y <= verticalOffsetForTop
    }
    
    var isAtBottom: Bool {
        return contentOffset.y >= verticalOffsetForBottom
    }
    
    var verticalOffsetForTop: CGFloat {
        let topInset = contentInset.top
        return -topInset
    }
    
    var verticalOffsetForBottom: CGFloat {
        let scrollViewHeight = bounds.height
        let scrollContentSizeHeight = contentSize.height
        let bottomInset = contentInset.bottom
        let scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight
        return scrollViewBottomOffset
    }
    
}


