//
//  RequestHelper.swift
//

import Foundation

class Api: Request {
    var apiAddress: String {
        get {
            return "https://pool-app.herokuapp.com"
        }
    }
    
    func path(path: String) -> Self {
        self.urlString(self.apiAddress + path)
        return self
    }
    
    override init() {
        super.init()
        if var _userHandle = (UIApplication.sharedApplication().delegate as! AppDelegate).userHandle {
            println("userHandle: \(_userHandle)")
            self.headers = ["x-header": "\(_userHandle)", "Content-Type": "application/json"]
        } else {
            println("userHandle: maccosmo")
            self.headers = ["x-header": "maccosmo", "Content-Type": "application/json"]
        }
    }
}