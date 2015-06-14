//
//  ScanViewController.swift
//  
//
//  Created by Thomas on 14/06/15.
//
//

import UIKit

class ScanViewController: UIViewController, GiniVisionDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Scan"
        
        // navigationBar
        self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Scan", style: UIBarButtonItemStyle.Plain, target: self, action: "rightBarButtonAction:")
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
        println("didScan")
        delegate.didEndUpload()
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
