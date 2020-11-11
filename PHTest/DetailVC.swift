//
//  DetailVC.swift
//  PHTest
//
//  Created by maples on 2020/11/11.
//

import UIKit

class DetailVC: UIViewController {

    @IBOutlet weak var timeTitle:UILabel!
    @IBOutlet weak var contentView:UITextView!
    
    public var dic:Dictionary<String, Any>?
    
    // MARK: - Private
    
    /// 设置UI展示
    private func setUI() {
        navigationItem.title = NAV_TITLE_DETAIL
        timeTitle.text = dic?[kNAME_DATE] as? String
        if let contentDic = dic?[kNAME_JSON] as? Dictionary<String,Any> {
            let contentString = (contentDic.compactMap({ (key, value) -> String in
                return "\(key)=\(value)"
            }) as Array).joined(separator: ";\n")
            contentView.text = contentString
        }
    }
    
    // MARK: -Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    

   

}
