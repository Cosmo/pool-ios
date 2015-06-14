//
//  AddTransactionViewController.swift
//  
//
//  Created by Devran Uenal on 14.06.15.
//
//

import UIKit
import XLForm

class AddTransactionViewController: XLFormViewController {
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
        
        row = XLFormRowDescriptor(tag: "amount", rowType: XLFormRowDescriptorTypeNumber, title: "Amount")
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: "fee", rowType: XLFormRowDescriptorTypeNumber, title: "Tip or Fee")
        section.addFormRow(row)
        
        self.form = form
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add Transaction"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "saveTransaction:")
    }
    
    func saveTransaction(sender: AnyObject) {
        println(self.httpParameters())
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
