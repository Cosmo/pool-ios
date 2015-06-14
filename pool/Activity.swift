//
//  Activity.swift
//  Pool
//
//  Created by Devran Uenal on 13.06.15.
//  Copyright (c) 2015 PoolParty. All rights reserved.
//

import Foundation

struct Activity: Deserializable {
    var id:           String?
    var name:         String?
    var transactions: [Transaction]?
    var master:       User?
    var users:        [User]?
    var total:        Total?
    
    init(data: [String: AnyObject]) {
        id            <-- data["_id"]
        name          <-- data["name"]
        transactions  <-- data["transactions"]
        users         <-- data["users"]
        master        <-- data["master"]
        total         <-- data["total"]
    }
    
    static func all() -> Api? {
        return Api().path("/activities")
    }
    
    static func detail(id: String) -> Api? {
        return Api().path("/activities/\(id)")
    }

    static func new() -> Api? {
        return Api().path("/activities")
    }
    
    static func invite(id: String, name: String) -> Api? {
        return Api().path("/activities/\(id)/invite/\(name)")
    }
}
