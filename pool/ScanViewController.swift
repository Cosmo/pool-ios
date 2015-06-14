//
//  ScanViewController.swift
//  
//
//  Created by Thomas on 14/06/15.
//
//

import UIKit

class ScanViewController: UIViewController, GiniVisionDelegate {
    let sdk = (UIApplication.sharedApplication().delegate as! AppDelegate).giniSDK

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Scan"
        
        // navigationBar
        self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Scan", style: UIBarButtonItemStyle.Plain, target: self, action: "rightBarButtonAction:")
        
        self.sdk.sessionManager.getSession()
    }
    
    func rightBarButtonAction(button: UIBarButtonItem) {
        GiniVision.captureImageWithViewController(self, delegate: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // gini delegates
    func didScan(document: UIImage!, documentType docType: GINIDocumentType, uploadDelegate delegate: GINIVisionUploadDelegate!) {
        println("didScan:")
        
        let manager = self.sdk.documentTaskManager
        self.sdk.sessionManager.getSession().continueWithSuccessBlock { (task: BFTask!) -> AnyObject! in
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
