//
//  appconsole.swift
//  TestAppConsole
//
//  Created by wookyoung on 18/12/2018.
//  Copyright © 2018 wookyoung. All rights reserved.
//

import MuckoSwift
//import AppConsole

class TestAppConsole: WTestCase {
    @objc func test_appconsole() {
        let console = AppConsole()
        Assert.True(isa(console, AppConsole.self))
    }
}
