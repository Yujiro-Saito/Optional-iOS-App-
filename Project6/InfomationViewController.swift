//
//  InfomationViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/08/28.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import CircleMenu
import Firebase
import AlamofireImage
import SafariServices


class InfomationViewController: UIViewController {
    
    
    //Outlet
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var windowView: UIView!
    @IBOutlet weak var urlLabel: UILabel!
    
    
    //データ受け継ぎ用
    
    var name: String?
    var numLikes = Int()
    var imageURL: String?
    var linkURL: String?
    var userName: String?
    var userID: String!
    
    let items: [(icon: String, color: UIColor)] = [
        ("icon_home", UIColor(red:0.19, green:0.57, blue:1, alpha:1)),
        ("safari", UIColor(red:0.22, green:0.74, blue:0, alpha:1)),
        ("twitter", UIColor(red:22.0, green:22.0, blue:22.0, alpha:1)),
        ("settings-btn", UIColor(red:0.51, green:0.15, blue:1, alpha:1)),
        ("nearby-btn", UIColor(red:1, green:0.39, blue:0, alpha:1)),
        ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.itemImage.layer.cornerRadius = 8
        self.windowView.isHidden = true
        
        itemImage.af_setImage(withURL: URL(string: imageURL!)!)
        itemName.text = name
        urlLabel.text = linkURL
        
        let button = CircleMenu(
            frame: CGRect(x: 200, y: 200, width: 50, height: 50),
            normalIcon:"icon_menu",
            selectedIcon:"icon_close",
            buttonsCount: 5,
            duration: 0.5,
            distance: 85)
        
        button.delegate = self
        button.layer.cornerRadius = button.frame.size.width / 2.0
        button.layer.backgroundColor = UIColor.white.cgColor

        
        view.addSubview(button)
        
        self.view.bringSubview(toFront: button)
        
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100.0).isActive = true
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
        //button size
        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
    }
    
    func circleMenu(_ circleMenu: CircleMenu, willDisplay button: UIButton, atIndex: Int) {

        self.windowView.isHidden = false
        
        button.backgroundColor = items[atIndex].color
        
        button.setImage(UIImage(named: items[atIndex].icon), for: .normal)
        
        // set highlited image
        let highlightedImage  = UIImage(named: items[atIndex].icon)?.withRenderingMode(.alwaysTemplate)
        button.setImage(highlightedImage, for: .highlighted)
        button.tintColor = UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.3)
    }
    
    func circleMenu(_ circleMenu: CircleMenu, buttonWillSelected button: UIButton, atIndex: Int) {
    }
    
    func circleMenu(_ circleMenu: CircleMenu, buttonDidSelected button: UIButton, atIndex: Int) {
        
        

        if atIndex == 0 {
             print("0")
        } else if atIndex == 1 {
            print("1")
            
            self.windowView.isHidden = true
            
            let targetURL = self.linkURL
            let encodedURL = targetURL?.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
            
            //URL正式
            guard let finalUrl = URL(string: encodedURL!) else {
                print("無効なURL")
                return
            }
            
            
            
            //opem safari
            
            
            if (encodedURL?.contains("https"))! || (encodedURL?.contains("http"))! {
                
                //httpかhttpsで始まってるか確認
                if (encodedURL?.hasPrefix("https"))! || (encodedURL?.hasPrefix("http"))! {
                    //http(s)で始まってる場合safari起動
                    let safariVC = SFSafariViewController(url: finalUrl)
                    self.present(safariVC, animated: true, completion: nil)
                    
                }
                    //Httpsの場合
                else if let range = encodedURL?.range(of: "https") {
                    let startPosition = encodedURL?.characters.distance(from: (encodedURL?.characters.startIndex)!, to: range.lowerBound)
                    
                    //4番目から最後までをURLとして扱う
                    
                    let indexNumber = startPosition
                    
                    let validURLString = (encodedURL?.substring(with: (encodedURL?.index((encodedURL?.startIndex)!, offsetBy: indexNumber!))!..<(encodedURL?.index((encodedURL?.endIndex)!, offsetBy: 0))!))
                    
                    let validURL = URL(string: validURLString!)
                    
                    
                    //safari起動
                    let safariVC = SFSafariViewController(url: validURL!)
                    self.present(safariVC, animated: true, completion: nil)
                    
                    
                } else if let httpRange = encodedURL?.range(of: "http") {
                    //Httpの場合
                    let startPosition = encodedURL?.characters.distance(from: (encodedURL?.characters.startIndex)!, to: httpRange.lowerBound)
                    
                    //4番目から最後までをURLとして扱う
                    
                    let indexNumber = startPosition
                    
                    let validURLString = (encodedURL?.substring(with: (encodedURL?.index((encodedURL?.startIndex)!, offsetBy: indexNumber!))!..<(encodedURL?.index((encodedURL?.endIndex)!, offsetBy: 0))!))
                    
                    let validURL = URL(string: validURLString!)
                    
                    //safari起動
                    let safariVC = SFSafariViewController(url: validURL!)
                    self.present(safariVC, animated: true, completion: nil)
                    
                    
                    
                    
                    
                    
                }
                    
                else {
                }
                
                
            } else {
                //そもそもhttp(s)がない場合
                print("無効なURL")
                //アラート表示
                let alertController = UIAlertController(title: "エラー", message: "URLが無効なようです", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "Ok", style: .default) {
                    (action) in
                    self.dismiss(animated: true, completion: nil)
                }
                
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                
                
                
                
            }
            
            
            
            
            
            
            
            
            
        } else if atIndex == 2 {
             print("2")
        } else if atIndex == 3 {
             print("3")
        } else if atIndex == 4 {
             print("4")
        }
        
        

    }
    
    
    
    func menuCollapsed(_ circleMenu: CircleMenu) {
        print("cancel")
        self.windowView.isHidden = true
    }
    
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}



extension UIColor {
    static func color(_ red: Int, green: Int, blue: Int, alpha: Float) -> UIColor {
        return UIColor(
            colorLiteralRed: Float(1.0) / Float(255.0) * Float(red),
            green: Float(1.0) / Float(255.0) * Float(green),
            blue: Float(1.0) / Float(255.0) * Float(blue),
            alpha: alpha)
    }
}
