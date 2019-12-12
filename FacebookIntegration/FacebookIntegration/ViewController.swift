//
//  ViewController.swift
//  FacebookIntegration
//
//  Created by Macbook on 12/12/2019.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookShare
import FacebookCore
import FBSDKCoreKit

class ViewController: UIViewController,LoginButtonDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let loginButton = FBLoginButton(permissions: [ .email])
        loginButton.center = view.center
        loginButton.delegate = self
        view.addSubview(loginButton)

        
        // Do any additional setup after loading the view.
    }
    
    //MARK: Sharing-Session
    func showShareDialog<C: SharingContent>(_ content: C, mode: ShareDialog.Mode = .automatic) {
      let dialog = ShareDialog(fromViewController: self, content: content, delegate: self)
      dialog.mode = mode
      dialog.show()
    }

    @IBAction private func showLinkShareDialogModeAutomatic() {
      guard let url = URL(string: "https://google.com/") else { return }
      let content = ShareLinkContent()
      content.contentURL = url
        content.quote = "sdfsdf"
      content.placeID = "166793820034304"
        
      showShareDialog(content, mode: .automatic)
    }
    
    // share image
    @IBAction func shareImageButton(_ sender: UIButton) {

        // image to share
        let image = UIImage(named: "Asset 4")

        // set up activity view controller
        let imageToShare = [ image! ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash

        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]

        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }

    //MARK: Login-Session
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        print(loginButton.permissions)
        print(result as Any)

    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print(loginButton)
    }
    
    func loginManagerDidComplete(_ result: LoginResult) {
        let alertController: UIAlertController
        switch result {
        case .cancelled:
            alertController = UIAlertController(title: "Login Cancelled", message: "User cancelled login.", preferredStyle: .alert)
        case .failed(let error):
            alertController = UIAlertController(title: "Login Fail", message: "Login failed with error \(error)", preferredStyle: .alert)


        case .success(let grantedPermissions, _, let token):
            print(grantedPermissions.description)
            print(grantedPermissions.customMirror.children)
            print(token.appID)
            print(token.tokenString)
            print(token.userID)
            
            
            let myGraphRequest = GraphRequest(graphPath: "/me", parameters: ["fields": "email"], tokenString: token.tokenString, version: Settings.defaultGraphAPIVersion, httpMethod: .get)
            let connection = GraphRequestConnection()
            connection.add(myGraphRequest, completionHandler: { (connection, values, error) in
                    if let values = values as? [String:Any] {
                            //add your custom code here...
                        print(values)
                    }
            })

            
            alertController = UIAlertController(title: "Login Success", message: "Login succeeded with granted permissions: \(grantedPermissions)", preferredStyle: .alert)
        }
        
        let uialert = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(uialert)

        self.present(alertController, animated: true, completion: nil)
    }

    @IBAction private func loginWithReadPermissions() {
        let loginManager = LoginManager()
        loginManager.logIn(
            permissions: [.email],
            viewController: self
        ) { result in
            self.loginManagerDidComplete(result)
        }
    }

    @IBAction private func logOut() {
        let loginManager = LoginManager()
        loginManager.logOut()
        let alertController = UIAlertController(title: "Logout", message: "Logged out", preferredStyle: .alert)
        let uialert = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(uialert)

        present(alertController, animated: true, completion: nil)
    }


}

extension ViewController : SharingDelegate {
    func sharer(_ sharer: Sharing, didCompleteWithResults results: [String : Any]) {
        print(results)
    }
    
    func sharer(_ sharer: Sharing, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func sharerDidCancel(_ sharer: Sharing) {
        print("Cancel")
    }
    
    
}
