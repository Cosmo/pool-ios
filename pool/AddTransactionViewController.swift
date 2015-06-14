//
//  AddTransactionViewController.swift
//  
//
//  Created by Devran Uenal on 14.06.15.
//
//

import UIKit
import XLForm
import Bolts
import Gini_iOS_SDK

class AddTransactionViewController: XLFormViewController, GiniVisionDelegate {
    let gini = (UIApplication.sharedApplication().delegate as! AppDelegate).giniSDK
    var amountField: XLFormRowDescriptor?
    var _id: String
    
    init(id: String) {
        self._id = id
        
        super.init(nibName: nil, bundle: nil)
        
        var form: XLFormDescriptor
        var section: XLFormSectionDescriptor
        var row: XLFormRowDescriptor
        
        form = XLFormDescriptor.formDescriptorWithTitle("AddTransaction") as! XLFormDescriptor
        
        section = XLFormSectionDescriptor.formSection() as! XLFormSectionDescriptor
        form.addFormSection(section)
        
        row = XLFormRowDescriptor(tag: "name", rowType: XLFormRowDescriptorTypeName, title: "Name")
        section.addFormRow(row)
        
        self.amountField = XLFormRowDescriptor(tag: "amount", rowType: XLFormRowDescriptorTypeNumber, title: "Amount")
        section.addFormRow(amountField)
        
        row = XLFormRowDescriptor(tag: "fee", rowType: XLFormRowDescriptorTypeNumber, title: "Tip or Fee")
        section.addFormRow(row)
        
//        row = XLFormRowDescriptor(tag: "currency", rowType: XLFormRowDescriptorTypeName, title: "Currency")
//        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: "currency", rowType: XLFormRowDescriptorTypeSelectorPush, title: "Currency")
        row.selectorTitle = "Currency"
        row.selectorOptions = [
            XLFormOptionsObject(value: 0, displayText: "EUR"),
            XLFormOptionsObject(value: 1, displayText: "USD"),
            XLFormOptionsObject(value: 2, displayText: "TRY"),
            XLFormOptionsObject(value: 3, displayText: "JPY"),
            XLFormOptionsObject(value: 4, displayText: "GBP"),
            XLFormOptionsObject(value: 5, displayText: "AUD"),
            XLFormOptionsObject(value: 6, displayText: "CHF"),
            XLFormOptionsObject(value: 7, displayText: "CAD"),
            XLFormOptionsObject(value: 8, displayText: "MXN")
        ]
        row.value = []
        section.addFormRow(row)
        
        
        self.form = form
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add Transaction"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "cancel:")
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "saveTransaction:"),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Camera, target: self, action: "scanInvoice:")
        ]
        
        self.gini.sessionManager.getSession()
    }
    
    func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func scanInvoice(button: UIBarButtonItem) {
        println("scanInvoice:")
        GiniVision.captureImageWithViewController(self, delegate: self)
    }
    
    func saveTransaction(sender: AnyObject) {
        println(self.httpParameters())
        
        let currencies = [
            "eur",
            "usd",
            "try",
            "jpy",
            "gbp",
            "aud",
            "chf",
            "cad",
            "mxn"
        ]
        
        if
            let name = self.httpParameters()["name"] as? String,
            let amount = self.httpParameters()["amount"] as? Int,
            let fee = self.httpParameters()["fee"] as? Int,
            let currencyIndex = self.httpParameters()["currency"] as? Int
        {
            let body: [String: AnyObject] = [
                "name":     name,
                "amount":   amount,
                "fee":      fee,
                "currency": currencies[currencyIndex]
            ]
            
            println("sending ...")
            println(body)
            
            Transaction.new(_id)?.bodyParameters(body).method("POST").success({ (data, response) -> () in
                self.dismissViewControllerAnimated(true, completion: nil)
            }).call()
        }
    }
    
    // gini delegates
    func didScan(document: UIImage!, documentType docType: GINIDocumentType, uploadDelegate delegate: GINIVisionUploadDelegate!) {
        println("didScan:")
        
        let manager = self.gini.documentTaskManager
        self.gini.sessionManager.getSession().continueWithSuccessBlock { (task: BFTask!) -> AnyObject! in
            println("didScan:task")
            return manager.createDocumentWithFilename("new-document", fromImage: document)
            }.continueWithSuccessBlock { (createTask: BFTask!) -> AnyObject! in
                println("didScan:createTask")
                let document: AnyObject! = createTask.result()
                return document.extractions
            }.continueWithSuccessBlock { (extractionsTask: BFTask!) -> AnyObject! in
                println("didScan:extractionsTask")
                let extractions: AnyObject! = extractionsTask.result()
                
                println("didScan:extractions: \(extractions)")
                
                dispatch_async(dispatch_get_main_queue(), {
                    if let _amountField = self.amountField {
                        if let extractions = extractions as? NSDictionary {
                            for (key, value) in extractions {
                                println("extraction key: \(key), value: \(value)")
                                
                                if (key as! String) == "amountToPay" {
                                    if let _value = value as? GINIExtraction {
                                        let matches = _value.value.matchesOf(/"\\d")
                                        let extractedAmount = "".join(matches)
                                        
                                        println("extractedAmount: \(extractedAmount)")
                                        
                                        _amountField.value = extractedAmount
                                    }
                                }
                            }
                        }
                        self.reloadFormRow(self.amountField)
                    }

                    delegate.didEndUpload()
                })
                
                return nil
        }
    }
    
    func didScanOriginal(image: UIImage!) {
        println("didScanOriginal")
    }
    
    func didFinishCapturing(success: Bool) {
        println("didFinishCapturing")
    }
}
