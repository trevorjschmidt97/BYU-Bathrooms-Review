//
//  LoginViewController.swift
//  DISBYU
//
//  Created by Trevor Schmidt on 12/29/20.
//

import UIKit
import Firebase
import FirebaseDatabase

class LoginViewController: UIViewController, UITextFieldDelegate {
    let rootRef = Database.database().reference()
    
    // Buttons and labels
    @IBOutlet weak var LogInRegisterLabel: UILabel!
    
    @IBOutlet weak var noAccountButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var yesAccountButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var firstTextField: UITextField!
    
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var secondTextField: UITextField!
    
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var thirdTextField: UITextField!
    @IBOutlet weak var thirdHelperLabel: UILabel!
    
    @IBOutlet weak var fourthLabel: UILabel!
    @IBOutlet weak var fourthTextField: UITextField!
    @IBOutlet weak var fourthHelperLabel: UILabel!
    
    @IBOutlet weak var checkThisOut1: UIButton!
    @IBOutlet weak var checkThisOut2: UIButton!
    
    // View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstTextField.delegate = self
        secondTextField.delegate = self
        thirdTextField.delegate = self
        fourthTextField.delegate = self
        firstTextField.returnKeyType = UIReturnKeyType.done
        secondTextField.returnKeyType = UIReturnKeyType.done
        thirdTextField.returnKeyType = UIReturnKeyType.done
        fourthTextField.returnKeyType = UIReturnKeyType.done
        
        thirdTextField.addTarget(self, action: #selector(self.passwordLengthCheck(_:)), for: .editingChanged)
        fourthTextField.addTarget(self, action: #selector(self.passwordMatchCheck(_:)), for: .editingChanged)

        // Auto Show Sign In
        switchToSignIn(self)
    }
    
    // Func for checking of password length
    @objc @discardableResult func passwordLengthCheck(_ textField: UITextField) -> Bool {
        self.passwordMatchCheck(self.thirdTextField)
        let text = thirdTextField.text ?? ""
        if text.count < 8 {
            self.thirdHelperLabel.textColor = .red
            return false
        } else {
            self.thirdHelperLabel.textColor = .systemGreen
            return true
        }
    }
    
    // Func for checking of password match
    @objc @discardableResult func passwordMatchCheck(_ textField: UITextField) -> Bool {
        let text = thirdTextField.text ?? ""
        let text2 = fourthTextField.text ?? " "
        
        if text != text2 || text.count == 0 && text2.count == 0 {
            self.fourthHelperLabel.textColor = .red
            return false
        } else {
            self.fourthHelperLabel.textColor = .systemGreen
            return true
        }
    }
    
    // Update labels/buttons for sign in
    @IBAction func switchToSignIn(_ sender: Any) {
        LogInRegisterLabel.text = "Log In"
        
        noAccountButton.isHidden = false
        loginButton.isHidden = false
        yesAccountButton.isHidden = true
        registerButton.isHidden = true
        checkThisOut1.isHidden = false
        checkThisOut2.isHidden = true
        
        // First email
        firstLabel.text = "email"
        firstTextField.text = ""
        firstTextField.placeholder = "email"
        firstTextField.keyboardType = UIKeyboardType.emailAddress
        firstTextField.becomeFirstResponder()
        // Second password
        secondLabel.text = "password"
        secondTextField.text = ""
        secondTextField.placeholder = "password"
        secondTextField.keyboardType = UIKeyboardType.alphabet
        secondTextField.isSecureTextEntry = true
        // Third nothing
        thirdLabel.isHidden = true
        thirdTextField.isHidden = true
        thirdHelperLabel.isHidden = true
        // Fourth nothing
        fourthLabel.isHidden = true
        fourthTextField.isHidden = true
        fourthHelperLabel.isHidden = true
    }
    
    // Update buttons/labels for register
    @IBAction func switchToRegister(_ sender: Any) {
        firstTextField.resignFirstResponder()
        secondTextField.resignFirstResponder()
        thirdTextField.resignFirstResponder()
        fourthTextField.resignFirstResponder()
        
        LogInRegisterLabel.text = "Register"
        
        noAccountButton.isHidden = true
        loginButton.isHidden = true
        yesAccountButton.isHidden = false
        registerButton.isHidden = false
        checkThisOut1.isHidden = true
        checkThisOut2.isHidden = false
        
        // First username
        firstLabel.text = "username"
        firstTextField.text = ""
        firstTextField.placeholder = "username"
        firstTextField.keyboardType = UIKeyboardType.alphabet
        // Second email
        secondLabel.text = "email"
        secondTextField.text = ""
        secondTextField.placeholder = "email"
        secondTextField.keyboardType = UIKeyboardType.emailAddress
        secondTextField.isSecureTextEntry = false
        // Third password
        thirdLabel.isHidden = false
        thirdTextField.isHidden = false
        thirdLabel.text = "password"
        thirdTextField.text = ""
        thirdTextField.placeholder = "password"
        thirdTextField.isSecureTextEntry = true
        thirdHelperLabel.isHidden = false
        thirdHelperLabel.text = "Password must be at least 8 characters long"
        thirdHelperLabel.textColor = .systemRed
        // Fourth comfirm password
        fourthLabel.isHidden = false
        fourthTextField.isHidden = false
        fourthLabel.text = "confirm password"
        fourthTextField.text = ""
        fourthTextField.placeholder = "confirm password"
        fourthTextField.isSecureTextEntry = true
        fourthHelperLabel.isHidden = false
        fourthHelperLabel.text = "Passwords must match"
        fourthHelperLabel.textColor = .systemRed
    }
    
    // Login Button Pressed
    @IBAction func logInButtonPressed(_ sender: Any) {
        // Dismiss keyboard
        firstTextField.resignFirstResponder()
        secondTextField.resignFirstResponder()
        thirdTextField.resignFirstResponder()
        fourthTextField.resignFirstResponder()
        
        // Make sure to have all info
        guard let email = firstTextField.text, !email.isEmpty,
              let password = secondTextField.text, !password.isEmpty else {
            // add alert for empty email/password
            self.showToast(message: "Missing data for log in", good: false)
            return
        }
        
        // Attempt to sign in
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            guard error == nil else {
                // error in sign in
                self.showToast(message: "Sign-in not successful", good: false)
                return
            }
            Globals.userID = (result?.user.uid)!
            
            
            self.rootRef.child("users").child(Globals.userID).child("username").observeSingleEvent(of: .value) { (snapshot) in
                Globals.updateUsername(newUsername: snapshot.value as! String)
            }
            
            // sign in successful
            self.dismiss(animated: true)
        }
    }
    
    // Register button pressed
    @IBAction func registerButtonPressed(_ sender: Any) {
        // Dismiss keyboard
        firstTextField.resignFirstResponder()
        secondTextField.resignFirstResponder()
        thirdTextField.resignFirstResponder()
        fourthTextField.resignFirstResponder()
        
        // Check length, which also checks for match
        guard self.passwordLengthCheck(thirdTextField) else { return }
        
        // Make sure we have all the info we need
        guard let username = firstTextField.text, !username.isEmpty,
              let email = secondTextField.text, !email.isEmpty,
              let password = thirdTextField.text, !password.isEmpty else {
            
            // error in user info
            self.showToast(message: "Missing data for log in", good: false)
            return
        }
        
        // Check for acceptable username
        guard !username.contains("."), !username.contains("$"), !username.contains("["),
              !username.contains("]"), !username.contains("#"), !username.contains("/") else {
            
            // Invalid username
            self.showToast(message: "Bad Username, .$[]#/ not acceptable chars", good: false)
            return
        }
        
        // Initiate registration
        Database.database().reference().child("usernames").observeSingleEvent(of: .value, with: { (snapshot) in
            // Check if Username is taken
            if snapshot.hasChild(username) {
                self.showToast(message: "Username already taken", good: false)
                return
            // If not taken
            } else {
                
                //Try to create the user in the firebase app
                FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                    // If there is an error
                    guard error == nil else {
                        self.showToast(message: "Error in registration, try later or different email", good: false)
                        return
                    }
                    
                    // Registration successful
                    Globals.userID = Auth.auth().currentUser!.uid
                    Globals.updateUsername(newUsername: username)
                    
                    // Add to users table with their id and username
                    Database.database().reference().child("users").child(Globals.userID).child("username").setValue(username)
                    // Add that username to the usernames table and their id
                    Database.database().reference().child("usernames").child(username).child("userID").setValue(Globals.userID)
                    
                    self.dismiss(animated: true)
                }
            }
        })
    }
    
    // If return key is pressed, the keyboard is dismissed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

// Legacy Code
// First, check to see if the username is already taken in the db
//        Globals.store.checkUsername(login: username) {
//            (InsertionResult) in
//
//            switch InsertionResult {
//            case let .success(result):
//                print(result.resultString)
//
//                // If it is already taken, then show a toast
//                if result.resultString == "Username already taken, find new" {
//                    self.showToast(message: result.resultString, good: false)
//                } else {
//                // If it isn't taken,
//                    //Try to create the user in the firebase app
//                    FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
//                        // If there is an error
//                        guard error == nil else {
//                            print("error in creation of account")
//                            print(error.debugDescription)
//
//                            self.showToast(message: "Error in creation of account, email already taken", good: false)
//                            return
//                        }
//
//                        // firebase account creation successful and now signed in
//                        print("successfully created account")
//                        Globals.userID = Firebase.Auth.auth().currentUser?.uid ?? "0"
//
//                        // Add the user to the db
//                        Globals.store.pushUser(userID: Globals.userID, login: username) {
//                            (InsertionResult) in
//
//                            switch InsertionResult {
//                            case let .success(result):
//                                print(result.resultString)
//                            case let .failure(error):
//                                print("Error pushing user: \(error)")
//                                self.showToast(message: "Error in insertion of user into database", good: false)
//                            }
//                        }
//
//                        self.dismiss(animated: true)
//                    }
//                }
//            case let .failure(error):
//                print("Error pushing user: \(error)")
//                self.showToast(message: "Error in insertion of user into database", good: false)
//            }
//        }
