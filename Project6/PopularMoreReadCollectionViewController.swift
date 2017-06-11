//
//  PopularMoreReadCollectionViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/05/31.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import Firebase


class PopularMoreReadCollectionViewController: UICollectionViewController {

    struct Storyboard {

        static let leftAndRightPaddings: CGFloat = 32.0 // 3 items per row, meaning 4 paddings of 8 each
        static let numberOfItemsPerRow: CGFloat = 2.0
        static let titleHeightAdjustment: CGFloat = 30.0
    }
    
    
    
    @IBOutlet var popularMoreCollection: UICollectionView!
    
    //Property
    var posts = [Post]()
    var popularMorePosts: Post?
    
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let collectionViewWidth = collectionView?.frame.width
        let itemWidth = (collectionViewWidth! - Storyboard.leftAndRightPaddings) / Storyboard.numberOfItemsPerRow
        
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth + Storyboard.titleHeightAdjustment)

       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        do {
            
            DataService.dataBase.REF_GAME.queryOrdered(byChild: "pvCount").queryLimited(toLast: 4).observe(.value, with: { (snapshot) in
                
                self.posts = []
                
                print(snapshot.value)
                
                if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    
                    for snap in snapshot {
                        print("SNAP: \(snap)")
                        
                        if let postDict = snap.value as? Dictionary<String, AnyObject> {
                            
                            let key = snap.key
                            let post = Post(postKey: key, postData: postDict)
                            
                            
                            self.posts.append(post)
                            
                            
                        }
                    }
                    
                    
                }
                
                
                
                DataService.dataBase.REF_ENTERTAINMENT.queryOrdered(byChild: "pvCount").queryLimited(toLast: 4).observe(.value, with: { (snapshot) in
                    
                    
                    if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                        
                        for snap in snapshot {
                            print("SNAP: \(snap)")
                            
                            if let postDict = snap.value as? Dictionary<String, AnyObject> {
                                
                                let key = snap.key
                                let post = Post(postKey: key, postData: postDict)
                                
                                
                                self.posts.append(post)
                            }
                        }
                        
                        
                    }
                    
                    
                    
                    
                    DataService.dataBase.REF_GADGET.queryOrdered(byChild: "pvCount").queryLimited(toLast: 4).observe(.value, with: { (snapshot) in
                        
                        
                        print(snapshot.value)
                        
                        if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                            
                            for snap in snapshot {
                                print("SNAP: \(snap)")
                                
                                if let postDict = snap.value as? Dictionary<String, AnyObject> {
                                    
                                    let key = snap.key
                                    let post = Post(postKey: key, postData: postDict)
                                    
                                    
                                    self.posts.append(post)
                                }
                            }
                            
                            
                        }
                        
                        
                        
                        self.posts.sort(by: {$0.pvCount > $1.pvCount})
                        self.collectionView?.reloadData()
                        
                        
                    })
                    
                    
                })
                
                
                
                
            })
            
            
        } catch {
            print("読み込みに失敗しました")
        }

        
        
        
    }
    
    

   
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopularMoreAndMore", for: indexPath) as? PopularMoreReadCollectionViewCell
        
        let post = posts[indexPath.row]
        
        if let img = PopularMoreReadCollectionViewController.imageCache.object(forKey: post.imageURL as NSString) {
            cell?.configureCell(post: post, img: img)
            
        } else {
           cell?.configureCell(post: post)
        }
    
    
    
        return cell!
    }
    
    
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader1", for: indexPath) as! SectionHeaderPopCollectionReusableView
        
        headerView.sectionTitle.text = "人気"
        
        return headerView
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        popularMorePosts = posts[indexPath.row]
        
        if popularMorePosts != nil {
            
            performSegue(withIdentifier: "detailPopularGo", sender: nil)
            
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if (segue.identifier == "detailPopularGo") {
            
            
            let detailVc = (segue.destination as? DetailViewController)!
            
            
            detailVc.name = popularMorePosts?.name
            detailVc.categoryName = popularMorePosts?.category
            detailVc.starNum = popularMorePosts?.pvCount
            detailVc.whatContent = popularMorePosts?.whatContent
            detailVc.imageURL = popularMorePosts?.imageURL
            detailVc.detailImageOne = popularMorePosts?.detailImageOne
            detailVc.detailImageTwo = popularMorePosts?.detailImageTwo
            detailVc.detailImageThree = popularMorePosts?.detailImageThree
            detailVc.linkURL = popularMorePosts?.linkURL
            detailVc.numberOfKeep = popularMorePosts?.keepCount
            
            
            
        } else {
            print("error")
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
    }
    
    
    
    
    


}
