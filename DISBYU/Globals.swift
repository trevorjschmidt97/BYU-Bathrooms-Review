//
//  Globals.swift
//  DISBYU
//
//  Created by Trevor Schmidt on 12/29/20.
//

import Foundation
import Firebase
import FirebaseDatabase

struct Globals {
    static var userID:String = FirebaseAuth.Auth.auth().currentUser?.uid ?? "0"
    static var username: String = ""
    static var buildingID: String = ""
    
    static func updateUsername(newUsername: String) {
        username = newUsername
    }
}

// GLOBAL EXTENSIONS
// Allows us to use emoji's in the future
extension String {
  func decode() -> String {
      let data = self.data(using: .utf8)!
      return String(data: data, encoding: .nonLossyASCII) ?? self
  }

  func encode() -> String {
      let data = self.data(using: .nonLossyASCII, allowLossyConversion: true)!
      return String(data: data, encoding: .utf8)!
  }
}

extension UIViewController {
    func showToast(message: String, good: Bool) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.width/2-150, y: self.view.frame.height - 100, width: 300, height: 40))
        toastLabel.textAlignment = .center
        if good {
            toastLabel.backgroundColor = UIColor.green.withAlphaComponent(0.6)
        } else {
            toastLabel.backgroundColor = UIColor.red.withAlphaComponent(0.6)
        }
        toastLabel.textColor = UIColor.white
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        toastLabel.text = message
        self.view.addSubview(toastLabel)
        
        UIView.animate(withDuration: 4.0, delay: 1.0, options: .curveEaseInOut, animations: {
            toastLabel.alpha = 0.0
        }) { (isCompleted) in
            toastLabel.removeFromSuperview()
        }
    }
}

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if parentResponder is UIViewController {
                return parentResponder as! UIViewController?
            }
        }
        return nil
    }
}

//Extensions for the UITextField/View
extension ReviewViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 33
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
}

extension ReviewViewController:UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Comments (Optional)"
            textView.textColor = UIColor.lightGray
        }
    }
}

extension UIColor {
    func lighter(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }

    func darker(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }

    func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: min(red + percentage/100, 1.0),
                           green: min(green + percentage/100, 1.0),
                           blue: min(blue + percentage/100, 1.0),
                           alpha: alpha)
        } else {
            return nil
        }
    }
}
