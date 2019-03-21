//
//  Simple_ExchangeTests.swift
//  Simple ExchangeTests
//
//  Created by Daniel Nall on 3/15/19.
//  Copyright © 2019 Daniel Nall. All rights reserved.
//

import XCTest
@testable import SimplExchange

class SimplExchangeTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testBasketTotal() {
        let basket = ShoppingBasket(peas: 1, eggs: 1, milk: 1, beans: 1)
        let checkoutViewModel = CheckoutViewModel(basket: basket)
        
        let expectedTotal = (Double(basket.bagsOfPeas) * 0.95) + (Double(basket.dozensOfEggs) * 2.10) + (Double(basket.bottlesOfMilk) * 1.30) + (Double(basket.cansOfBeans) * 0.73)
        let expectedString = String(format: "%.2f", expectedTotal)
        
        XCTAssert(checkoutViewModel.basketTotal == expectedTotal)
        XCTAssert(checkoutViewModel.totalString == expectedString)
    }

}
