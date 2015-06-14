//
//  AddActivityViewController.swift
//  
//
//  Created by Devran Uenal on 14.06.15.
//
//

import UIKit
import XLForm

class AddActivityViewController: XLFormViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
        
        var form: XLFormDescriptor
        var section: XLFormSectionDescriptor
        var row: XLFormRowDescriptor
        
        form = XLFormDescriptor.formDescriptorWithTitle("AddTransaction") as! XLFormDescriptor
        
        section = XLFormSectionDescriptor.formSection() as! XLFormSectionDescriptor
        form.addFormSection(section)
        
        row = XLFormRowDescriptor(tag: "name", rowType: XLFormRowDescriptorTypeName, title: "Name")
        section.addFormRow(row)
        
        self.form = form
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "New Activity"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "cancelActivity:")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "saveActivity:")
    }
    
    func cancelActivity(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func saveActivity(sender: AnyObject) {
        println(self.httpParameters())
        
        if let name = self.httpParameters()["name"] as? String {
            let body = [
                "name": name
            ]
            
            Activity.new()?.bodyParameters(body).method("POST").success({ (data, response) -> () in
                self.dismissViewControllerAnimated(true, completion: nil)
            }).call()
        }
    }
}
