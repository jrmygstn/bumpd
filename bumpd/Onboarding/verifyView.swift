//
//  codeView.swift
//  bumpd
//
//  Created by Jeremy Gaston on 5/2/23.
//

import UIKit
import Firebase
import SinchVerification

class verifyView: UIViewController {
    
    // Variables
    
    var databaseRef: DatabaseReference! {
        
        return Database.database().reference()
    }
    
    var verified: Verification!
    
    // Outlets
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var codeField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        let imgTitle = UIImage(named: "Bumpd_brandmark-01")
        navigationItem.titleView = UIImageView(image: imgTitle)
        navigationItem.leftBarButtonItem?.isHidden = true
        
        setupText()
        
    }
    
    // Actions
    
    @IBAction func continueBtnTapped(_ sender: Any) {
        
        guard let code = codeField.text, code != ""
            else {
                let alert = UIAlertController(title: "Forget Something?", message: "Please make a selection.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
        }
        
        verified.verify(code) { (isSuccess, error) in
            
            if isSuccess == true {
                
                let alert = UIAlertController(title: "Verified ✅", message: "", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                
                let go = self.storyboard?.instantiateViewController(withIdentifier: "mainView")
                self.present(go!, animated: true, completion: nil)
                
            } else {
                
                let alertVC = UIAlertController(title: "", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                alertVC.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
                self.present(alertVC, animated: true, completion: nil)
                
            }
            
        }
        
    }
    
    // Functions
    
    func setupText() {
        
        let uid = Auth.auth().currentUser?.uid
        
        self.databaseRef.child("Users/\(uid!)").observe(.value) { (snapshot) in
            
            let number = snapshot.childSnapshot(forPath: "phone").value as? String ?? ""
            
            self.textLabel.text = "Enter the code that was sent to \(number)"
            
        }
        
    }


}
