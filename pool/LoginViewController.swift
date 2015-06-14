//
//  LoginViewController.swift
//
//
//  Created by Thomas Pockrandt on 13/06/15.
//
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // backgroundColor
        self.view.backgroundColor = UIColor.whiteColor()
        
        // navigationBar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationController?.navigationBar.shadowImage  = UIImage()
        self.navigationController?.navigationBar.translucent  = true
        self.navigationController?.navigationBar.barStyle     = UIBarStyle.Default
        
        // imageView: waves
        let imageViewWaves = UIImageView(
            image: UIImage(named: "app-waves")
        )
        //        imageViewWaves.contentMode = UIViewContentMode.ScaleAspectFit
        imageViewWaves.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addSubview(imageViewWaves)
        
        self.view.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat("H:|[imageViewWaves]|",
                options: NSLayoutFormatOptions.AlignAllTop,
                metrics: nil,
                views: ["imageViewWaves": imageViewWaves]
            )
        )
        
        self.view.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat("V:[imageViewWaves]-(190)-|",
                options: NSLayoutFormatOptions(0),
                metrics: nil,
                views: ["imageViewWaves": imageViewWaves]
            )
        )
        
        // imageView: logo
        let imageView = UIImageView(
            image: UIImage(named: "pool-logo")
        )
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addSubview(imageView)
        
        self.view.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat("H:|-(50)-[imageView]-(50)-|",
                options: NSLayoutFormatOptions.AlignAllTop,
                metrics: nil,
                views: ["imageView": imageView]
            )
        )
        
        // label: tagline
        let titleLabel = UILabel()
        titleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        titleLabel.text             = "social accounting made easy"
        titleLabel.textColor        = UIColor.orangeColor()
        titleLabel.font             = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        titleLabel.textColor        = UIColor(red: 21 / 255, green: 124 / 255, blue: 244 / 255, alpha: 1)
        titleLabel.textAlignment    = NSTextAlignment.Center
        self.view.addSubview(titleLabel)
        
        self.view.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat("H:|-[titleLabel]-|",
                options: NSLayoutFormatOptions.AlignAllTop,
                metrics: nil,
                views: ["titleLabel": titleLabel]
            )
        )
        
        // view: background
        let backgroundView = UIView()
        backgroundView.setTranslatesAutoresizingMaskIntoConstraints(false)
        backgroundView.backgroundColor = UIColor(red: 204 / 255, green: 208 / 255, blue: 218 / 255, alpha: 1)
        backgroundView.layer.cornerRadius = 7.0
        self.view.addSubview(backgroundView)
        
        self.view.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat("H:|-[backgroundView]-|",
                options: NSLayoutFormatOptions.AlignAllTop,
                metrics: nil,
                views: ["backgroundView": backgroundView]
            )
        )
        
        self.view.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat("V:|-(230)-[backgroundView(==100)]",
                options: NSLayoutFormatOptions(0),
                metrics: nil,
                views: ["backgroundView": backgroundView]
            )
        )
        
        // textfield: user
        let userTextField = UITextField(frame: CGRectZero)
        userTextField.setTranslatesAutoresizingMaskIntoConstraints(false)
        let userTextFieldPlaceholder = NSAttributedString(string: "USER", attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
        userTextField.attributedPlaceholder         = userTextFieldPlaceholder
        userTextField.clearButtonMode               = UITextFieldViewMode.WhileEditing
        userTextField.leftViewMode                  = UITextFieldViewMode.Always
        //        userTextField.delegate                      = self
        userTextField.textAlignment                 = NSTextAlignment.Center
        userTextField.backgroundColor               =  UIColor.clearColor() //UIColor(red: 204 / 255, green: 208 / 255, blue: 218 / 255, alpha: 1)
        userTextField.becomeFirstResponder()
        self.view.addSubview(userTextField)
        
        self.view.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat("H:|-[userTextField(>=0)]-|",
                options: NSLayoutFormatOptions.AlignAllTop,
                metrics: nil,
                views: ["userTextField": userTextField]
            )
        )
        
        // textfield: password
        let passwordTextField = UITextField(frame: CGRectZero)
        passwordTextField.setTranslatesAutoresizingMaskIntoConstraints(false)
        let passwordTextFieldPlaceholder = NSAttributedString(string: "PASSWORD", attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
        passwordTextField.attributedPlaceholder         = passwordTextFieldPlaceholder
        passwordTextField.placeholder                   = "PASSWORD"
        passwordTextField.clearButtonMode               = UITextFieldViewMode.WhileEditing
        passwordTextField.leftViewMode                  = UITextFieldViewMode.Always
        passwordTextField.delegate                      = self
        passwordTextField.secureTextEntry               = true
        passwordTextField.textAlignment                 = NSTextAlignment.Center
        passwordTextField.backgroundColor               = UIColor.clearColor() //UIColor(red: 204 / 255, green: 208 / 255, blue: 218 / 255, alpha: 1)
        self.view.addSubview(passwordTextField)
        
        self.view.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat("H:|-[passwordTextField(>=0)]-|",
                options: NSLayoutFormatOptions.AlignAllTop,
                metrics: nil,
                views: ["passwordTextField": passwordTextField]
            )
        )
        
        // constraints: vertical
        self.view.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat("V:|-(75)-[imageView(==95)][titleLabel]-(40)-[userTextField(==50)][passwordTextField(==50)]",
                options: NSLayoutFormatOptions(0),
                metrics: nil,
                views: ["imageView": imageView, "titleLabel": titleLabel, "userTextField": userTextField, "passwordTextField": passwordTextField]
            )
        )
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
        
        if let _userHandle = textField.text {
            (UIApplication.sharedApplication().delegate as! AppDelegate).userHandle = _userHandle
        }
        
        self.navigationController?.pushViewController(ActivitiesViewController(), animated: true)
        
        return true
    }
}
