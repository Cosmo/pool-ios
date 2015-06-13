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
    }
}