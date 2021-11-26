//
//  PlugViewController.swift
//  DISBYU
//
//  Created by Trevor Schmidt on 1/10/21.
//

import UIKit

class PlugViewController: UIViewController {
    
    @IBOutlet weak var urlLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.onClicLabel(sender:)))
        urlLabel.isUserInteractionEnabled = true
        urlLabel.addGestureRecognizer(tap)
    }
    
    @objc func onClicLabel(sender:UITapGestureRecognizer) {
        openUrl(urlString: "http://www.trevorjschmidt.com/resume.pdf")
    }
    func openUrl(urlString:String!) {
        let url = URL(string: urlString)!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}
