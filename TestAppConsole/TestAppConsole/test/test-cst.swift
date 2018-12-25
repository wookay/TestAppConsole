//
//  test-cst.swift
//  TestAppConsole
//
//  Created by wookyoung on 24/12/2018.
//  Copyright © 2018 wookyoung. All rights reserved.
//

import Foundation
import MuckoSwift
// import AppConsole

class TestCST: WTestCase {
    let cst = CST()

    @objc func test_IDENTIFIER() {
        let data = Data(string: """
            {"val": "f", "fullspan": 1, "span": 1}
        """)
        let id = cst.decode(IDENTIFIER.self, data: data)!
        Assert.True(id == IDENTIFIER(val: "f", fullspan: 1, span: 1))
    }

    @objc func test_EXPR() {
        let data = Data(string: """
            {"args":[{"fullspan":1,"span":1,"val":"f"}], "fullspan": 1, "span": 1}
        """)
        let id = cst.decode(EXPR.self, data: data)!
        Assert.equal(id.args[0], ["fullspan":1,"span":1,"val":"f"])
    }
}
