//
//  Transaction.swift
//  Pool
//
//  Created by Devran Uenal on 13.06.15.
//  Copyright (c) 2015 PoolParty. All rights reserved.
//

import Foundation

struct Transaction: Deserializable {
    var amount:     Int?
    var fee:        Int?
    var currency:   String?
    var user:       User?
    
    init(data: [String: AnyObject]) {
        amount    <-- data["amount"]
        fee       <-- data["fee"]
        currency  <-- data["currency"]
        user      <-- data["user"]
    }
}
