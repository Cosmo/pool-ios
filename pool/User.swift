//
//  User.swift
//  Pool
//
//  Created by Devran Uenal on 13.06.15.
//  Copyright (c) 2015 PoolParty. All rights reserved.
//

import Foundation

struct User: Deserializable {
    var name:     String?
    var amount:   Int?
    var currency: String?
    
    init(data: [String: AnyObject]) {
        name      <-- data["name"]
        amount    <-- data["amount"]
        currency  <-- data["currency"]
    }
}
