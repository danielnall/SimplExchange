//
//  ShoppingBasket.swift
//  Simple Exchange
//
//  Created by Daniel Nall on 3/15/19.
//  Copyright © 2019 Daniel Nall. All rights reserved.
//

import Foundation

struct ShoppingBasket {
    let bagsOfPeas: Int
    let dozensOfEggs: Int
    let bottlesOfMilk: Int
    let cansOfBeans: Int
    
    init(peas: Int, eggs: Int, milk: Int, beans: Int) {
        bagsOfPeas = peas
        dozensOfEggs = eggs
        bottlesOfMilk = milk
        cansOfBeans = beans
    }
}
