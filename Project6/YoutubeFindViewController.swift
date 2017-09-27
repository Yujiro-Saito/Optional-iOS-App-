//
//  YoutubeFindViewController.swift
//  
//
//  Created by  Yujiro Saito on 2017/09/27.
//
//

import UIKit
import Alamofire

class YoutubeFindViewController: UIViewController,UISearchBarDelegate {
    
    @IBOutlet weak var searchField: UISearchBar!
    
    var searchURL = String()
    var titleBox = [String]()
    var thumbnailURLBox = [String]()
    var videoIDBox = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchField.delegate = self
        
        //何も入力されていなくてもReturnキーを押せるようにする。
        searchField.enablesReturnKeyAutomatically = false
        
        
        searchField.placeholder = "Youtubeを検索"
        
        searchField.disableBlur()
        searchField.backgroundColor = UIColor.darkGray
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.darkGray]
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = UIColor.darkGray
        
        
        
        
        
        
        /*
        mySearchBar = UISearchBar()
        mySearchBar.delegate = self
        mySearchBar.frame = CGRect(x:0, y: 0,width: self.view.frame.size.width,height: 44)
        mySearchBar.layer.position = CGPoint(x: self.view.bounds.width/2, y: 32)
        mySearchBar.tintColor = UIColor.black
        mySearchBar.barTintColor = UIColor.red
        mySearchBar.placeholder = "Youtubeを検索"
        
        self.navigationItem.titleView = mySearchBar
 
 */
        
        
        
    }

    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let searchText = searchField.text
        
        let enocodedText = searchText!.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.searchURL = "https://www.googleapis.com/youtube/v3/search?key=AIzaSyB2oGwTctsfRWNPQ-d1kUvtFzOUXhN9Z0w&q=\(enocodedText!)&part=id,snippet&maxResults=1&order=viewCount"
            
            let finalKeyWord = self.searchURL.replacingOccurrences(of: " ", with: "+")
            
           self.callAlamo(url: finalKeyWord)
        }
        
        return true
        
        
    }
    
    //検索ボタン押下時の呼び出しメソッド
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchField.resignFirstResponder()
        
    }
    
    func callAlamo(url: String) {
        
        
        Alamofire.request(url).response { (response) in
            self.parseData(JsonData: response.data!)
        }
        
        
    }

    func parseData(JsonData: Data) {
        
        
        self.titleBox = []
        self.thumbnailURLBox = []
        self.videoIDBox = []
        
        do {
            
            var readableJSON = try JSONSerialization.jsonObject(with: JsonData, options: .mutableContainers) as! jsonFormat
            
            
            
             if let items = readableJSON["items"] as? [jsonFormat] {
                
                for a in 0..<items.count {
                    
                    let item = items[a]
                    
                    //videoID
                    if let videoID = item["id"] as? Dictionary<String,AnyObject> {
                        
                       let id = videoID["videoId"] as? String
                       
                        if id != nil {
                            
                            self.videoIDBox.append(id!)
                        }
                        
                        
                    }
                    
                    //Title
                    if let videoInfo = item["snippet"] as? Dictionary<String,AnyObject> {
                        
                        
                        let title = videoInfo["title"] as? String
                        
                        if title != nil {
                            
                            self.titleBox.append(title!)
                        }
                        
                        //Image
                        if let imageURL = videoInfo["thumbnails"] as? Dictionary<String,AnyObject> {
                            
                            let imageIt = imageURL["high"] as? Dictionary<String,AnyObject>
                            
                            let finalImage = imageIt?["url"] as? String
                            
                            if finalImage != nil {
                                
                                self.thumbnailURLBox.append(finalImage!)
                            }
                            
                            
                            
                            
                        }
                        
                        
                        print("いいいいいいいいいいいいいいいいいううううううう")
                        print(titleBox)
                        print(thumbnailURLBox)
                        print(videoIDBox)
                        
                        
                        
                    }
                    
                    
                    
                }
                
                
                
            }
            
            
            
        }
           
            
            
        
            
            
        catch {
            //print(error)
            
        }
        
        
        
        
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            
            self.titleBox.removeAll()
            self.thumbnailURLBox.removeAll()
            self.videoIDBox.removeAll()

            
        }
        
        
        
    }
    
    

    typealias jsonFormat = [String : Any]
    
    
}
extension UISearchBar {
     func disableBlur() {
        backgroundImage = UIImage()
        isTranslucent = true
    }
}