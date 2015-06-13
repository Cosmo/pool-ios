//
//  Total.swift
//  Pool
//
//  Created by Devran Uenal on 13.06.15.
//  Copyright (c) 2015 PoolParty. All rights reserved.
//

import Foundation

struct Total: Deserializable {
    var amount:   Int?
    var currency: String?
    
    init(data: [String: AnyObject]) {
        amount    <-- data["amount"]
        currency  <-- data["currency"]
    }
}
