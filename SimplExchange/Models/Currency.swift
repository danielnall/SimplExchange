//
//  Currency.swift
//  SimplExchange
//
//  Created by Daniel Nall on 3/21/19.
//  Copyright © 2019 Daniel Nall. All rights reserved.
//

import Foundation

struct Currency {
    var name: String
    var code: String
    
    init(currencyName: String, currencyCode: String) {
        self.name = currencyName
        self.code = currencyCode
    }
}
